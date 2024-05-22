{
  description = "My OS configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, nixos-generators, }:
    let
      defaultFormats = [ "docker" "install-iso" ];
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;
        eachFormat = formats: f:
          let
            attrsOfFormat = format:
              nixos-generators.nixosGenerate ({
                system = system;
                format = format;
                modules = [
                  ./configuration.nix
                ];
              } // (f format));
          in
          builtins.foldl' (acc: fmt: acc // { ${fmt} = attrsOfFormat fmt; }) { } formats;
        eachDefaultFormat = eachFormat defaultFormats;
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages = eachDefaultFormat (format: {

        });
      }
    );
}
