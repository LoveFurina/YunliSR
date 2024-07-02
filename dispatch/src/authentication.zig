const std = @import("std");
const httpz = @import("httpz");

pub fn onShieldLogin(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onShieldLogin: {any}", .{req.body_len});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .account = .{
                .area_code = "**",
                .email = "LoveFurina",
                .country = "RU",
                .is_email_verify = "1",
                .token = "aa",
                .uid = "1234",
            },
        },
    }, .{});
}

pub fn onVerifyLogin(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onVerifyLogin: {any}", .{req.body_len});

    var token: []const u8 = "aa";
    var uid: []const u8 = "1234";
    if (try req.jsonObject()) |t| {
        if (t.get("token")) |token_value| {
            token = token_value.string;
        }
        if (t.get("uid")) |uid_value| {
            uid = uid_value.string;
        }
    }

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .account = .{
                .email = "abc@abc.com",
                .token = token,
                .uid = uid,
            },
        },
    }, .{});
}

pub fn onComboTokenReq(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onComboTokenReq: {any}", .{req.body_len});

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

pub fn onRiskyApiCheck(req: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onRiskyApiCheck: {any}", .{req.body_len});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{ .id = "" },
    }, .{});
}

pub fn onGetConfig(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onGetConfig: ", .{});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .protocol = true,
            .qr_enabled = false,
            .log_level = "INFO",
            .announce_url = "",
            .push_alias_type = 0,
            .disable_ysdk_guard = true,
            .enable_announce_pic_popup = false,
            .app_name = "崩�??RPG",
            .qr_enabled_apps = .{
                .bbs = false,
                .cloud = false,
            },
            .qr_app_icons = .{
                .app = "",
                .bbs = "",
                .cloud = "",
            },
            .qr_cloud_display_name = "",
            .enable_user_center = true,
            .functional_switch_configs = .{},
        },
    }, .{});
}

pub fn onLoadConfig(_: *httpz.Request, res: *httpz.Response) !void {
    std.log.debug("onLoadConfig: ", .{});

    try res.json(.{
        .retcode = 0,
        .message = "OK",
        .data = .{
            .id = 24,
            .game_key = "hkrpg_global",
            .client = "PC",
            .identity = "I_IDENTITY",
            .guest = false,
            .ignore_versions = "",
            .scene = "S_NORMAL",
            .name = "崩�??RPG",
            .disable_regist = false,
            .enable_email_captcha = false,
            .thirdparty = .{ "fb", "tw", "gl", "ap" },
            .disable_mmt = false,
            .server_guest = false,
            .thirdparty_ignore = .{},
            .enable_ps_bind_account = false,
            .thirdparty_login_configs = .{
                .tw = .{
                    .token_type = "TK_GAME_TOKEN",
                    .game_token_expires_in = 2592000,
                },
                .ap = .{
                    .token_type = "TK_GAME_TOKEN",
                    .game_token_expires_in = 604800,
                },
                .fb = .{
                    .token_type = "TK_GAME_TOKEN",
                    .game_token_expires_in = 2592000,
                },
                .gl = .{
                    .token_type = "TK_GAME_TOKEN",
                    .game_token_expires_in = 604800,
                },
            },
            .initialize_firebase = false,
            .bbs_auth_login = false,
            .bbs_auth_login_ignore = {},
            .fetch_instance_id = false,
            .enable_flash_login = false,
        },
    }, .{});
}
