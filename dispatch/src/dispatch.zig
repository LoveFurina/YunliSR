const std = @import("std");
const httpz = @import("httpz");
const protocol = @import("protocol");
const Base64Encoder = @import("std").base64.standard.Encoder;

pub fn onQueryDispatch(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onQueryDispatch", .{});

    var proto = protocol.GlobalDispatchData.init(res.arena);

    proto.retcode = 0;
    try proto.server_list.append(.{
        .name = .{ .Const = "YunliSR" },
        .display_name = .{ .Const = "YunliSR" },
        .env_type = .{ .Const = "2" },
        .title = .{ .Const = "YunliSR" },
        .dispatch_url = .{ .Const = "http://127.0.0.1:21000/query_gateway" },
    });

    const data = try proto.encode(res.arena);
    const size = Base64Encoder.calcSize(data.len);
    const output = try res.arena.alloc(u8, size);
    _ = Base64Encoder.encode(output, data);

    res.body = output;
}

pub fn onQueryGateway(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onQueryGateway", .{});

    var proto = protocol.Gateserver.init(res.arena);

    proto.retcode = 0;
    proto.use_tcp = true;
    proto.port = 23301;
    proto.ip = .{ .Const = "127.0.0.1" };
    proto.lua_version = .{ .Const = "7327274" };
    proto.ifix_version = .{ .Const = "0" };
    proto.lua_url = .{ .Const = "https://autopatchos.starrails.com/lua/BetaLive/output_7327274_d12d75929650" };
    proto.asset_bundle_url = .{ .Const = "https://autopatchos.starrails.com/asb/BetaLive/output_7327119_c52eec0f6a92" };
    proto.ex_resource_url = .{ .Const = "https://autopatchos.starrails.com/design_data/BetaLive/output_7349339_419592cb2562" };
    proto.MCANJEHAEKO = true;
    proto.PGMFEHFKLBG = true;
    proto.NNPPEAAIHAK = true;
    proto.LGPAAPCPBMD = true;
    proto.GNFPFKJHIDJ = true;
    proto.FKFKCDJNHFL = true;
    proto.AOEKIKFKMGA = true;

    const data = try proto.encode(res.arena);
    const size = Base64Encoder.calcSize(data.len);
    const output = try res.arena.alloc(u8, size);
    _ = Base64Encoder.encode(output, data);

    res.body = output;
}
