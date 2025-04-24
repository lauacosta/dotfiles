theme_gruvbox dark hard

set -g fish_key_bindings fish_vi_key_bindings
abbr -a c cargo
abbr -a m make
abbr -a g git
abbr -a k kubectl
abbr -a j just
abbr -a ga 'git add'
abbr -a gap 'git add -p'
abbr -a gc 'git commit'
abbr -a gd 'git diff'
abbr -a gs 'git status'
abbr -a gp 'git push'
abbr -a gl 'git log -1 HEAD'
abbr -a ct 'cargo t'
abbr -a vim 'nvim'
abbr -a tma 'tmux attach'
abbr -a cwr 'cargo-watch -q -c -x \'run -q\''

fish_add_path -aP /usr/local/go/bin
fish_add_path -aP /home/lautaro/personal
fish_add_path -aP /home/lautaro/.dotnet/tools/
fish_add_path -aP /home/lautaro/.config/emacs/bin/
fish_add_path ""$(python3 -m site --user-base)"/bin/"
fish_add_path /home/lautaro/personal/apps/zig/
fish_add_path "$HOME/.juliaup/bin/"
fish_add_path "$HOME/.cargo/bin"

uv generate-shell-completion fish | source
~/.local/bin/mise activate fish | source

# pnpm
set -gx PNPM_HOME "/home/lautaro/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# BEGIN opam configuration
test -r '/home/lautaro/.opam/opam-init/init.fish' && source '/home/lautaro/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
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

function software_version 
    if test -f Cargo.toml
        set_color --bold "#d64d0e"
        echo -n "[🦀 "
        echo -n (rustc --version | cut -d' ' -f2)
        echo -n "]"
        set_color normal
    end

    if test -f package.json
        set_color --bold yellow
        echo -n "["
        echo -n (node --version)
        echo -n "]"
        set_color normal

        set react_version (jq -r '.dependencies.react // .devDependencies.react // empty' < package.json)
        if test -n "$react_version"
            set_color --bold cyan
            echo -n " [ "
            echo -n $react_version
            echo -n "] "
            set_color normal
        end

        set svelte_version (jq -r '.dependencies.svelte // .devDependencies.svelte // empty' < package.json)
        if test -n "$svelte_version"
            set_color --bold red
            echo -n " [ "
            echo -n $svelte_version
            echo -n "] "
            set_color normal
        end
    end

    if test -f bun.lockb
        if type -q bun
            set_color --bold magenta
            echo -n "[🍞 "
            echo -n (bun --version)
            echo -n "] "
            set_color normal
        end
    end

    if test -f deno.json -o -f deno.jsonc
        if type -q deno
            set_color --bold green
            echo -n "[🦕 "
            echo -n (deno --version | grep deno | awk '{print $2}')
            echo -n "] "
            set_color normal
        end
    end
end

function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
    set_color "#fbf1c7"
	echo -n (whoami)
	echo -n "@"
	set_color "#b8bb26"
	echo -n (uname -n)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n '::'
	    set_color "#fabd2f"
		echo -n (basename $PWD)
	end
    set_color --bold "#8ABEB7"
	printf ' %s' (git_hash)
	printf ' %s\n' (software_version)
	set_color brblack
    echo -n '>> '
	set_color normal
end

function fish_greeting
    set_color --bold "#fbf1c7"
    echo -n "OS: " 

	set_color "#b8bb26"
    echo (uname --kernel-release --operating-system)

    set_color --bold "#fbf1c7"
    echo -n "Hostname: " 

	set_color "#b8bb26"
    echo (uname -n)

    set_color --bold "#fbf1c7"
    echo -n "Uptime: "

	set_color "#b8bb26"
    echo (uptime -p)

    set_color --bold "#fbf1c7"
    echo "Disk usage:"
    set_color "#fbf1c7"
    echo \t (df -h | grep -E 'home' | awk '{print $6 "\t" $3 "\t" $2 "\t" $5}')

    set_color "#fbf1c7"
    echo "Network:"

    set_color "#fbf1c7"
    echo \t (ip -4 -brief -o addres show | awk 'NR==2')
    echo \t (ip -6 -brief -o addres show | awk 'NR==2') \n
end

function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
