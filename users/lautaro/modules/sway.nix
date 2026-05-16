{
  wayland.windowManager.sway = {
    enable = true;

    config = let
      mod = "Mod4";
    in {
      modifier = mod;

      terminal = "ghostty";
      menu = "wofi --show drun";

      fonts = {
        names = [ "Iosevka Term Nerd Font Mono" ];
        size = 10.0;
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;

        criteria = [
          { app_id = "pavucontrol"; }
          { app_id = "nm-connection-editor"; }
        ];
      };

      startup = [
        { command = "dunst"; }
      ];

      keybindings = {
        "${mod}+Return" = "exec ghostty";
        "${mod}+Space" = "exec wofi --show drun";
        "${mod}+Shift+t" = "exec $HOME/.local/bin/toggle-theme.sh";

        "${mod}+Shift+q" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";

        "${mod}+Shift+r" = "reload";
        "${mod}+Shift+e" = "exit";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+r" = ''mode "resize"'';

        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";

        "${mod}+Shift+1" =
          "move container to workspace number 1";

        "${mod}+Shift+2" =
          "move container to workspace number 2";

        "${mod}+Shift+3" =
          "move container to workspace number 3";

        "${mod}+Shift+s" =
          ''exec grim -g "$(slurp)" - | wl-copy'';

        "XF86AudioRaiseVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

        "XF86AudioLowerVolume" =
          "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";

        "XF86AudioMute" =
          "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      modes = {
        resize = {
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";

          Return = "mode default";
          Escape = "mode default";
        };
      };
    };


    extraConfig = ''
      focus_follows_mouse yes
      smart_borders on
      client.focused          #d79921 #d79921 #282828 #d79921
      client.focused_inactive #3c3836 #3c3836 #ebdbb2 #3c3836
      client.unfocused        #282828 #282828 #a89984 #282828
      client.urgent           #cc241d #cc241d #fbf1c7 #cc241d
    '';
  };
}
