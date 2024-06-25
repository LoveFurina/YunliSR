const std = @import("std");
const network = @import("network.zig");
const handlers = @import("handlers.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    try network.listen(allocator);
}
