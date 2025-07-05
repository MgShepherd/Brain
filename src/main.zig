const std = @import("std");
const fileReader = @import("./file_reader.zig");
const argsParser = @import("./args_parser.zig");

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    const options = try argsParser.process_cli_args(alloc);
    std.debug.print("Provided file name: {s}\n", .{options.fileName});

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

    std.debug.print("File Contents: {s}\n", .{contents});
}
