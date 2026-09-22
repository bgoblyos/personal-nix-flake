{
  flake.modules.homeManager.libreoffice = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      hunspellDicts.hu_HU
    ];
  };
}
