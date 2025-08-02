const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .arm,
            .os_tag = .linux,
            .abi = .gnueabihf,
            .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_a9 },
        },
    });

    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "mindstorm",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.addIncludePath(b.path("ev3dev-c"));
    exe.addIncludePath(b.path("ev3dev-c/source/ev3"));
    exe.addIncludePath(b.path("ev3dev-c/source/ev3/ev3_link"));
    exe.addIncludePath(b.path("ev3dev-c/3d_party"));
    
    // Link against libc
    exe.linkLibC();
    
    // Add C source files directly to the executable
    exe.addCSourceFiles(.{
        .files = &.{
            "ev3dev-c/source/ev3/ev3.c",
            "ev3dev-c/source/ev3/ev3_dc.c",
            "ev3dev-c/source/ev3/ev3_led.c",
            "ev3dev-c/source/ev3/ev3_light.c",
            "ev3dev-c/source/ev3/ev3_port.c",
            "ev3dev-c/source/ev3/ev3_sensor.c",
            "ev3dev-c/source/ev3/ev3_servo.c",
            "ev3dev-c/source/ev3/ev3_tacho.c",
            "ev3dev-c/source/ev3/brick.c",
            "ev3dev-c/source/ev3/crc32.c",
            "ev3dev-c/source/ev3/ev3_link/ev3_link.c",
            "ev3dev-c/3d_party/modp_numtoa.c",
        },
        .flags = &.{ "-O2", "-std=gnu99", "-W", "-Wall", "-Wno-comment", "-fPIC" },
    });
    
    b.installArtifact(exe);
}
