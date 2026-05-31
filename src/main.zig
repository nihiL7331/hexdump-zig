const std = @import("std");
const Io = std.Io;

const hex = @import("hexdump.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <path> [limit]\n", .{args[0]});
        return;
    }

    const file_path = args[1];

    const file_data = try Io.Dir.readFileAlloc(
        Io.Dir.cwd(),
        init.io,
        file_path,
        arena,
        Io.Limit.unlimited,
    );

    const limit: usize = if (args.len >= 3) try std.fmt.parseInt(usize, args[2], 10) else file_data.len;
    hex.dump(file_data, limit);
}
