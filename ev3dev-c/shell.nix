{ pkgs ? import <nixpkgs> { crossSystem = { config = "arm-linux-gnueabihf"; }; } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.gnumake
    pkgs.pkgsCross.armhf-embedded.buildPackages.gcc
    pkgs.pkgsCross.armhf-embedded.buildPackages.binutils
  ];

  shellHook = ''
    export CC=arm-linux-gnueabihf-gcc
    export CXX=arm-linux-gnueabihf-g++
    export LD=arm-linux-gnueabihf-ld
    export AR=arm-linux-gnueabihf-ar
  '';
}
