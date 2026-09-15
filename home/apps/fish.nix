{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;

    # Suppress the wall of environment diff text on directory change
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  programs.lsd = {
    enable = true;
    enableFishIntegration = false; # Prevents HM from generating 'alias ll'
  };

  programs.bat.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Automatically injects 'z' into Fish

    # Enable fzf integration for interactive search ('zi')
    options = ["--cmd z"];
  };

  programs.fzf.enable = true;

  programs.fish = {
    enable = true;

    # Source Nix environment if it's not done already
    interactiveShellInit = ''
      if not type -q nix
        if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        else if test -f /nix/var/nix/profiles/default/etc/profile.d/nix.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        end
      end
    '';

    functions = {
      # Suppresses the default startup greeting
      fish_greeting = "";

      ll = {
        description = "Use lsd for listing whenever possible";
        body = ''
          # Try lsd
          if type -qf lsd
              command lsd --git -lA $argv
              return $status
          end

          # Fall back to regular ls if there's no lsd os eza
          command ls -lAh $argv
        '';
      };

      tree = {
        description = "Use lsd for tree whenever possible";
        body = ''
          # Try lsd
          if type -qf lsd
              command lsd -lA --git --tree $argv
              return $status
          end

          # Try tree
          if type -qf tree
              command tree $argv
              return $status
          end

          echo "Nothing provides a tree view"
          return 1
        '';
      };
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "$username$hostname $directory $git_branch $nix_shell $direnv $cmd_duration$line_break$character";

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bright-green"; # Matches fish_color_user brgreen
      };

      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style)";
        style = "normal"; # Matches fish_color_host normal
      };

      directory = {
        format = "[$path]($style)";
        style = "green"; # Matches fish_color_cwd green
        truncate_to_repo = false;
      };

      git_branch = {
        format = "([($symbol $branch)]($style))";
        symbol = "";
        style = "purple";
      };

      nix_shell = {
        symbol = "❄️";
        format = " via [$symbol\\($state\\)]($style)";
        style = "#00afff"; # Matches fish_color_param 00afff
      };

      direnv = {
        disabled = false;
        format = " via [$symbol]($style)";
        symbol = "󱁿";
        style = "bold orange";
      };

      cmd_duration = {
        min_time = 2000;
        format = " took [$duration]($style)";
        style = "bold yellow";
        show_milliseconds = true;
      };

      character = {
        success_symbol = "[>](green)";
        error_symbol = "[>]($ff00000)";
      };
    };
  };
}
