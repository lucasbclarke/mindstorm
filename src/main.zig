const std = @import("std");
const print = std.debug.print;

const ev3dev = @cImport({
    @cInclude("ev3.h");
});

pub fn main() !void {
    print("Hello, World!\n", .{});
    
    // Initialize the EV3 library
    if (ev3dev.ev3_init() != 0) {
        print("Failed to initialize EV3 library\n", .{});
        return;
    }
    
    print("EV3 library initialized successfully\n", .{});
    
    // Clean up
    ev3dev.ev3_uninit();
}
