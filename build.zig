const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("sqlite", .{ .source_file = .{ .path = "src/sqlite.zig" } });

    const lib_test = b.addTest(.{
        .root_source_file = .{ .path = "src/sqlite.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib_test.addIncludePath(.{ .path = "c_src" });
    lib_test.addCSourceFile(.{ .file = .{ .path = "c_src/sqlite3.c" }, .flags = &[_][]const u8{"-std=c99"} });
    lib_test.linkLibC();
    lib_test.installHeader("c_src/sqlite3.h", "sqlite3.h");

    const run_test = b.addRunArtifact(lib_test);
    run_test.has_side_effects = true;

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_test.step);
}
