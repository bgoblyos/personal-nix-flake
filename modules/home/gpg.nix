{
  flake.modules.homeManager.gpg = {
    config,
    pkgs,
    ...
  }: {
    programs.gpg = {
      enable = true;
    };
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };
  };
}
