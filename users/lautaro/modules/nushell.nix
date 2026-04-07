{ ... }:

{
  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
    environmentVariables = {
      PROMPT_COMMAND_RIGHT = "";
    };
    extraConfig = builtins.readFile ./config.nu;
  };
}
