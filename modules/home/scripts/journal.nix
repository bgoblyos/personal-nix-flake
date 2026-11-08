{
  flake.modules.homeManager."scripts/journal" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "journal";
        text = ''
          TODAY=$(date +%Y-%m-%d)

          if [ -d "$HOME/Documents/Log" ]; then
            FNAME="$HOME/Documents/Log/$TODAY.md"
          elif [ -d "$HOME/Documents/Notes/Log" ]; then
            FNAME="$HOME/Documents/Notes/Log/$TODAY.md"
          else
            echo "Could not find journal directory." 1>&2
            exit 1
          fi

          if ! [ -e "$FNAME" ]; then
            printf '# %s\n' "$TODAY" >> "$FNAME"
          fi

          $EDITOR "$FNAME"
        '';
      })
    ];
  };
}
