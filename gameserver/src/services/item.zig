const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;
const Config = @import("config.zig");
const ArrayList = std.ArrayList;

pub fn onGetBag(session: *Session, _: *const Packet, allocator: Allocator) !void {
    const config = try Config.configLoader(allocator, "config.json");
    var generator = UidGenerator().init();

    // fake item inventory
    // TODO: make real one
    var rsp = protocol.KKGLDLPALGO.init(allocator); // GetBagScRsp
    rsp.equipment_list = ArrayList(protocol.LLLPHAJABGB).init(allocator); // Equipments
    rsp.relic_list = ArrayList(protocol.DADJGGOCGJF).init(allocator); // Relics

    for (config.avatar_config.items) |avatarConf| {
        // lc
        const lc = protocol.LLLPHAJABGB{
            .unique_id = generator.nextId(),
            .APAMKMIGAOP = avatarConf.lightcone.id, // tid
            .HDHDLMJIFAO = true, // lock
            .level = avatarConf.lightcone.level,
            .rank = avatarConf.lightcone.rank,
            .promotion = avatarConf.lightcone.promotion,
            .OKMNCEFGIMF = avatarConf.id, // base avatar id
        };
        try rsp.equipment_list.append(lc);

        // relics
        for (avatarConf.relics.items) |input| {
            var r = protocol.DADJGGOCGJF{
                .APAMKMIGAOP = input.id, // tid
                .main_affix_id = input.main_affix_id,
                .unique_id = generator.nextId(),
                .exp = 0,
                .OKMNCEFGIMF = avatarConf.id, // base avatar id
                .HDHDLMJIFAO = true, // lock
                .level = input.level,
                .sub_affix_list = ArrayList(protocol.RelicAffix).init(allocator),
            };
            try r.sub_affix_list.append(protocol.RelicAffix{ .affix_id = input.stat1, .cnt = input.cnt1, .step = 3 });
            try r.sub_affix_list.append(protocol.RelicAffix{ .affix_id = input.stat2, .cnt = input.cnt2, .step = 3 });
            try r.sub_affix_list.append(protocol.RelicAffix{ .affix_id = input.stat3, .cnt = input.cnt3, .step = 3 });
            try r.sub_affix_list.append(protocol.RelicAffix{ .affix_id = input.stat4, .cnt = input.cnt4, .step = 3 });

            std.debug.print("adding {}:{}:{}\n", .{ avatarConf.id, input.id, r.unique_id });
            try rsp.relic_list.append(r);
        }
    }

    try session.send(CmdID.CmdGetBagScRsp, rsp);
}

pub fn UidGenerator() type {
    return struct {
        current_id: u32,

        const Self = @This();

        pub fn init() Self {
            return Self{ .current_id = 0 };
        }

        pub fn nextId(self: *Self) u32 {
            self.current_id +%= 1; // Using wrapping addition
            return self.current_id;
        }
    };
}
