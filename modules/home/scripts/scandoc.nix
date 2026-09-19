{
  flake.modules.homeManager."scripts/scandoc" = {
    pkgs,
    lib,
    ...
  }: let
    # Option 1: Define dependencies from Nixpkgs explicitly
    scandocDeps = [
      pkgs.openssh # ssh, scp
      pkgs.imagemagick # magick
      pkgs.coreutils # mv, rm, mkdir
    ];

    scandocScript = pkgs.writers.writePython3Bin "scandoc" {} ''
      import argparse
      import os
      import subprocess
      import sys

      DPI = "600dpi"
      HOST = "print-server"
      TMPDIR = "/tmp/scandoc"
      DEFAULT_TARGET_DIR = os.path.expanduser("~/Public/Paperless")


      def scan_page(fname):
          print("Initiated scan...", end="", flush=True)
          subprocess.run(
              [
                  "ssh",
                  HOST,
                  "sudo",
                  "-u",
                  "saned",
                  "scanimage",
                  "--format",
                  "png",
                  "--output-file",
                  "/tmp/scan.png",
                  "--resolution",
                  DPI,
              ]
          )
          print("\t\t[DONE]")

          print("Retrieving image...", end="", flush=True)
          subprocess.run(
              [
                  "scp",
                  f"{HOST}:/tmp/scan.png",
                  fname,
              ],
              stdout=subprocess.DEVNULL,
          )
          print("\t\t[DONE]")
          print("Deleting temporary image...", end="", flush=True)
          subprocess.run(
              [
                  "ssh",
                  HOST,
                  "sudo",
                  "-u",
                  "saned",
                  "rm",
                  "/tmp/scan.png",
              ]
          )
          print("\t[DONE]")


      def create_tempdir():
          if not os.path.exists(TMPDIR):
              os.makedirs(TMPDIR, exist_ok=True)


      def prompt_continue():
          response = input("Scan another page? [y/N] ")
          return response.strip().lower() in ("y", "yes")


      def scan_document(final_path):
          create_tempdir()

          target_dir = os.path.dirname(final_path)
          pdf_name = os.path.basename(final_path)

          filenames = []
          iterator = 1

          while True:
              iter_str = str(iterator).zfill(5)
              fname = f"{TMPDIR}/{iter_str}.png"
              filenames.append(fname)

              scan_page(fname)
              iterator += 1

              if not prompt_continue():
                  break

              print("Concatenating document...", end="", flush=True)
              tmp_pdf_path = f"{TMPDIR}/{pdf_name}"
              subprocess.run(
                  [
                      "magick",
                      "-density",
                      "600",
                      "-quality",
                      "60",
                      "-compress",
                      "jpeg",
                      *filenames,
                      tmp_pdf_path,
                  ]
              )

              if target_dir and not os.path.exists(target_dir):
                  os.makedirs(target_dir, exist_ok=True)

              subprocess.run(["mv", tmp_pdf_path, final_path])
              print("\t[DONE]")


      if __name__ == "__main__":
          parser = argparse.ArgumentParser(
              description="Scan document pages over SSH and compile into PDF."
          )
          parser.add_argument(
              "output",
              help="Output filename (e.g. 'doc.pdf') or destination path ('/tmp/doc.pdf').",  # noqa: E501
          )
          args = parser.parse_args()

          raw_output = args.output.strip()
          if not raw_output:
              print("Error: Output path cannot be empty.", file=sys.stderr)
              sys.exit(1)

          expanded = os.path.expanduser(raw_output)

          # If only a filename was passed (no path components)
          if os.path.dirname(raw_output) == "":
              if not expanded.endswith(".pdf"):
                  expanded += ".pdf"
                  final_path = os.path.join(DEFAULT_TARGET_DIR, expanded)
          else:
              if not expanded.endswith(".pdf"):
                  expanded += ".pdf"
              final_path = os.path.abspath(expanded)

          scan_document(final_path)
    '';

    # Wrap the binary to inject dependencies into PATH (Nix pkgs + Gentoo fallback)
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
