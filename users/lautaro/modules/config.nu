def git-ahead-behind [] {
    let upstream = (do { git rev-parse --abbrev-ref "@{upstream}" } | complete)
    if $upstream.exit_code != 0 { return "" }

    let counts = (do { git rev-list --left-right --count "HEAD...@{upstream}" } | complete)
    if $counts.exit_code != 0 { return "" }

    let parts = ($counts.stdout | str trim | split column "\t" ahead behind | get 0)
    let ahead  = ($parts.ahead  | into int)
    let behind = ($parts.behind | into int)

    mut out = ""
    if $ahead  > 0 { $out = $"($out) ↑($ahead)"  }
    if $behind > 0 { $out = $"($out) ↓($behind)" }
    $out | str trim
}

def jj-ahead-behind [] {
    let ahead  = (do { jj log -r 'count(@ ~ remote_bookmarks())' -T '' } | complete)
    let behind = (do { jj log -r 'count(remote_bookmarks() ~ @)' -T '' } | complete)
    let a = if $ahead.exit_code  == 0 { $ahead.stdout  | str trim | into int } else { 0 }
    let b = if $behind.exit_code == 0 { $behind.stdout | str trim | into int } else { 0 }

    mut out = ""
    if $a > 0 { $out = $"($out) ↑($a)" }
    if $b > 0 { $out = $"($out) ↓($b)" }
    $out | str trim
}

def prompt-jj [] {
    if (which jj | is-empty) { return null }
    let check = (do { jj log -r @ --no-graph -T '' } | complete)
    if $check.exit_code != 0 { return null }

    let full   = (jj log -r @ --no-graph -T 'change_id.short()')
    let prefix = (jj log -r @ --no-graph -T 'change_id.shortest()')
    let suffix = ($full | str substring (($prefix | str length)..))
    let div    = (jj-ahead-behind)

    {type: "jj", ref: "@", rev: $"($prefix)($suffix)", div: $div}
}

def prompt-git [] {
    if (which git | is-empty) { return null }
    let check = (do { git rev-parse --is-inside-work-tree } | complete)
    if $check.exit_code != 0 { return null }

    let branch = (git rev-parse --abbrev-ref HEAD | str trim)
    let commit = (do { git rev-parse HEAD } | complete |
        if $in.exit_code == 0 { $in.stdout | str trim | str substring ..8 } else { "" })
    let div = (git-ahead-behind)

    {type: "git", ref: $branch, rev: $commit, div: $div}
}

def create_left_prompt [] {
    let project = (pwd | path basename)
    let nixenv  = if ("IN_NIX_SHELL" in $env) {
        if ("DEVSHELL_NAME" in $env) { $env.DEVSHELL_NAME } else { "nix" }
    } else { "" }

    let vcs = (prompt-jj | if $in == null { prompt-git } else { $in })

    mut out = $"(ansi cyan)($project)(ansi reset)"

    if ($nixenv | str length) > 0 {
        $out = $"($out)(ansi blue_bold) [($nixenv)](ansi reset)"
    }

    if $vcs != null {
        let type = $vcs.type
        let ref  = $vcs.ref
        let rev  = $vcs.rev
        let div  = $vcs.div

        if $type == "jj" {
            $out = $"($out)(ansi purple_bold) ($ref)(ansi yellow_bold)($rev)(ansi reset)"
        } else {
            $out = $"($out)(ansi yellow_bold) ($ref)(ansi green_bold)@(ansi dark_gray)($rev)(ansi reset)"
        }

        if ($div | str length) > 0 {
            $out = $"($out)(ansi yellow)($div)(ansi reset)"
        }
    }

    $out
}

def create_right_prompt [] { "" }

$env.PROMPT_COMMAND       = { create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { create_right_prompt }
$env.PROMPT_INDICATOR            = " > "
$env.PROMPT_INDICATOR_VI_INSERT  = " > "
$env.PROMPT_INDICATOR_VI_NORMAL  = " > "

$env.config = ($env.config | upsert show_banner false)
$env.config.edit_mode = 'vi'

alias c         = cargo
alias m         = make
alias g         = git
alias k         = kubectl

alias j = jj
alias jjj = jj
alias js = jj status
alias jd = jj diff
alias jn = jj new
alias jsm = jj bookmark set main
alias jh = jj log -r \'heads(all())\'
alias jjp = jj git push

alias ga        = git add
alias glr       = pretty_git_log
alias co        = git checkout
alias gap       = git add -p
alias gc        = git commit
alias gd        = git diff
alias gs        = git status
alias gp        = git push
alias gl        = git dl
alias ct        = cargo t
alias vim       = nvim
alias tma       = tmux attach

def multicd [dots: string] {
    let n = ($dots | str length) - 1
    cd ([".."] * $n | path join)
}

export def --wrapped dotdot [...rest] {
    multicd $rest.0
}

def gpr [pr: int] {
    git fetch upstream $"pull/($pr)/head:pr-($pr)"
    git checkout $"pr-($pr)"
}

def git_hash [] {
    if (^git rev-parse --is-inside-work-tree | complete | get exit_code) == 0 {
        let branch = (^git rev-parse --abbrev-ref HEAD | str trim)
        let commit = (^git rev-parse HEAD | str trim | str substring 0..8)
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


let os_name = (open /etc/os-release
    | lines
    | where $it =~ 'PRETTY_NAME='
    | first
    | str replace 'PRETTY_NAME=' ''
    | str trim -c '"')

let uname_info = (uname)
let kernel     = $uname_info.kernel-release
let host       = $uname_info.nodename

let uptime_sec = (open /proc/uptime | split row " " | get 0 | into float)
let uptime_hr  = ($uptime_sec / 3600 | math round -p 2)

let df     = (^df -h / | lines | skip 1 | first | split row -r '\s+')
let device = ($df | get 0)
let total  = ($df | get 1)
let used   = ($df | get 2)
let pct    = ($df | get 4)
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

let netline   = (^ip -brief addr show
    | lines
    | where { |l| $l !~ ' lo ' and $l =~ 'UP' }
    | first
    | str)

let net_parts = ($netline | split row -r '\s+')

$net_parts |  table

let iface = ($net_parts | get 0)
let ip = (
  $net_parts
  | where { |x| $x =~ '^\d+\.\d+\.\d+\.\d+/' }
  | first
  | default ""
  | split row '/'
  | get 0
)

print $"
 (ansi cyan_bold)OS:(ansi reset)      (ansi yellow)($os_name)(ansi reset) •  (ansi cyan_bold)Kernel:(ansi reset) (ansi yellow)($kernel)(ansi reset)
 (ansi cyan_bold)Host:(ansi reset)    (ansi yellow)($host)(ansi reset) •  (ansi cyan_bold)Uptime:(ansi reset) (ansi yellow)($uptime_hr) hr(ansi reset)
 (ansi cyan_bold)Network:(ansi reset) (ansi yellow)($iface)(ansi reset) (ansi green)UP(ansi reset) - (ansi yellow)($ip)(ansi reset)
 (ansi cyan_bold)Storage:(ansi reset) (ansi yellow)($device)(ansi reset) •  (ansi cyan_bold)Used:(ansi reset) (ansi yellow)($used)/($total) (ansi $pct_color)($pct)(ansi reset)
"


source ~/.local/share/atuin/init.nu
