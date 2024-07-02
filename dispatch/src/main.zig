const std = @import("std");
const builtin = @import("builtin");
const httpz = @import("httpz");
const protocol = @import("protocol");

const authentication = @import("authentication.zig");
const dispatch = @import("dispatch.zig");

pub const std_options = .{
    .log_level = switch (builtin.mode) {
        .Debug => .debug,
        else => .info,
    },
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server().init(allocator, .{ .port = 21000 });
    var router = server.router();

    router.get("/query_dispatch", dispatch.onQueryDispatch);
    router.get("/query_gateway", dispatch.onQueryGateway);
    router.post("/account/risky/api/check", authentication.onRiskyApiCheck);
    router.post("/:product_name/mdk/shield/api/login", authentication.onShieldLogin);
    router.post("/:product_name/combo/granter/login/v2/login", authentication.onComboTokenReq);

    // session login
    router.get("/:product_name/combo/granter/api/getConfig", authentication.onGetConfig);
    router.get("/:product_name/mdk/shield/api/loadConfig", authentication.onLoadConfig);
    router.post("/:product_name/mdk/shield/api/verify", authentication.onVerifyLogin);

    // well, just block it with proxy is easier
    // router.post("/hkrpg_global/combo/granter/api/compareProtocolVersion", onCompareProtocol);
    // router.get("/combo/box/api/config/sw/precache", onPreCache);
    // router.get("/combo/box/api/config/sdk/combo", onCombo);

    try server.listen();
}

pub fn onCompareProtocol(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onCompareProtocol: {any}", .{req.body_len});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .modified = "false",
            .protocal = null,
        },
    }, .{});
}

pub fn onPreCache(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onPreCache: {any}", .{req.body_len});

    try res.json(.{
        .retcode = 1,
        .message = "ERROR",
        .data = .{
            .vals = "{\"enable\": \"false\", \"url\": 0 }",
        },
    }, .{});
}

pub fn onCombo(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onCombo: {any}", .{req.body_len});

    try res.json(.{
        .retcode = 1,
        .message = "ERROR",
        .data = .{
            .vals = .{
                .kibana_pc_config = "{\"enable\": 0, \"level\": \"Info\",\"modules\": [\"download\"] }",
                .network_report_config = "{\"enable\": 0, \"status_codes\": [206], \"url_paths\": [\"dataUpload\", \"red_dot\"] }",
                .list_price_tierv2_enable = "false",
                .pay_payco_centered_host = "bill.payco.com",
                .telemetry_config = "{\n \"dataupload_enable\": 0,\n}",
                .enable_web_dpi = "true",
            },
        },
    }, .{});
}
