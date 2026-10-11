{
  flake.modules.homeManager."scripts/scandoc" = {
    pkgs,
    lib,
    ...
  }: let
    # Define dependencies from Nixpkgs explicitly
    scandocDeps = [
      pkgs.openssh # ssh, scp
      pkgs.imagemagick # magick
      pkgs.coreutils # mv, rm, mkdir
    ];

    scandocScript = pkgs.writers.writePython3Bin "scandoc" {} (builtins.readFile ./scandoc.py);

    # Wrap the binary to inject dependencies into PATH (Nix pkgs + native host fallback)
    scandoc = pkgs.symlinkJoin {
      name = "scandoc";
      paths = [scandocScript];
      nativeBuildInputs = [pkgs.makeWrapper];
      # Use host binaries if possible
      postBuild = ''
        wrapProgram $out/bin/scandoc \
          --prefix PATH : "/usr/bin:/bin:${lib.makeBinPath scandocDeps}"
      '';
    };
  in {
    home.packages = [scandoc];
  };
}
