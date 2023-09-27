const std = @import("std");
const t = std.testing;
const c = @cImport(@cInclude("sqlite3.h"));

test "select ? as lol" {
    var rc: c_int = 0;

    var db: ?*c.sqlite3 = undefined;
    var flags: c_int = c.SQLITE_OPEN_URI;
    flags |= c.SQLITE_OPEN_MEMORY;
    flags |= c.SQLITE_OPEN_READWRITE;

    rc = c.sqlite3_open_v2(":memory:", &db, flags, null);
    try t.expectEqual(c.SQLITE_OK, rc);
    defer _ = c.sqlite3_close_v2(db);

    const sql: []const u8 = "select ? as lol";
    var stmt: ?*c.sqlite3_stmt = undefined;
    rc = c.sqlite3_prepare_v2(db, sql.ptr, @intCast(sql.len), &stmt, null);
    try t.expectEqual(c.SQLITE_OK, rc);
    defer _ = c.sqlite3_finalize(stmt);

    rc = c.sqlite3_bind_int64(stmt, 1, 1);
    try t.expectEqual(c.SQLITE_OK, rc);

    rc = c.sqlite3_step(stmt);
    try t.expectEqual(c.SQLITE_ROW, rc);
    try t.expectEqual(@as(i32, 1), c.sqlite3_data_count(stmt));
    try t.expectEqual(c.SQLITE_INTEGER, c.sqlite3_column_type(stmt, 0));
    try t.expectEqual(@as(i64, 1), c.sqlite3_column_int64(stmt, 0));

    rc = c.sqlite3_step(stmt);
    try t.expectEqual(c.SQLITE_DONE, rc);
}
