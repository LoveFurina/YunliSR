const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

pub fn onPlayerGetToken(session: *Session, _: *const Packet, allocator: Allocator) !void {
    var rsp = protocol.PlayerGetTokenScRsp.init(allocator);

    rsp.retcode = 0;
    rsp.uid = 1337;

    try session.send(CmdID.CmdPlayerGetTokenScRsp, rsp);
}

pub fn onPlayerLogin(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.PlayerLoginCsReq, allocator);

    var basic_info = protocol.PlayerBasicInfo.init(allocator);
    basic_info.stamina = 240;
    basic_info.level = 5;
    basic_info.nickname = .{ .Const = "xeondev" };

    var rsp = protocol.PlayerLoginScRsp.init(allocator);
    rsp.retcode = 0;
    rsp.login_random = req.login_random;
    rsp.stamina = 240;
    rsp.basic_info = basic_info;

    try session.send(CmdID.CmdPlayerLoginScRsp, rsp);
}
