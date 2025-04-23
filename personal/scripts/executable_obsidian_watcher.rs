#!/usr/bin/env -S cargo +nightly -Zscript --quiet

---
[package]
name = "obsidian_pdf_watcher"
version = "0.1.0"
edition = "2024"

[dependencies]
color-eyre = "0.6.3"
notify = "6.1"
tracing = "0.1.41"
tracing-subscriber = "0.3.19"
---

use color_eyre::eyre;
use color_eyre::owo_colors::OwoColorize;
use notify::{EventKind, RecursiveMode, Result, Watcher};
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::mpsc::channel;
use std::thread;
use std::time::Duration;
use tracing::info;

fn setup() -> eyre::Result<()> {
    color_eyre::install()?;
    tracing_subscriber::fmt()
        .compact()
        .with_max_level(tracing::Level::INFO)
        .with_ansi(true)
        .init();

    Ok(())
}

fn handle_new_pdf(pdf_path: &Path, parent_dir: &Path) {
    let name_tag = {
        let folder = parent_dir
            .file_name()
            .and_then(|name| name.to_str())
            .unwrap_or("unknown");

        folder.replace(" ", "_")
    };

    let notes_dir = parent_dir.join("apuntes");

    if !notes_dir.exists() {
        if let Err(e) = fs::create_dir_all(&notes_dir) {
            info!("Failed to create notes directory: {}", e);
            return;
        }
    }

    if let Some(stem) = pdf_path.file_stem().and_then(|s| s.to_str()) {
        let md_path = notes_dir.join(format!("{}.md", stem));
        if md_path.exists() {
            info!(
                "Markdown file already exists: {:?}",
                md_path.bright_yellow().bold()
            );
            return;
        }

        let pdf_name = pdf_path.file_name().unwrap().to_string_lossy();

        let content = format!(
            "---\ntags:\n- {}\nLeido: No\nResumido: No\nAnki: No\n---\n\n# {}\n[📖 Ver PDF](../libros/{})\n",
            name_tag, stem, pdf_name
        );

        if let Err(e) = fs::write(&md_path, content) {
            info!(
                "Failed to write markdown file: {}",
                e.bright_yellow().bold()
            );
        } else {
            info!(
                "Created: {:?} with tag '{}'",
                md_path.bright_yellow().bold(),
                name_tag.bright_blue().bold()
            );
        }
    }
}

fn process_existing_pdfs(dir_paths: &HashMap<PathBuf, PathBuf>) -> Result<()> {
    for (libros_dir, parent_dir) in dir_paths {
        info!(
            "Processing existing PDFs in {:?}",
            libros_dir.bright_magenta().bold()
        );

        for entry in fs::read_dir(libros_dir)? {
            if let Ok(entry) = entry {
                let path = entry.path();
                if path.extension().map_or(false, |ext| ext == "pdf") {
                    info!("Found existing PDF: {:?}", path.bright_yellow().bold());
                    handle_new_pdf(&path, parent_dir);
                }
            }
        }
    }

    Ok(())
}

fn main() -> eyre::Result<()> {
    setup()?;
    let vault_dir = PathBuf::from("/home/lautaro/personal/notes/100 UTN/");

    if !vault_dir.exists() {
        info!(
            "Vault directory doesn't exist: {:?}",
            vault_dir.bright_purple().bold()
        );
        return Ok(());
    }

    let mut libros_dirs = HashMap::new();

    for entry in fs::read_dir(&vault_dir)? {
        if let Ok(entry) = entry {
            let subject_path = entry.path();
            if subject_path.is_dir() {
                let libros_path = subject_path.join("libros");

                if !libros_path.exists() {
                    fs::create_dir_all(&libros_path)?;
                    info!("Created directory: {:?}", libros_path.bright_cyan().bold());
                }

                libros_dirs.insert(libros_path, subject_path);
            }
        }
    }

    info!("Found {} subject directories to watch", libros_dirs.len());
    for (libros_dir, subject_dir) in &libros_dirs {
        info!(
            "- {:?} (parent: {:?})",
            libros_dir.bright_green().bold(),
            subject_dir
                .file_name()
                .unwrap_or_default()
                .bright_blue()
                .bold()
        );
    }

    if let Err(e) = process_existing_pdfs(&libros_dirs) {
        info!("Error processing existing PDFs: {}", e.bright_red().bold());
    }

    let (tx, rx) = channel();
    let mut watcher = notify::recommended_watcher(tx)?;

    for libros_dir in libros_dirs.keys() {
        watcher.watch(libros_dir, RecursiveMode::NonRecursive)?;
        info!(
            "Watching for PDFs in: {:?}",
            libros_dir.bright_magenta().bold()
        );
    }

    thread::sleep(Duration::from_millis(500));

    info!("Watcher setup complete. Waiting for new PDFs...");

    for res in rx {
        match res {
            Ok(event) => {
                info!("Event detected: {:?}", event);
                match event.kind {
                    EventKind::Create(_) | EventKind::Modify(_) => {
                        for path in event.paths {
                            if path.extension().map_or(false, |ext| ext == "pdf") {
                                info!("New PDF detected: {:?}", path.bright_green().bold());

                                if let Some(parent) = path.parent() {
                                    if let Some(subject_dir) = libros_dirs.get(parent) {
                                        handle_new_pdf(&path, subject_dir);
                                    } else {
                                        info!(
                                            "Could not find subject directory for PDF: {:?}",
                                            path.bright_green().bold()
                                        );
                                    }
                                }
                            }
                        }
                    }
                    _ => {}
                }
            }
            Err(e) => info!("Watch error: {:?}", e.bright_red().bold()),
        }
    }

    Ok(())
}
