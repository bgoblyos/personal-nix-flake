{
  flake.modules.homeManager.gpg = {
    config,
    pkgs,
    ...
  }: {
    programs.gpg = {
      enable = true;
    };
  };
}
