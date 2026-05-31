const std = @import("std");

pub fn dump(data: []const u8, limit: usize) void {
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
