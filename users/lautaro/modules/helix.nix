{ pkgs, ... }:
{
  programs.helix = {
    enable = true;

    settings = {
      # theme = {
      #   dark = "gruvbox";
      #   light = "gruvbox_light";
      # };

      theme = "gruvbox";

      editor = {
        auto-format = false;
        auto-pairs = false;
        bufferline = "multiple";
        clipboard-provider = "wayland";
        line-number = "relative";
        mouse = false;

        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";

        popup-border = "all";

        shell = [
          "nu"
          "-c"
        ];

        file-picker.hidden = false;

        indent-guides = {
          render = true;
          character = "│";
          highlight = "comment";
          skip-levels = 1;
        };

        lsp = {
          display-inlay-hints = false;
          display-progress-messages = true;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        whitespace = {
          render = {
            space = "none";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };

        soft-wrap.enable = true;

        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [
            "file-name"
            "read-only-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position"
            "position-percentage"
            "file-encoding"
          ];
        };
      };

      keys = {
        normal = {
          K = "hover";
          F8 = ":toggle lsp.display-inlay-hints";
          F1 = ":config-reload";

          X = [
            "select_line_above"
            "extend_to_line_bounds"
          ];

          V = "extend_to_line_bounds";
          A-x = "extend_to_line_bounds";

          A-j = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
  
          A-k = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];

          C-g = [
            ":new"
            ":insert-output lazygit"
            ":buffer-close!"
            ":redraw"
          ];

          space = {
            k = "keep_selections";
            g = {
              d = [
                ":vsplit"
                "goto_definition"
              ];
            };
            o = ":sh gh repo view --web";

            s = {
              f = "file_picker";
              n = ":open ~/.config/helix/";
              a = ":open ~/Notas/apuntes/";
              p = ":open ~/Documents/";
            };
          };
        };

        insert = {
          C-y = "insert_tab";
        };
     };
    };
  };
}
