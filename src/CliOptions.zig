const std = @import("std");
const CliOptions = @This();

pub const ProcessArgsError = error{ OutOfMemory, NotEnoughArguments };

fileName: []const u8,
argIter: std.process.ArgIterator,

pub fn loadCliOptions(alloc: std.mem.Allocator) ProcessArgsError!CliOptions {
    var argIter = try std.process.ArgIterator.initWithAllocator(alloc);
    _ = argIter.next();

    const fileName = argIter.next() orelse {
        std.debug.print("Input file argument must be provided", .{});
        return ProcessArgsError.NotEnoughArguments;
    };

    while (argIter.next()) |arg| {
        std.debug.print("Argument Provided: {s}\n", .{arg});
    }

    return CliOptions{
        .fileName = fileName,
        .argIter = argIter,
    };
}

pub fn deinit(self: *CliOptions) void {
    self.argIter.deinit();
}
