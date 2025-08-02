{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.gnumake
    pkgs.python3
    pkgs.pkgsCross.armv7l-hf-multiplatform.buildPackages.gcc
    pkgs.pkgsCross.armv7l-hf-multiplatform.buildPackages.binutils
    pkgs.pkgsCross.armv7l-hf-multiplatform.buildPackages.glibc
  ];

  shellHook = ''
    export CC=armv7l-unknown-linux-gnueabihf-gcc
    export CXX=armv7l-unknown-linux-gnueabihf-g++
    export LD=armv7l-unknown-linux-gnueabihf-ld
    export AR=armv7l-unknown-linux-gnueabihf-ar
    export STRIP=armv7l-unknown-linux-gnueabihf-strip
    export RANLIB=armv7l-unknown-linux-gnueabihf-ranlib
    export PKG_CONFIG_PATH=""
    export PKG_CONFIG_SYSROOT_DIR=""
  '';
} 