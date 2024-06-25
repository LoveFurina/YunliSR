const std = @import("std");
const protocol = @import("protocol");
const handlers = @import("handlers.zig");
const Packet = @import("Packet.zig");
const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;

const Stream = std.net.Stream;
const Address = std.net.Address;

const Self = @This();

address: Address,
stream: Stream,
allocator: Allocator,

pub fn init(address: Address, stream: Stream, allocator: Allocator) Self {
    return .{
        .address = address,
        .stream = stream,
        .allocator = allocator,
    };
}

pub fn run(self: *Self) !void {
    defer self.stream.close();

    var reader = self.stream.reader();
    while (true) {
        var packet = Packet.read(&reader, self.allocator) catch break;
        defer packet.deinit();

        try handlers.handle(self, &packet);
    }
}

pub fn send(self: *Self, cmd_id: protocol.CmdID, proto: anytype) !void {
    const data = try proto.encode(self.allocator);
    defer self.allocator.free(data);

    const packet = try Packet.encode(@intFromEnum(cmd_id), &.{}, data, self.allocator);
    defer self.allocator.free(packet);

    _ = try self.stream.write(packet);
    std.log.debug("sent packet with id {}", .{cmd_id});
}

pub fn send_empty(self: *Self, cmd_id: protocol.CmdID) !void {
    const packet = try Packet.encode(@intFromEnum(cmd_id), &.{}, &.{}, self.allocator);
    defer self.allocator.free(packet);

    _ = try self.stream.write(packet);
    std.log.debug("sent EMPTY packet with id {}", .{cmd_id});
}
