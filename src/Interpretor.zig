const std = @import("std");

const CELLS_LEN: usize = 30000;

pub const InterpretorError = error{ OutOfMemory, OutOfBounds, UnbalancedParan, InvalidValue, UnrecognisedCharacter };

const validInputs = [_]u8{ '>', '<', '.', ',', '[', ']', '+', '-' };

const Direction = enum(u1) { Forward, Backward };

fn isValidInput(character: u8) bool {
    for (validInputs) |c| {
        if (c == character) return true;
    }
    return false;
}

fn processMoveInstruction(dpointer: *usize, bound_val: usize, direction: Direction) InterpretorError!void {
    if (dpointer.* == bound_val) {
        std.debug.print("Tried to access memory value outside of valid bounds\n", .{});
        return InterpretorError.OutOfBounds;
    }
    if (direction == Direction.Forward) dpointer.* += 1 else dpointer.* -= 1;
}

fn processMathInstruction(memory: []u8, dpointer: usize, bound_val: usize, direction: Direction) InterpretorError!void {
    if (memory[dpointer] == bound_val) {
        std.debug.print("Value at memory location {d} out of bounds\n", .{dpointer});
        return InterpretorError.InvalidValue;
    }
    if (direction == Direction.Forward) memory[dpointer] += 1 else memory[dpointer] -= 1;
}

fn processLoopInstruction(data: []const u8, ipointer: *usize, bound_val: usize, search_val: u8, nest_val: u8, direction: Direction) InterpretorError!void {
    var nestedLevel: u8 = 0;
    if (direction == Direction.Forward) ipointer.* += 1 else ipointer.* -= 1;

    while (!(data[ipointer.*] == search_val and nestedLevel == 0)) {
        if (data[ipointer.*] == nest_val) {
            nestedLevel += 1;
        } else if (data[ipointer.*] == search_val) {
            nestedLevel -= 1;
        }
        if (ipointer.* == bound_val) {
            std.debug.print("Unbalanced [] found\n", .{});
            return InterpretorError.UnbalancedParan;
        }

        if (direction == Direction.Forward) ipointer.* += 1 else ipointer.* -= 1;
    }
}

pub fn interpretAndRun(alloc: std.mem.Allocator, data: []const u8) InterpretorError!void {
    var dpointer: usize = 0;
    var ipointer: usize = 0;

    const memory = try alloc.alloc(u8, CELLS_LEN);
    for (memory) |*element| {
        element.* = 0;
    }
    defer alloc.free(memory);

    while (ipointer < data.len) : (ipointer += 1) {
        switch (data[ipointer]) {
            '>' => try processMoveInstruction(&dpointer, CELLS_LEN - 1, Direction.Forward),
            '<' => try processMoveInstruction(&dpointer, 0, Direction.Backward),
            '+' => try processMathInstruction(memory, dpointer, std.math.maxInt(u8), Direction.Forward),
            '-' => try processMathInstruction(memory, dpointer, 0, Direction.Backward),
            '.' => std.debug.print("{c}", .{memory[dpointer]}),
            ',' => {
                std.debug.print("Reading input not yet implemented\n", .{});
                return InterpretorError.OutOfBounds;
            },
            '[' => {
                if (memory[dpointer] == 0) {
                    try processLoopInstruction(data, &ipointer, data.len - 1, ']', '[', Direction.Forward);
                }
            },
            ']' => {
                if (memory[dpointer] > 0) {
                    try processLoopInstruction(data, &ipointer, 0, '[', ']', Direction.Backward);
                }
            },
            else => {},
        }
    }
}
