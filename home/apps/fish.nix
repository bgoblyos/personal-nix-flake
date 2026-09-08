{ config, pkgs, ... }:

{

  home.packages = with pkgs; [ fish ];

  programs.fish = {
    enable = true;
	# Source determinate-nix if present
	interactiveShellInit = ''
      # Source Nix daemon profile if nix binary is not in PATH
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

      nix-sync = {
        description = "Pull Nix flake repository and apply system/user configuration";
        body = ''
          # Define candidate paths to search in order
          set -l candidate_dirs ~/Code/Nix/personal-nix-flake /etc/nixos

          set -l repo_dir ""
          for dir in $candidate_dirs
            if test -d $dir
              set repo_dir $dir
              break
            end
          end

          if test -z "$repo_dir"
            echo "Error: No valid Nix configuration directory found."
            return 1
          end

          echo "Found repository at: $repo_dir"
          cd $repo_dir; or return 1

          echo "Pulling latest changes from Git..."
          git pull; or return 1

          # Detect host environment and rebuild accordingly
          if type -q nixos-rebuild
            echo "Rebuilding NixOS system..."
            sudo nixos-rebuild switch --flake .
          else if type -q home-manager
            echo "Rebuilding Home Manager profile..."
            home-manager switch --flake .
          else
            echo "Error: Neither nixos-rebuild nor home-manager found in PATH."
            return 1
          end
        '';
      };
    };
  };
}
