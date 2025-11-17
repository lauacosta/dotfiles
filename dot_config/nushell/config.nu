$env.config.edit_mode = 'vi'

alias c = cargo
alias nix-shell = ^nix-shell --command fish
alias m = make
alias g = git
alias k = kubectl
alias j = jj
alias jjj = jj
alias ga = git add
alias glr = pretty_git_log
alias co = git checkout
alias gap = git add -p
alias gc = git commit
alias gd = git diff
alias gs = git status
alias gp = git push
alias gl = git dl
alias ct = cargo t
alias vim = nvim
alias tma = tmux attach

if (which eza | is-empty) {
    alias l = ls
    alias ll = ls -l
    alias lll = ls -la
} else {
    alias l = eza
    alias ls = eza
    alias ll = eza -l
    alias lll = eza -la
}


def multicd [dots: string] {
    let n = ($dots | str length) - 1
    cd ([".."] * $n | path join)
}

export def --wrapped dotdot [...rest] {
    multicd $rest.0
}


def gpr [pr:int] {
    git fetch upstream $"pull/($pr)/head:pr-($pr)"
    git checkout $"pr-($pr)"
}

def git_hash [] {
    if ( ^git rev-parse --is-inside-work-tree | complete | get exit_code ) == 0 {
        let branch = ( ^git rev-parse --abbrev-ref HEAD | str trim )
        let commit = ( ^git rev-parse HEAD | str trim | str substring 0..8 )
        $"[($branch) ($commit)]"
    }
}

def yy [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let new = (open $tmp | str trim)
    if ($new != "" and $new != $env.PWD) {
        cd $new
    }
    rm $tmp
}

$env.config = ($env.config | upsert show_banner false)

let os_name = (open /etc/os-release | lines | where $it =~ 'PRETTY_NAME=' | first | str replace 'PRETTY_NAME=' '' | str trim -c '"')
let uname_info = (uname)
let kernel = $uname_info.kernel-release
let host = $uname_info.nodename

let uptime_sec = (open /proc/uptime | split row " " | get 0 | into float)
let uptime_hr = ($uptime_sec / 3600 | math round -p 2)

let df = (^df -h / | lines | skip 1 | first | split row -r '\s+')
let device = ($df | get 0)
let total = ($df | get 1)
let used = ($df | get 2)
let pct = ($df | get 4)

let pct_num = ($pct | str replace '%' '' | into int)
let pct_color = if $pct_num >= 90 {
    "red_bold"
} else if $pct_num >= 70 {
    "red"
} else if $pct_num >= 50 {
    "yellow"
} else {
    "green"
}

let netline = (^ip -brief addr show | lines | where { |l| $l !~ ' lo ' and $l =~ 'UP' } | first | str trim)
let net_parts = ($netline | split row -r '\s+')
let iface = ($net_parts | get 0)
let ip = ($net_parts | where { |x| $x =~ '^\d+\.\d+\.\d+\.\d+/' } | first | split row '/' | get 0)

print $"
 (ansi cyan_bold)OS:(ansi reset)      (ansi yellow)($os_name)(ansi reset) •  (ansi cyan_bold)Kernel:(ansi reset) (ansi yellow)($kernel)(ansi reset)
 (ansi cyan_bold)Host:(ansi reset)    (ansi yellow)($host)(ansi reset) •  (ansi cyan_bold)Uptime:(ansi reset) (ansi yellow)($uptime_hr) hr(ansi reset)
 (ansi cyan_bold)Network:(ansi reset) (ansi yellow)($iface)(ansi reset) (ansi green)UP(ansi reset) - (ansi yellow)($ip)(ansi reset)
 (ansi cyan_bold)Storage:(ansi reset) (ansi yellow)($device)(ansi reset) •  (ansi cyan_bold)Used:(ansi reset) (ansi yellow)($used)/($total) (ansi $pct_color)($pct)(ansi reset)
"
