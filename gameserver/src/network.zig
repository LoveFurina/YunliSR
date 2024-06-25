const std = @import("std");
const Session = @import("Session.zig");
const Allocator = std.mem.Allocator;

pub fn listen(allocator: Allocator) !void {
    const addr = std.net.Address.parseIp4("0.0.0.0", 23301) catch unreachable;
    var listener = try addr.listen(.{
        .kernel_backlog = 100,
        .reuse_address = true,
    });

    std.log.info("server is listening at {}", .{listener.listen_address});

    while (true) {
        const conn = listener.accept() catch continue;
        errdefer conn.stream.close();

        const session = try allocator.create(Session);
        session.* = Session.init(conn.address, conn.stream, allocator);

        const thread = try std.Thread.spawn(.{}, runSession, .{session});
        thread.detach();
    }
}

fn runSession(s: *Session) void {
    std.log.info("new connection from {}", .{s.address});

    if (s.run()) |_| {
        std.log.info("client from {} disconnected", .{s.address});
    } else |err| {
        std.log.err("session disconnected with an error: {}", .{err});
    }

    s.allocator.destroy(s);
}
