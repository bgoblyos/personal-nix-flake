{
  flake.modules.homeManager.starship = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.starship = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;

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
  };
}
