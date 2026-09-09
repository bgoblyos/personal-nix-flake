{ pkgs, ... }:

{
  programs.git = {
    enable = true;
	ignores = [ ".direnv" ];
    settings = {
      user = {
        name  = "Bence Göblyös";
        email = "bence@goblyos.dev";
      };
      init.defaultBranch = "main";
      core.hooksPath = ".githooks";
    };
  };
}
