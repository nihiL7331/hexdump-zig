const std = @import("std");

const hex = @import("hexdump.zig");

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        std.debug.print("Usage: {s} <path> [limit]\n", .{args[0]});
        return;
    }

    const file_path = args[1];

    const limit: usize = if (args.len >= 3)
        try std.fmt.parseInt(usize, args[2], 10)
    else
        std.math.maxInt(usize);

    const file = try std.Io.Dir.cwd().openFile(init.io, file_path, .{});
    defer file.close(init.io);

    const stat = try file.stat(init.io);

    const alloc_size = @min(limit, stat.size);
    const buffer = try arena.alloc(u8, alloc_size);

    const bytes_read = try file.readPositionalAll(init.io, buffer, 0);
    const valid_data = buffer[0..bytes_read];

    hex.dump(valid_data);
}
