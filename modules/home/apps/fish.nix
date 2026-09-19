{
  flake.modules.homeManager.fish = {
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

      shellAliases = {
        mv = "mv -iv";
        cp = "cp --reflink=auto --sparse=auto -v";
        rm = "rm -Iv";
      };

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
  };
}
