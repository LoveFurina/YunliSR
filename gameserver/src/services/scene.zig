const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

pub fn onGetCurSceneInfo(session: *Session, _: *const Packet, allocator: Allocator) !void {
    var scene_info = protocol.SceneInfo.init(allocator);
    scene_info.game_mode_type = 1;
    scene_info.plane_id = 20101;
    scene_info.floor_id = 20101001;
    scene_info.entry_id = 2010101;

    { // Character
        var scene_group = protocol.SceneGroupInfo.init(allocator);
        scene_group.state = 1;

        try scene_group.entity_list.append(.{
            .entity = .{
                .actor = .{
                    .base_avatar_id = 1221,
                    .avatar_type = .AVATAR_FORMAL_TYPE,
                    .uid = 1337,
                    .map_layer = 2,
                },
            },
            .motion = .{ .pos = .{ .x = -2300, .y = 19365, .z = 3150 }, .rot = .{} },
        });

        try scene_info.scene_group_list.append(scene_group);
    }

    { // Calyx prop
        var scene_group = protocol.SceneGroupInfo.init(allocator);
        scene_group.state = 1;
        scene_group.group_id = 19;

        var prop = protocol.ScenePropInfo.init(allocator);
        prop.prop_id = 808;
        prop.prop_state = 1;

        try scene_group.entity_list.append(.{
            .group_id = 19,
            .inst_id = 300001,
            .entity_id = 1337,
            .entity = .{
                .prop = prop,
            },
            .motion = .{ .pos = .{ .x = -570, .y = 19364, .z = 4480 }, .rot = .{} },
        });

        try scene_info.scene_group_list.append(scene_group);
    }

    try session.send(CmdID.CmdGetCurSceneInfoScRsp, protocol.GetCurSceneInfoScRsp{
        .scene = scene_info,
        .retcode = 0,
    });
}

pub fn onSceneEntityMove(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.SceneEntityMoveCsReq, allocator);

    for (req.entity_motion_list.items) |entity_motion| {
        if (entity_motion.motion) |motion| {
            std.log.debug("[POSITION] entity_id: {}, motion: {}", .{ entity_motion.entity_id, motion });
        }
    }

    try session.send(CmdID.CmdSceneEntityMoveScRsp, protocol.SceneEntityMoveScRsp{
        .retcode = 0,
        .entity_motion_list = req.entity_motion_list,
        .download_data = null,
    });
}
