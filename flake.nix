{
  description = "CODESYS 4";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystem = nixpkgs.lib.genAttrs supportedSystems;
      forAllSystems = f: eachSystem (system: f (import nixpkgs { inherit system; }));
    in
    {
      overlays.default = final: prev: {
        codesys-4 = (import ./default.nix { pkgs = final; }).codesys-4;
      };

      packages = forAllSystems (pkgs: import ./default.nix { inherit pkgs; });

      nixosModules.default = import ./nixos-module.nix { inherit self; };
    };
}
