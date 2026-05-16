{ pkgs, inputs, ... }:

{
  home.username = "lautaro";
  home.homeDirectory = "/home/lautaro";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    eza
    tree
    wget
    curl
    unzip
    htop
    atuin
    zoxide
  ];

  imports = [
    ./modules/git.nix
    ./modules/jj.nix
    ./modules/nushell.nix
    ./modules/sway.nix
    ./modules/helix.nix
    ./modules/direnv.nix
    ./modules/ghostty.nix
    ./modules/tmux.nix
  ];

  home.file.".local/bin/toggle-theme.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      current=$(/run/current-system/sw/bin/dconf read /org/gnome/desktop/interface/color-scheme)
      if [ "$current" = "'prefer-light'" ]; then
        /run/current-system/sw/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      else
        /run/current-system/sw/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
      fi
    '';
  };
}
