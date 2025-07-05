const std = @import("std");

const CELLS_LEN: usize = 30000;

pub const InterpretorError = error{ OutOfMemory, OutOfBounds, UnbalancedParan, InvalidValue, UnrecognisedCharacter };

const validInputs = [_]u8{ '>', '<', '.', ',', '[', ']', '+', '-' };

fn isValidInput(character: u8) bool {
    for (validInputs) |c| {
        if (c == character) return true;
    }
    return false;
}

pub fn interpretAndRun(alloc: std.mem.Allocator, data: []const u8) InterpretorError!void {
    var dpointer: usize = 0;
    var ipointer: usize = 0;

    var memory = try alloc.alloc(u8, CELLS_LEN);
    for (memory) |*element| {
        element.* = 0;
    }
    defer alloc.free(memory);

    while (ipointer < data.len) : (ipointer += 1) {
        switch (data[ipointer]) {
            '>' => {
                dpointer += 1;
                if (dpointer >= CELLS_LEN) {
                    std.debug.print("Tried to access data at index less than 0\n", .{});
                    return InterpretorError.OutOfBounds;
                }
            },
            '<' => {
                if (dpointer == 0) {
                    std.debug.print("Tried to access data outside of memory size\n", .{});
                    return InterpretorError.OutOfBounds;
                }
                dpointer -= 1;
            },
            '+' => {
                if (memory[dpointer] >= std.math.maxInt(u8)) {
                    std.debug.print("Value at pointer {d} too large\n", .{dpointer});
                    return InterpretorError.InvalidValue;
                }
                memory[dpointer] += 1;
            },
            '-' => {
                if (memory[dpointer] == 0) {
                    std.debug.print("Value at pointer {d} too small\n", .{dpointer});
                    return InterpretorError.InvalidValue;
                }
                memory[dpointer] -= 1;
            },
            '.' => {
                std.debug.print("{c}", .{memory[dpointer]});
            },
            ',' => {
                std.debug.print("Reading input not yet implemented\n", .{});
                return InterpretorError.OutOfBounds;
            },
            '[' => {
                if (memory[dpointer] == 0) {
                    var nestedLevel: u8 = 0;
                    ipointer += 1;
                    while (!(data[ipointer] == ']' and nestedLevel == 0)) : (ipointer += 1) {
                        if (data[ipointer] == '[') {
                            nestedLevel += 1;
                        } else if (data[ipointer] == ']') {
                            nestedLevel -= 1;
                        }
                        if (ipointer >= data.len) {
                            std.debug.print("Unable to find matching ] for [\n", .{});
                            return InterpretorError.UnbalancedParan;
                        }
                    }
                }
            },
            ']' => {
                if (memory[dpointer] > 0) {
                    var nestedLevel: u8 = 0;
                    ipointer -= 1;
                    while (!(data[ipointer] == '[' and nestedLevel == 0)) : (ipointer -= 1) {
                        if (data[ipointer] == ']') {
                            nestedLevel += 1;
                        } else if (data[ipointer] == '[') {
                            nestedLevel -= 1;
                        }
                        if (ipointer <= 0) {
                            std.debug.print("Unable to find matching [ for ]\n", .{});
                            return InterpretorError.UnbalancedParan;
                        }
                    }
                }
            },
            else => {},
        }
    }
}
