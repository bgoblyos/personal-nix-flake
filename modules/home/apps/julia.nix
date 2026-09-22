{
  flake.modules.homeManager.julia = {
    pkgs,
    lib,
    ...
  }: let
    # Private Python environment
    juliaPythonEnv = pkgs.python3.withPackages (ps:
      with ps; [
        matplotlib
        numpy
      ]);

    # Wrapped Julia executable that injects environment variables
    juliaWrapped = pkgs.writeShellApplication {
      name = "julia";
      runtimeInputs = [pkgs.julia-bin];
      text = ''
        export JULIA_PYTHONCALL_EXE="${juliaPythonEnv}/bin/python"
        export JULIA_CONDAPKG_BACKEND="Null"
        exec julia "$@"
      '';
    };
  in {
    # Expose the wrapped julia executable to PATH
    home.packages = [juliaWrapped];
  };
}
