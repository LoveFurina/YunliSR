const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

const AllAvatars = [_]u32{
    1001, 1002, 1003, 1004, 1005, 1006, 1008, 1009, 1013, 1101, 1102, 1103, 1104, 1105, 1106, 1107,
    1108, 1109, 1110, 1111, 1112, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208, 1209, 1210, 1211,
    1212, 1213, 1214, 1215, 1217, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1312,
    1314, 1315, 1221, 1218,
};

pub fn onGetAvatarData(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.GetAvatarDataCsReq, allocator);
    var rsp = protocol.GetAvatarDataScRsp.init(allocator);

    rsp.is_all = req.is_get_all;

    for (AllAvatars) |id| {
        var avatar = protocol.Avatar.init(allocator);
        avatar.base_avatar_id = id;
        avatar.level = 80;
        avatar.promotion = 6;
        avatar.rank = 6;
        try rsp.avatar_list.append(avatar);
    }

    try session.send(CmdID.CmdGetAvatarDataScRsp, rsp);
}
