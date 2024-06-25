const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;

pub fn onStartCocoonStage(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.StartCocoonStageCsReq, allocator);

    var avatar = protocol.BattleAvatar.init(allocator);
    avatar.id = 1221;
    avatar.hp = 10000;
    avatar.sp = .{ .sp_cur = 10000, .sp_need = 10000 };
    avatar.level = 80;
    avatar.rank = 6;
    avatar.promotion = 6;
    avatar.avatar_type = .AVATAR_FORMAL_TYPE;

    var battle = protocol.SceneBattleInfo.init(allocator);
    for (0..req.wave) |_| {
        const monster = protocol.SceneMonsterInfo{ .monster_id = 3024020 };
        var monster_wave = protocol.SceneMonsterWave.init(allocator);
        try monster_wave.monster_list.append(monster);
        try battle.monster_wave_list.append(monster_wave);
    }

    try battle.battle_avatar_list.append(avatar);
    battle.battle_id = 1;
    battle.stage_id = 201012311;
    battle.logic_random_seed = @intCast(@mod(std.time.timestamp(), 0xFFFFFFFF));

    try session.send(CmdID.CmdStartCocoonStageScRsp, protocol.StartCocoonStageScRsp{
        .retcode = 0,
        .cocoon_id = req.cocoon_id,
        .prop_entity_id = req.prop_entity_id,
        .wave = req.wave,
        .battle_info = battle,
    });
}

pub fn onPVEBattleResult(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.PVEBattleResultCsReq, allocator);

    var rsp = protocol.PVEBattleResultScRsp.init(allocator);
    rsp.battle_id = req.battle_id;
    rsp.end_status = req.end_status;

    try session.send(CmdID.CmdPVEBattleResultScRsp, rsp);
}
