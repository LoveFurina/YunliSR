const std = @import("std");
const httpz = @import("httpz");
const protocol = @import("protocol");

const authentication = @import("authentication.zig");
const dispatch = @import("dispatch.zig");

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

    try server.listen();
}
