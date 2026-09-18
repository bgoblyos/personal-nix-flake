{
  flake.modules.homeManager.nh = {
    config,
    pkgs,
    ...
  }: {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5 --keep-one";
      };
    };
  };
}
