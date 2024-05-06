set -g fish_key_bindings fish_vi_key_bindings
abbr -a c cargo
abbr -a m make
abbr -a g git
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gd 'git diff'
abbr -a gs 'git status'
abbr -a gp 'git push'
abbr -a ct 'cargo t'
abbr -a vim 'nvim'

if command -v eza > /dev/null
	abbr -a l 'eza'
	abbr -a ls 'eza'
	abbr -a ll 'eza -l'
	abbr -a lll 'eza -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd


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
	printf '%s ' (__fish_git_prompt)
	set_color brblack
	echo -n '| '
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

if status is-interactive 
    # atuin init fish --disable-ctrl-r | source
end

fish_add_path -aP /usr/local/go/bin
fish_add_path -aP /home/lautaro/personal

source ~/.asdf/asdf.fish
fish_add_path /home/lautaro/.mozbuild/git-cinnabar/
fish_add_path ""$(python3 -m site --user-base)"/bin/"
fish_add_path /home/lautaro/personal/apps/go/bin/
fish_add_path /home/lautaro/personal/apps/wezterm-20240203-110809-5046fc22/target/release/

theme_gruvbox dark hard
