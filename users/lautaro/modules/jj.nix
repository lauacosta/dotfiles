{ ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Lautaro Acosta Quintana";
        email = "me@lautaroacosta.com";
      };
      ui.default-command = [ "log" ];
      git.colocate = true;
      templates.git_push_bookmark = "'lautaro/' ++ change_id.short()";
      "template-aliases"."format_timestamp(timestamp)" = "timestamp.ago()";
      remotes.origin.auto-track-bookmarks = "lautaro/*";
    };
  };
}
