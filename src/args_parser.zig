const std = @import("std");

pub const ProcessArgsError = error{ OutOfMemory, NotEnoughArguments };

const Options = struct {
    fileName: []const u8,
};

pub fn process_cli_args(alloc: std.mem.Allocator) ProcessArgsError!Options {
    var options: Options = undefined;
    var argIter = try std.process.ArgIterator.initWithAllocator(alloc);
    defer argIter.deinit();
    _ = argIter.next();

    options.fileName = argIter.next() orelse {
        std.debug.print("Input file argument must be provided", .{});
        return ProcessArgsError.NotEnoughArguments;
    };

    while (argIter.next()) |arg| {
        std.debug.print("Argument Provided: {s}\n", .{arg});
    }

    return options;
}
