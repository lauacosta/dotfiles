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


function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
    set_color "#ECEBF3"
	echo -n (whoami)
	echo -n "@"
	set_color "#8ABEB7"
	echo -n (uname -n)
	if [ $PWD != $HOME ]
		set_color brblack
		echo -n '::'
	    set_color "#B294BB"
		echo -n (basename $PWD)
	end
	set_color --bold "#FBFFAD"
	printf '%s ' (__fish_git_prompt)
	# set_color "#DD2D4A"
	set_color brblack
	echo -n '| '
	set_color normal
end

function fish_greeting
    set_color --bold "#ECEBF3"
    echo -n "OS: " 

    set_color "#8abeb7"
    echo (uname --kernel-release --operating-system)

    set_color --bold "#ECEBF3"
    echo -n "Hostname: " 

    set_color "#8abeb7"
    echo (uname -n)

    set_color --bold "#ECEBF3"
    echo -n "Uptime: "

    set_color "#8abeb7"
    echo (uptime -p)

    set_color --bold "#ECEBF3"
    echo "Disk usage:"
    set_color "#ECEBF3"
    echo \t (df -h | grep -E '/$' | awk '{print $6 "\t" $3 "\t" $2 "\t" $5}')
    echo \t (df -h | grep -E 'home' | awk '{print $6 "\t" $3 "\t" $2 "\t" $5}')

    set_color "#ECEBF3"
    echo "Network:"

    set_color "#ECEBF3"
    echo \t (ip -4 -brief -o addres show | grep  wlan0) 
    echo \t (ip -6 -brief -o addres show | grep  wlan0) \n
end

if status is-interactive 
    # atuin init fish --disable-ctrl-r | source
end

fish_add_path -aP /usr/local/go/bin
fish_add_path -aP /home/lautaro/personal

source ~/.asdf/asdf.fish
fish_add_path /home/lautaro/.mozbuild/git-cinnabar/
fish_add_path ""$(python3 -m site --user-base)"/bin/"
fish_add_path /home/lautaro/personal/go/bin/
fish_add_path /home/lautaro/personal/apps/wezterm-20240203-110809-5046fc22/target/release/

