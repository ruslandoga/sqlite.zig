const c = @cImport({
    @cInclude("sqlite3.h");
});

const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "open/close" {
    var rc: c_int = 0;

    var db: ?*c.sqlite3 = undefined;
    var flags: c_int = c.SQLITE_OPEN_URI;
    flags |= c.SQLITE_OPEN_MEMORY;
    flags |= c.SQLITE_OPEN_READWRITE;

    rc = c.sqlite3_open_v2(":memory:", &db, flags, null);
    try std.testing.expectEqual(c.SQLITE_OK, rc);

    rc = c.sqlite3_close_v2(db);
    try std.testing.expectEqual(c.SQLITE_OK, rc);
}
