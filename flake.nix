{
  description = "tolk - webhook to ntfy.sh message bridge";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.crystal.buildCrystalPackage {
            pname = "tolk";
            version = "0.1.0";

            src = ./.;

            shardsFile = ./shards.nix;

            format = "crystal";
            crystalBinaries.tolk.src = "src/tolk.cr";

            buildInputs = [ pkgs.openssl ];

            # Runtime tests require a live NTFY_TOPIC environment variable
            doCheck = false;
            doInstallCheck = false;

            meta = with pkgs.lib; {
              description = "Forwards webhook payloads to an ntfy.sh topic";
              license = licenses.mit;
              homepage = "https://github.com/laktosterror/tolk";
              mainProgram = "tolk";
              platforms = platforms.unix;
            };
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              crystal
              shards
              openssl
              pkg-config
            ];
          };
        }
      );
    };
}
