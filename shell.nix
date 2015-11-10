{}:
let pkgs = (import <nixpkgs> { }).pkgs;
    callPackage = pkgs.callPackage;
    pythonPackages = pkgs.python27Packages;
in callPackage ./default.nix { inherit (pythonPackages) six numpy; }
