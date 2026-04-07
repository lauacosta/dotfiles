{
  programs.ghostty = {
    enable = true;

    settings = {
      font-family = "Iosevka Term Nerd Font Mono";
      command = "nu --interactive";
      shell-integration = "nushell";
      theme = "light:Gruvbox Light,dark:Gruvbox Dark";
      font-size = 12;
      background = "#181818";
      foreground = "#ebdbb2";
      adjust-cell-height = "5%";
      adjust-cell-width = "0%";
      window-padding-x = 5;
      window-padding-y = 5;
      split-divider-color = "#000000";
      unfocused-split-fill = "#000000";
      unfocused-split-opacity = "0.80";

      window-width = 80;
      window-height = 40;
      window-decoration = "none";
      copy-on-select = true;
    };
  };
}
