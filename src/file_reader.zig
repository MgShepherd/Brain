const std = @import("std");

pub const ReadFileError = error{ OpenFailed, ProcessingFailed };

const MAX_FILE_SIZE: usize = std.math.maxInt(usize);

pub fn readFile(alloc: std.mem.Allocator, fileName: []const u8) ReadFileError![]u8 {
    const file = std.fs.cwd().openFile(fileName, .{}) catch {
        return ReadFileError.OpenFailed;
    };
    defer file.close();

    const buffer = file.reader().readAllAlloc(alloc, MAX_FILE_SIZE) catch {
        return ReadFileError.ProcessingFailed;
    };
    return buffer;
}
