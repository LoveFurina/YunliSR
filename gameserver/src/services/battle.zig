const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;
const Config = @import("config.zig");

pub fn onStartCocoonStage(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.StartCocoonStageCsReq, allocator);

    const config = try Config.configLoader(allocator, "config.json");

    var battle = protocol.SceneBattleInfo.init(allocator);

    for (config.battle_config.monster_wave.items) |wave| {
        var monster_wave = protocol.SceneMonsterWave.init(allocator);
        for (wave.items) |mob_id| {
            {
                const monster = protocol.SceneMonsterInfo{ .monster_id = mob_id };
                try monster_wave.monster_list.append(monster);
            }
            monster_wave.monster_wave_param = protocol.SceneMonsterWaveParam{ .level = config.battle_config.monster_level };
        }
        try battle.monster_wave_list.append(monster_wave);
    }

    for (config.avatar_config.items, 0..) |avatarConf, idx| {
        var avatar = protocol.BattleAvatar.init(allocator);
        avatar.id = avatarConf.id;
        avatar.hp = avatarConf.hp * 100;
        avatar.sp = .{ .sp_cur = avatarConf.sp * 100, .sp_need = 10000 };
        avatar.level = avatarConf.level;
        avatar.rank = avatarConf.rank;
        avatar.promotion = avatarConf.promotion;
        avatar.avatar_type = .AVATAR_FORMAL_TYPE;
        // relics
        for (avatarConf.relics.items) |relic| {
            const r = try relicCoder(allocator, relic.id, relic.level, relic.main_affix_id, relic.stat1, relic.cnt1, relic.stat2, relic.cnt2, relic.stat3, relic.cnt3, relic.stat4, relic.cnt4);
            try avatar.relic_list.append(r);
        }
        // lc
        const lc = protocol.BattleEquipment{ .id = avatarConf.lightcone.id, .rank = avatarConf.lightcone.rank, .level = avatarConf.lightcone.level, .promotion = avatarConf.lightcone.promotion };
        try avatar.equipment_list.append(lc);
        // max trace
        const skills = [_]u32{ 1, 2, 3, 4, 7, 101, 102, 103, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210 };
        var talentLevel: u32 = 0;
        for (skills) |elem| {
            if (elem == 1) {
                talentLevel = 6;
            } else if (elem <= 4) {
                talentLevel = 10;
            } else {
                talentLevel = 1;
            }
            const talent = protocol.AvatarSkillTree{ .point_id = avatar.id * 1000 + elem, .level = talentLevel };
            try avatar.skilltree_list.append(talent);
        }
        // enable technique
        if (avatarConf.use_technique) {
            var targetIndexList = std.ArrayList(u32).init(allocator);
            try targetIndexList.append(0);
            var buff = protocol.BattleBuff{
                .id = 121401,
                .level = 1,
                .owner_index = @intCast(idx),
                .wave_flag = 1,
                .target_index_list = targetIndexList,
                .dynamic_values = std.ArrayList(protocol.BattleBuff.DynamicValuesEntry).init(allocator),
            };
            try buff.dynamic_values.append(protocol.BattleBuff.DynamicValuesEntry{
                .key = .{ .Const = "SkillIndex" },
                .value = 0,
            });
            try battle.buff_list.append(buff);
        }
        try battle.battle_avatar_list.append(avatar);
    }

    battle.battle_id = config.battle_config.battle_id;
    battle.stage_id = config.battle_config.stage_id;
    battle.logic_random_seed = @intCast(@mod(std.time.timestamp(), 0xFFFFFFFF));
    battle.HOFFCBLNFNG = config.battle_config.cycle_count;

    // stage blessings
    for (config.battle_config.blessings.items) |blessing| {
        var targetIndexList = std.ArrayList(u32).init(allocator);
        try targetIndexList.append(0);
        var buff = protocol.BattleBuff{
            .id = blessing.id,
            .level = blessing.level,
            .owner_index = 0,
            .wave_flag = 1,
            .target_index_list = targetIndexList,
            .dynamic_values = std.ArrayList(protocol.BattleBuff.DynamicValuesEntry).init(allocator),
        };
        try buff.dynamic_values.append(protocol.BattleBuff.DynamicValuesEntry{
            .key = .{ .Const = "SkillIndex" },
            .value = 0,
        });
        try battle.buff_list.append(buff);
    }

    try session.send(CmdID.CmdSetAvatarPathScRsp, protocol.SetAvatarPathScRsp{
        .retcode = 0,
        .avatar_id = .Mar_7thRogueType,
    });

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

fn relicCoder(allocator: Allocator, id: u32, level: u32, main_affix_id: u32, stat1: u32, cnt1: u32, stat2: u32, cnt2: u32, stat3: u32, cnt3: u32, stat4: u32, cnt4: u32) !protocol.BattleRelic {
    var relic = protocol.BattleRelic{
        .id = id,
        .main_affix_id = main_affix_id,
        .level = level,
        .sub_affix_list = std.ArrayList(protocol.RelicAffix).init(allocator),
    };
    try relic.sub_affix_list.append(protocol.RelicAffix{ .affix_id = stat1, .cnt = cnt1, .step = 3 });
    try relic.sub_affix_list.append(protocol.RelicAffix{ .affix_id = stat2, .cnt = cnt2, .step = 3 });
    try relic.sub_affix_list.append(protocol.RelicAffix{ .affix_id = stat3, .cnt = cnt3, .step = 3 });
    try relic.sub_affix_list.append(protocol.RelicAffix{ .affix_id = stat4, .cnt = cnt4, .step = 3 });

    return relic;
}
