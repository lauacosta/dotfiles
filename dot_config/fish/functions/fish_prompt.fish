function __prompt_project
    echo (basename (pwd))
end

function __prompt_nix
    if set -q IN_NIX_SHELL
        if set -q DEVSHELL_NAME
            printf "%s\n" $DEVSHELL_NAME
        else
            printf "%s\n" "nix"
        end
    end
end

function __prompt_jj
    command -sq jj; or return
    jj log -r @ --no-graph -T '' >/dev/null 2>&1; or return

    set -l full   (jj log -r @ --no-graph -T 'change_id.short()')
    set -l prefix (jj log -r @ --no-graph -T 'change_id.shortest()')

    set -l suffix (string sub --start (math (string length $prefix) + 1) $full)

    printf "%s\n" "@" "$prefix" "$suffix"
end

function __prompt_git
    command -sq git; or return
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set commit (git rev-parse HEAD 2>/dev/null | string replace -r '^(.{0,8}).*' '$1')

        printf "%s\n" "$branch" "$commit"
    end
end

function fish_prompt
    set -l project (basename (pwd))

    set -l nixenv (__prompt_nix)

    set -l vcs (__prompt_jj)

    if test (count $vcs) -eq 0
        set vcs (__prompt_git)
    end

    set_color cyan
    printf "%s" $project

    if test -n "$nixenv"
        set_color --bold blue
        printf " [%s]" $nixenv
    end

    if test (count $vcs) -ge 3
        set -l ref    $vcs[1]
        set -l prefix $vcs[2]
        set -l suffix $vcs[3]

        set_color --bold green 
        printf " %s" $ref

        set_color --bold magenta
        printf "%s" $prefix

        set_color brblack
        printf "%s" $suffix
    else if test (count $vcs) -ge 2
        set -l ref  $vcs[1]
        set -l rev  $vcs[2]

        set_color --bold bryellow
        printf " %s" $ref

        set_color --bold brgreen
        printf "@"

        set_color brblack
        printf "%s" $rev
    end

    set_color normal
    printf "\n> "
end
