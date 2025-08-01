theme_gruvbox dark hard
starship init fish | source
atuin init fish | source

set -g fish_key_bindings fish_vi_key_bindings
abbr -a c cargo
abbr -a nix-shell 'nix-shell --command fish'
abbr -a m make
abbr -a g git
abbr -a k kubectl
abbr -a j just
abbr -a ga 'git add'
abbr -a glr pretty_git_log
abbr -a co 'git checkout'
abbr -a gap 'git add -p'
abbr -a gc 'git commit'
abbr -a gd 'git diff'
abbr -a gs 'git status'
abbr -a gp 'git push'
abbr -a gl 'git log -1 HEAD'
abbr -a ct 'cargo t'
abbr -a vim nvim
abbr -a tma 'tmux attach'

set -gx DOCKER_BUILDKIT 1

if command -v exa >/dev/null
    abbr -a l exa
    abbr -a ls exa
    abbr -a ll 'exa -l'
    abbr -a lll 'exa -la'
else
    abbr -a l ls
    abbr -a ll 'ls -l'
    abbr -a lll 'ls -la'
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

function gpr
    set pr $argv[1]
    git fetch upstream pull/$pr/head:pr-$pr
    git checkout pr-$pr
end

abbr --add dotdot --regex '^\.\.+$' --function multicd

function git_hash
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set commit (git rev-parse HEAD 2>/dev/null | string replace -r '^(.{0,8}).*' '$1')

        if test -z "$commit"
            echo -n "[$branch (no commits)]"
        else
            echo -n "[$branch $commit]"
        end
    end
end

function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function fish_greeting
    # Colors
    set -l g (set_color normal; set_color '#b8bb26')
    set -l y (set_color normal; set_color '#fabd2f')
    set -l b (set_color normal; set_color '#83a598')
    set -l dim (set_color normal; set_color '#a89984')
    set -l r (set_color normal; set_color '#fb4934')
    set -l reset (set_color normal)

    set -l os_name (grep -oP '(?<=^PRETTY_NAME=)"?\K[^"]+' /etc/os-release 2>/dev/null)

    set -l kernel (uname -r)
    set -l host $hostname

    set -l uptime_sec (cat /proc/uptime | awk '{print int($1)}')
    set -l uptime_hr (math --scale 2 "$uptime_sec / 3600")

    set -l storage_info ""

    set -l df_line (df -h / | grep -v Filesystem | head -n1)

    if test -n "$df_line"
        set -l parts (echo $df_line | string split -n ' ')

        set -l device ""
        set -l total_size ""
        set -l used_size ""
        set -l use_percent ""
        set -l mount ""

        set -l field_count (count $parts)
        if test $field_count -ge 6
            set device $parts[1]
            set total_size $parts[2]
            set used_size $parts[3]
            set use_percent $parts[5]
            set mount $parts[6]
        end

        set -l disk_type Unknown
        if test -n "$device"
            set -l base_device (basename $device)
            set -l disk_name ""

            if string match -qr '^sd[a-z][0-9]*$' $base_device
                set disk_name (string replace -r '[0-9]*$' '' $base_device)
            else if string match -qr '^nvme[0-9]+n[0-9]+p?[0-9]*$' $base_device
                set disk_name (string replace -r 'p?[0-9]*$' '' $base_device)
            else if string match -qr '^mmcblk[0-9]+p?[0-9]*$' $base_device
                set disk_name (string replace -r 'p?[0-9]*$' '' $base_device)
            else
                set disk_name (string replace -r '[0-9]*$' '' $base_device)
            end

            if test -n "$disk_name" -a -r "/sys/block/$disk_name/queue/rotational"
                set -l rotational (cat "/sys/block/$disk_name/queue/rotational" 2>/dev/null)
                if test "$rotational" = 0
                    set disk_type SSD
                else if test "$rotational" = 1
                    set disk_type HDD
                end
            end
        end

        if test -n "$device" -a -n "$total_size" -a -n "$used_size" -a -n "$use_percent"
            set storage_info "$dim$device$reset $y$disk_type$reset $dim•$reset $dim Mount:$reset $b$mount$reset $dim•$reset $dim Used:$reset $g$used_size$reset$dim/$reset$y$total_size$reset $r$use_percent$reset"
        else
            set storage_info "Error parsing disk info"
        end
    else
        set storage_info "Unable to read disk info"
    end

    set -l network_info ""
    set -l net_line (ip -brief addr show 2>/dev/null | grep -v lo | grep UP | head -n1)

    if test -n "$net_line"
        set -l iface (echo $net_line | awk '{print $1}')
        set -l ip (echo $net_line | awk '{for(i=3;i<=NF;++i) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {print $i; break}}')
        if test -n "$ip"
            set network_info "$y$iface$reset $g UP$reset $dim-$reset $b$ip$reset"
        else
            set network_info "$y$iface$reset $g UP$reset"
        end
    else
        set network_info "No network interface found"
    end

    echo -e "$dim OS:$reset      $y$os_name$reset $dim•$reset $dim Kernel:$reset $b$kernel$reset"
    echo -e "$dim Host:$reset    $b$host$reset $dim•$reset $dim Uptime:$reset $g$uptime_hr hr$reset"
    echo -e "$dim Network:$reset $network_info"
    echo -e "$dim Storage:$reset $storage_info"
end
