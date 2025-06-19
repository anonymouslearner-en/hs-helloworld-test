{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pre-commit-hooks,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      overlays.default = final: prev: { };

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          packageJson = pkgs.lib.importJSON ./package.json;

        in
        {
          default = pkgs.buildNpmPackage {
            pname = packageJson.name;
            version = packageJson.version;

            npmDepsHash = "sha256-W6WOlClgestPYcNdMJ82DYPWXVAHWl9MjpawBnQZ21k=";

            src = ./.;

            npmBuildScript = "build";

            installPhase = ''
              mkdir -p $out/html
              cp -r dist/* $out/html
            '';

            nativeBuildInputs = with pkgs; [
              nodejs
            ];
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
            ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
          flakePkgs = self.packages.${system};
        in
        {
          build-packages = pkgs.linkFarm "flake-packages-${system}" flakePkgs;

          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style = {
                enable = true;
              };
            };
          };
        }
      );
    };
}
