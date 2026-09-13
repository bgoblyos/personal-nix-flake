{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "nix-sync";
	  runtimeInputs = [ pkgs.nh ];
      text = ''
		if [ -z ${NH_FLAKE+x} ]; then
		  echo "NH_FLAKE is not set, cannot continue."
		  exit 1;
		fi
          
		git -C "$NH_FLAKE" pull 

	    if command -v nixos-rebuild > /dev/null; then
		  nh os switch;
		else
		  nh home switch;
		fi
      '';
    })
  ];
}
