{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Bence Göblyös";
        email = "bence@goblyos.dev";
      };
      init.defaultBranch = "main";
    };
  };
}
