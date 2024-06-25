const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

pub fn onGetCurLineupData(session: *Session, _: *const Packet, allocator: Allocator) !void {
    const avatar = protocol.LineupAvatar{
        .id = 1221,
        .slot = 0,
        .satiety = 0,
        .hp = 10000,
        .avatar_type = protocol.AvatarType.AVATAR_FORMAL_TYPE,
        .sp = .{ .sp_cur = 10000, .sp_need = 10000 },
    };

    var lineup = protocol.LineupInfo.init(allocator);
    lineup.name = .{ .Const = "Squad 1" };
    try lineup.avatar_list.append(avatar);

    try session.send(CmdID.CmdGetCurLineupDataScRsp, protocol.GetCurLineupDataScRsp{
        .retcode = 0,
        .lineup = lineup,
    });
}
