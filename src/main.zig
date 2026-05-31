const std = @import("std");
const Io = std.Io;

pub fn hexdump(data: []const u8, limit: usize) void {
    var offset: usize = 0;
    const chunk_size = 16;
    const len = @min(limit, data.len);

    while (offset < len) : (offset += chunk_size) {
        std.debug.print("{x:0>8}  ", .{offset});

        const end = @min(offset + chunk_size, len);
        const chunk = data[offset..end];

        for (chunk) |byte| {
            std.debug.print("{x:0>2} ", .{byte});
        }

        const padding = chunk_size - chunk.len;
        var i: usize = 0;
        while (i < padding) : (i += 1) {
            std.debug.print("  ", .{});
        }

        std.debug.print(" |", .{});

        for (chunk) |byte| {
            if (std.ascii.isPrint(byte)) {
                std.debug.print("{c}", .{byte});
            } else {
                std.debug.print(".", .{});
            }
        }

        std.debug.print("|\n", .{});
    }
}

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
    hexdump(file_data, limit);
}
