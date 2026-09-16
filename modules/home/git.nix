{
  flake.modules.homeManager.git = {
    config,
    pkgs,
    ...
  }: {
    programs.git = {
      enable = true;
      # Ignore direnv caches
      ignores = [".direnv"];
      # Do not use git from nixpgs if on a generic host
      package =
        if config.targets.genericLinux.enable
        then null
        else pkgs.git;
      # Enable GPG signing
      signing = {
        format = "openpgp";
        signByDefault = true;
        key = "bence@goblyos.dev";
      };
      settings = {
        user = {
          name = "Bence Göblyös";
          email = "bence@goblyos.dev";
        };
        init.defaultBranch = "main";
        core.hooksPath = ".githooks";
      };
    };
  };
}
