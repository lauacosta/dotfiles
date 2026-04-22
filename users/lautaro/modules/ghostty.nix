{
  programs.ghostty = {
    enable = true;
    # There are some issues with Ghostty unable to get a Open GL context when built with nix due to the disparity between it and the systems packages
    package = null;
    systemd.enable = false;

    settings = {
      font-family = "Iosevka Term Nerd Font Mono";
      command = "nu --interactive";
      shell-integration = "nushell";
      theme = "light:Alabaster,dark:Gruvbox Dark Hard";
      font-size = 12;
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
