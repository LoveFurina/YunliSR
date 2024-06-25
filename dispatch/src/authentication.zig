const std = @import("std");
const httpz = @import("httpz");

pub fn onShieldLogin(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onShieldLogin", .{});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .account = .{
                .area_code = "**",
                .email = "reversedrooms@xeondev.com",
                .country = "RU",
                .is_email_verify = "1",
                .token = "mostsecuretokenever",
                .uid = "1337",
            },
        },
    }, .{});
}

pub fn onComboTokenReq(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onComboTokenReq", .{});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .account_type = 1,
            .open_id = "1337",
            .combo_id = "1337",
            .combo_token = "mostsecuretokenever",
            .heartbeat = false,
            .data = "{\"guest\": false}",
        },
    }, .{});
}

pub fn onRiskyApiCheck(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onRiskyApiCheck", .{});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{ .id = "" },
    }, .{});
}
