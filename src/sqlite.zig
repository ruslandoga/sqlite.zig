const std = @import("std");
const t = std.testing;
const c = @cImport(@cInclude("sqlite3.h"));

test "open/close" {
    var rc: c_int = 0;

    var db: ?*c.sqlite3 = undefined;
    var flags: c_int = c.SQLITE_OPEN_URI;
    flags |= c.SQLITE_OPEN_MEMORY;
    flags |= c.SQLITE_OPEN_READWRITE;

    rc = c.sqlite3_open_v2(":memory:", &db, flags, null);
    try t.expectEqual(c.SQLITE_OK, rc);

    rc = c.sqlite3_close_v2(db);
    try t.expectEqual(c.SQLITE_OK, rc);
}
