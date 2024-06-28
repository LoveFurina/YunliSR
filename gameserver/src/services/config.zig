const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const BattleConfig = struct {
    battle_id: u32,
    stage_id: u32,
    cycle_count: u32,
    monster_wave: ArrayList(ArrayList(u32)),
    monster_level: u32,
    blessings: ArrayList(u32),
};

const Lightcone = struct {
    id: u32,
    rank: u32,
    level: u32,
    promotion: u32,
};

pub const Relic = struct {
    id: u32,
    level: u32,
    main_affix_id: u32,
    sub_count: u32,
    stat1: u32,
    cnt1: u32,
    stat2: u32,
    cnt2: u32,
    stat3: u32,
    cnt3: u32,
    stat4: u32,
    cnt4: u32,
};

const Avatar = struct {
    id: u32,
    hp: u32,
    sp: u32,
    level: u32,
    promotion: u32,
    rank: u32,
    lightcone: Lightcone,
    relics: ArrayList(Relic),
    use_technique: bool,
};

pub const GameConfig = struct {
    battle_config: BattleConfig,
    avatar_config: ArrayList(Avatar),
};

pub fn configLoader(allocator: Allocator, filename: []const u8) !GameConfig {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    // Read the file contents
    const file_size = try file.getEndPos();
    const buffer = try file.readToEndAlloc(allocator, file_size);
    defer allocator.free(buffer);

    // Parse the JSON data
    var json_tree = try std.json.parseFromSlice(std.json.Value, allocator, buffer, .{});
    defer json_tree.deinit();

    // Access JSON fields
    const root = json_tree.value;
    const config: GameConfig = try parseConfig(root, allocator);

    return config;
}

fn parseConfig(root: anytype, allocator: Allocator) !GameConfig {
    const battle_config_json = root.object.get("battle_config").?;
    var battle_config = BattleConfig{
        .battle_id = @intCast(battle_config_json.object.get("battle_id").?.integer),
        .stage_id = @intCast(battle_config_json.object.get("stage_id").?.integer),
        .cycle_count = @intCast(battle_config_json.object.get("cycle_count").?.integer),
        .monster_wave = ArrayList(ArrayList(u32)).init(allocator),
        .monster_level = @intCast(battle_config_json.object.get("monster_level").?.integer),
        .blessings = ArrayList(u32).init(allocator),
    };
    std.debug.print("loading config stageID = {}\n", .{battle_config.stage_id});

    for (battle_config_json.object.get("monster_wave").?.array.items) |wave| {
        var wave_list = ArrayList(u32).init(allocator);
        for (wave.array.items) |monster| {
            try wave_list.append(@intCast(monster.integer));
        }
        try battle_config.monster_wave.append(wave_list);
    }

    for (battle_config_json.object.get("blessings").?.array.items) |blessing| {
        try battle_config.blessings.append(@intCast(blessing.integer));
    }

    var avatar_config = ArrayList(Avatar).init(allocator);
    for (root.object.get("avatar_config").?.array.items) |avatar_json| {
        var avatar = Avatar{
            .id = @intCast(avatar_json.object.get("id").?.integer),
            .hp = @intCast(avatar_json.object.get("hp").?.integer),
            .sp = @intCast(avatar_json.object.get("sp").?.integer),
            .level = @intCast(avatar_json.object.get("level").?.integer),
            .promotion = @intCast(avatar_json.object.get("promotion").?.integer),
            .rank = @intCast(avatar_json.object.get("rank").?.integer),
            .lightcone = undefined,
            .relics = ArrayList(Relic).init(allocator),
            .use_technique = avatar_json.object.get("use_technique").?.bool,
        };

        const lightcone_json = avatar_json.object.get("lightcone").?;
        avatar.lightcone = Lightcone{
            .id = @intCast(lightcone_json.object.get("id").?.integer),
            .rank = @intCast(lightcone_json.object.get("rank").?.integer),
            .level = @intCast(lightcone_json.object.get("level").?.integer),
            .promotion = @intCast(lightcone_json.object.get("promotion").?.integer),
        };

        for (avatar_json.object.get("relics").?.array.items) |relic_str| {
            const relic = try parseRelic(relic_str.string, allocator);
            try avatar.relics.append(relic);
        }

        try avatar_config.append(avatar);
    }

    return GameConfig{
        .battle_config = battle_config,
        .avatar_config = avatar_config,
    };
}

fn parseRelic(relic_str: []const u8, allocator: Allocator) !Relic {
    var tokens = ArrayList([]const u8).init(allocator);
    defer tokens.deinit();

    var iterator = std.mem.tokenize(u8, relic_str, ",");

    while (iterator.next()) |token| {
        try tokens.append(token);
    }

    const tokens_slice = tokens.items;

    if (tokens_slice.len < 8) {
        std.debug.print("relic parsing error: {s}\n", .{relic_str});
        return error.InsufficientTokens;
    }

    const stat1 = try parseStatCount(tokens_slice[4]);
    const stat2 = try parseStatCount(tokens_slice[5]);
    const stat3 = try parseStatCount(tokens_slice[6]);
    const stat4 = try parseStatCount(tokens_slice[7]);

    const relic = Relic{
        .id = try std.fmt.parseInt(u32, tokens_slice[0], 10),
        .level = try std.fmt.parseInt(u32, tokens_slice[1], 10),
        .main_affix_id = try std.fmt.parseInt(u32, tokens_slice[2], 10),
        .sub_count = try std.fmt.parseInt(u32, tokens_slice[3], 10),
        .stat1 = stat1.stat,
        .cnt1 = stat1.count,
        .stat2 = stat2.stat,
        .cnt2 = stat2.count,
        .stat3 = stat3.stat,
        .cnt3 = stat3.count,
        .stat4 = stat4.stat,
        .cnt4 = stat4.count,
    };

    return relic;
}

const StatCount = struct {
    stat: u32,
    count: u32,
};

fn parseStatCount(token: []const u8) !StatCount {
    if (std.mem.indexOfScalar(u8, token, ':')) |colon_index| {
        const stat = try std.fmt.parseInt(u32, token[0..colon_index], 10);
        const count = try std.fmt.parseInt(u32, token[colon_index + 1 ..], 10);
        return StatCount{ .stat = stat, .count = count };
    } else {
        return error.InvalidFormat;
    }
}
