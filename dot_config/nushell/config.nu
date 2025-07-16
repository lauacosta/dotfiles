mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.local/share/atuin/init.nu

alias c = cargo
alias m = make
alias g = git
alias k = kubectl
alias j = just
alias ga = git add
alias glr = pretty_git_log
alias co = git checkout
alias gpr = gh pr create
alias gap = git add -p
alias gc = git commit
alias gd = git diff
alias gs = git status
alias gp = git push
alias gl = git log -1 HEAD
alias ct = cargo t
alias vim = nvim
alias tma = tmux attach

$env.PATH = ($env.PATH | default [] | prepend [
    "/usr/local/go/bin"
    "/home/lautaro/personal/apps/zen"
    "/home/lautaro/personal/apps/RustRover-2025.1.2/bin"
    "/home/lautaro/personal/apps/ltex-ls-plus/bin"
    "/home/lautaro/.dotnet/tools"
    "/home/lautaro/.config/emacs/bin"
<<<<<<< Updated upstream
    "/home/lautaro/.local/share/pnpm"
=======
>>>>>>> Stashed changes
    "/home/lautaro/personal/apps/zig"
    ($env.HOME + "/.cargo/bin")
    ($env.HOME + "/go/bin")
    "/home/lautaro/.opencode/bin"
])

def multicd [dots: string] {
    let count = ($dots | str length) - 1
    cd (["../"] * $count | str join)
}

alias dotdot = multicd

$env.config = {
    edit_mode: vi
    show_banner: false
    hooks: {
        pre_prompt: [
            {||
                if not ($env | get -i BANNER_SHOWN | default "false" | into bool) {
                    show-system-info
                    print ""
                    $env.BANNER_SHOWN = true
                }
            }
        ]
    }
}

def show-system-info [] {
    let sys = (sys host)
    let disk = (sys disks | where mount == "/" | get 0)
    
    let used_bytes = ($disk.total - $disk.free)
    let used_percent = (($used_bytes / $disk.total) * 100 | math round -p 1)
    
    let g = "#b8bb26"  
    let y = "#fabd2f"  
    let b = "#83a598"  
    let dim = "#a89984" 
    let r = "#fb4934"  
    
    let network_info = (try {
        let net = (^ip -brief addr show | lines | where $it !~ "lo" | where $it =~ "UP" | get 0)
        let iface = ($net | split row " " | get 0)
        let ip = ($net | split row " " | where $it != "" | where $it != "UP" | get 1)
        $"(ansi $b)($iface)(ansi reset) (ansi $g)UP(ansi reset) - ($ip)"
    } catch {
        $"(ansi $r)No active connections(ansi reset)"
    })
    
    print $"(ansi $dim)OS:(ansi reset)      (ansi $y)($sys.name)(ansi reset) • (ansi $dim)Kernel:(ansi reset) ($sys.kernel_version)"
    print $"(ansi $dim)Host:(ansi reset)    (ansi $b)($sys.hostname)(ansi reset) • (ansi $dim)Uptime:(ansi reset) (ansi $g)($sys.uptime | into duration | format duration hr)(ansi reset)"
    print $"(ansi $dim)Network:(ansi reset) ($network_info)"
    print $"(ansi $dim)Storage:(ansi reset) (ansi $b)($disk.device)(ansi reset) (ansi $dim)($disk.kind)(ansi reset) • (ansi $dim)Mount:(ansi reset) ($disk.mount) • (ansi $dim)Used:(ansi reset) (ansi $y)($used_bytes | into filesize)(ansi reset)/(ansi $g)($disk.total | into filesize)(ansi reset) (ansi $y)($used_percent)%(ansi reset)"
}
