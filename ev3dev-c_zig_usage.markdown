# Using ev3dev-c with Zig: Code Examples

This document provides examples of using the `ev3dev-c` library in Zig to control LEGO MINDSTORMS EV3 hardware components such as LEDs, motors, and sensors. The `ev3dev-c` library is a C library, and Zig's C interoperability is used to call its functions. The examples below assume the `ev3dev-c` library is already installed on the EV3 brick and that the Zig compiler is set up for the EV3's ARM architecture.

## Example 1: Toggling LEDs

This example demonstrates how to toggle the left LED on the EV3 brick, similar to the `hello.c` example from the `ev3dev-c` repository.

```zig
// main.zig
const c = @cImport({
    @cInclude("ev3.h");
});
const std = @import("std");

pub fn main() !void {
    // Initialize the EV3 system
    if (c.ev3_init() < 1) {
        std.debug.print("EV3 initialization failed\n", .{});
        return error.EV3InitFailed;
    }
    defer c.ev3_exit(); // Clean up on exit

    // Set left LED to green
    try std.io.getStdOut().writer().print("Setting left LED to green\n", .{});
    c.ev3_led_set_color(c.LED_LEFT, c.LED_GREEN);
    std.time.sleep(1_000_000_000); // Wait 1 second

    // Set left LED to red
    try std.io.getStdOut().writer().print("Setting left LED to red\n", .{});
    c.ev3_led_set_color(c.LED_LEFT, c.LED_RED);
    std.time.sleep(1_000_000_000); // Wait 1 second

    try std.io.getStdOut().writer().print("Hello, EV3!\n", .{});
}
```

**How to Compile and Run**:
```bash
zig build-exe main.zig -target arm-linux -lc -lev3dev-c
scp main robot@ev3dev:/home/robot/
ssh robot@ev3dev './main'
```

**Explanation**:
- `@cImport` includes the `ev3.h` header to access `ev3dev-c` functions.
- `ev3_init` initializes the EV3 system; `ev3_exit` cleans up.
- `ev3_led_set_color` sets the color of the specified LED (`LED_LEFT`) to green or red.

## Example 2: Controlling a Tacho Motor

This example runs a tacho motor (e.g., a Large Motor) for 5 seconds, inspired by the `tacho.c` example.

```zig
// main.zig
const c = @cImport({
    @cInclude("ev3.h");
    @cInclude("ev3_tacho.h");
});
const std = @import("std");

pub fn main() !void {
    // Initialize EV3 system
    if (c.ev3_init() < 1) return error.EV3InitFailed;
    defer c.ev3_exit();

    // Find tacho motor
    var motor: c_int = -1;
    const motor_type = c.TACHO_MOTOR;
    if (c.ev3_tacho_init() < 1) {
        std.debug.print("No tacho motor found\n", .{});
        return error.NoMotorFound;
    }

    // Search for connected motor
    motor = c.ev3_search_tacho_type(motor_type, 0);
    if (motor < 0) {
        std.debug.print("Motor not found\n", .{});
        return error.MotorNotFound;
    }

    // Set motor speed and run for 5 seconds
    try std.io.getStdOut().writer().print("Running motor...\n", .{});
    c.ev3_set_speed_sp(motor, 500); // Set speed to 500
    c.ev3_set_time_sp(motor, 5000); // Run for 5000 ms
    c.ev3_command_motor(motor, c.COMMAND_RUN_TIMED);

    std.time.sleep(5_000_000_000); // Wait 5 seconds
    try std.io.getStdOut().writer().print("Motor stopped\n", .{});
}
```

**How to Compile and Run**:
```bash
zig build-exe main.zig -target arm-linux -lc -lev3dev-c
scp main robot@ev3dev:/home/robot/
ssh robot@ev3dev './main'
```

**Explanation**:
- `ev3_tacho_init` initializes the tacho motor subsystem.
- `ev3_search_tacho_type` finds a connected tacho motor.
- `ev3_set_speed_sp` and `ev3_set_time_sp` configure the motor's speed and runtime.
- `ev3_command_motor` with `COMMAND_RUN_TIMED` runs the motor for the specified time.

## Example 3: Reading a Touch Sensor

This example reads the state of a touch sensor, inspired by the `sensor.c` example.

```zig
// main.zig
const c = @cImport({
    @cInclude("ev3.h");
    @cInclude("ev3_sensor.h");
});
const std = @import("std");

pub fn main() !void {
    // Initialize EV3 system
    if (c.ev3_init() < 1) return error.EV3InitFailed;
    defer c.ev3_exit();

    // Find touch sensor
    var sensor: c_int = -1;
    sensor = c.ev3_search_sensor(c.EV3_TOUCH, 0);
    if (sensor < 0) {
        std.debug.print("Touch sensor not found\n", .{});
        return error.SensorNotFound;
    }

    // Read sensor value 10 times
    var i: usize = 0;
    while (i < 10) : (i += 1) {
        var value: c_int = 0;
        if (c.ev3_read_sensor(sensor, &value) > 0) {
            try std.io.getStdOut().writer().print("Touch sensor value: {}\n", .{value});
        } else {
            try std.io.getStdOut().writer().print("Failed to read sensor\n", .{});
        }
        std.time.sleep(500_000_000); // Wait 0.5 seconds
    }
}
```

**How to Compile and Run**:
```bash
zig build-exe main.zig -target arm-linux -lc -lev3dev-c
scp main robot@ev3dev:/home/robot/
ssh robot@ev3dev './main'
```

**Explanation**:
- `ev3_search_sensor` finds a touch sensor by type (`EV3_TOUCH`).
- `ev3_read_sensor` reads the sensor's value (0 for not pressed, 1 for pressed).
- The loop reads the sensor 10 times with a 0.5-second delay between readings.

## Notes
- **Header Files**: Ensure the `ev3dev-c` headers (`ev3.h`, `ev3_tacho.h`, `ev3_sensor.h`, etc.) are accessible to the Zig compiler. You may need to specify include paths with `-I` during compilation.
- **Linking**: The `-lev3dev-c` flag links the `ev3dev-c` library. Ensure the library is installed (`/usr/lib/libev3dev-c.so` or static equivalent).
- **Error Handling**: Zig's error handling is used to manage failures in EV3 initialization, motor, or sensor detection.
- **Constants**: Constants like `LED_LEFT`, `LED_GREEN`, `TACHO_MOTOR`, `EV3_TOUCH`, and `COMMAND_RUN_TIMED` are defined in `ev3dev-c` headers.
- **Remote Control**: For remote control, use the `brick` library functions (e.g., `brick_connect`, `brick_set_led`) and configure the EV3's WLAN.

These examples cover basic usage of LEDs, motors, and sensors. For additional functions (e.g., DC motors, servos, or IR remotes), refer to the `ev3dev-c` header files and adapt the Zig code similarly using `@cImport`.