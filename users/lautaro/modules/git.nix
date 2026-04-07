{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    signing.format = null;


    settings = {
        user = {
            name = "Lautaro Acosta Quintana";
            email = "me@lautaroacosta.com";
        };

      credential = {
        helper = "store";
      };
      "credential \"https://github.com\"" = {
        helper = "!/usr/bin/gh auth git-credential";
      };
      "credential \"https://gist.github.com\"" = {
        helper = "!/usr/bin/gh auth git-credential";
      };

      core.editor = "${pkgs.neovim}/bin/hx";

      pull.rebase = true;

      merge.conflictStyle = "diff3";
      "merge \"mergiraf\"" = {
        name   = "mergiraf";
        driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L";
      };

      diff = {
        tool     = "difftastic";
        external = "${pkgs.difftastic}/bin/difft";
      };

      pager.difftool = true;

      alias = {
        dl  = "-c diff.external=${pkgs.difftastic}/bin/difft log -p --ext-diff";
        ds  = "-c diff.external=${pkgs.difftastic}/bin/difft show --ext-diff";
        dft = "-c diff.external=${pkgs.difftastic}/bin/difft diff";
      };
    };

    includes = [];
  };

  home.packages = [ pkgs.difftastic pkgs.mergiraf ];
}
