{
  flake.modules.homeManager."scripts/cleanup" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "cleanup";
        runtimeInputs = [pkgs.nh];
        text = ''
          # Auto-detect privilege escalation tool
          if command -v run0 >/dev/null 2>&1; then
            SU="run0"
          elif command -v sudo >/dev/null 2>&1; then
            SU="sudo"
          elif command -v doas >/dev/null 2>&1; then
            SU="doas"
          else
            SU=""
          fi

          # 1. Root Operations (elevate once)
          if command -v emerge >/dev/null 2>&1; then
            if [ -n "$SU" ]; then
              echo "Running system cleanup as root using $SU..."
              $SU bash -c '
                set -euo pipefail
                emerge --depclean --ask

                if command -v eclean-kernel >/dev/null 2>&1; then
                  eclean-kernel -n 3
                fi

                if command -v eclean >/dev/null 2>&1; then
                  eclean -d distfiles
                  eclean -d packages
                fi
              '
            else
              echo "Error: Privilege escalation tool (run0/sudo/doas) missing." >&2
              exit 1
            fi
          fi

          # 2. User-level Operations

          echo "Cleaning up and optimizing the nix store..."
          nh clean user --keep 5 --keep-since 7d
          nix store optimise

          if command -v podman >/dev/null 2>&1; then
            echo "Pruning rootless Podman containers/images..."
            podman image prune --force
            podman network prune --force
          fi

          if command -v flatpak >/dev/null 2>&1; then
            echo "Removing unused Flatpaks..."
            flatpak uninstall --unused --assumeyes
          fi
        '';
      })
    ];
  };
}
