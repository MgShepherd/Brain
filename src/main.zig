const std = @import("std");
const fileReader = @import("./file_reader.zig");

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    const fileName = "example.txt";

    const contents = fileReader.readFile(alloc, fileName) catch |err| switch (err) {
        fileReader.ReadFileError.OpenFailed => {
            std.debug.print("Failed to open file {s}\n", .{fileName});
            return;
        },
        fileReader.ReadFileError.ProcessingFailed => {
            std.debug.print("Failed to process file {s}\n", .{fileName});
            return;
        },
    };

    std.debug.print("File Contents: {s}\n", .{contents});
}
