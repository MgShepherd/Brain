const std = @import("std");
const fileReader = @import("./file_reader.zig");
const CliOptions = @import("./CliOptions.zig");
const Interpretor = @import("./Interpretor.zig");

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    var options = try CliOptions.loadCliOptions(alloc);
    defer options.deinit();

    const contents = fileReader.readFile(alloc, options.fileName) catch |err| switch (err) {
        fileReader.ReadFileError.OpenFailed => {
            std.debug.print("Failed to open file {s}\n", .{options.fileName});
            return;
        },
        fileReader.ReadFileError.ProcessingFailed => {
            std.debug.print("Failed to process file {s}\n", .{options.fileName});
            return;
        },
    };

    try Interpretor.interpretAndRun(alloc, contents);
}
