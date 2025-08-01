# Mindstorm EV3 Project

This project demonstrates how to compile the ev3dev-c library using Zig on NixOS for cross-compilation to ARM Linux (EV3 brick).

## Prerequisites

- NixOS with Zig installed
- Python 2.7 (for yupp preprocessor)

## Building

### 1. Generate C Files

The ev3dev-c library uses the yupp preprocessor to generate C files from `.yu-c` and `.yu-h` files. Run the generation script:

```bash
./generate_c_files.sh
```

### 2. Build for ARM (EV3 Brick)

To build for the EV3 brick (ARM Linux):

```bash
zig build
```

This will create an ARM executable at `zig-out/bin/mindstorm`.

### 3. Build for Native Platform (Testing)

To build for your native platform for testing:

```bash
# Edit build.zig to change target to x86_64-linux-gnu
zig build
```

## Project Structure

- `src/main.zig` - Main Zig application
- `build.zig` - Zig build configuration
- `ev3dev-c/` - ev3dev-c library source
- `generate_c_files.sh` - Script to regenerate C files from yupp sources
- `shell.nix` - Nix shell environment for cross-compilation

## Cross-Compilation

The project is configured to cross-compile to ARM Linux (gnueabihf) targeting the Cortex-A9 processor used in the EV3 brick.

## Notes

- The ev3dev-c library requires the yupp preprocessor to generate C files from `.yu-c` and `.yu-h` files
- The generated C files are included directly in the Zig build
- The project links against libc for C standard library support
- The executable is compiled for ARM Linux and should run on the EV3 brick 