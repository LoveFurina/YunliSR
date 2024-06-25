const std = @import("std");
const protocol = @import("protocol");
const CmdID = protocol.CmdID;
const Session = @import("../Session.zig");
const Packet = @import("../Packet.zig");
const Allocator = std.mem.Allocator;
const B64Decoder = std.base64.standard.Decoder;

pub fn onPlayerHeartBeat(session: *Session, packet: *const Packet, allocator: Allocator) !void {
    const req = try packet.getProto(protocol.PlayerHeartBeatCsReq, allocator);

    const downloadDataBin = "CDMQuQoa1AFDUy5Vbml0eUVuZ2luZS5HYW1lT2JqZWN0LkZpbmQoIlVJUm9vdC9BYm92ZURpYWxvZy9CZXRhSGludERpYWxvZyhDbG9uZSkiKTpHZXRDb21wb25lbnRJbkNoaWxkcmVuKHR5cGVvZihDUy5SUEcuQ2xpZW50LkxvY2FsaXplZFRleHQpKS50ZXh0ID0gIll1bmxpU1IgaXMgYSBmcmVlIGFuZCBvcGVuIHNvdXJjZSBzb2Z0d2FyZS4gZGlzY29yZC5nZy9yZXZlcnNlZHJvb21zIg==";
    const size = try B64Decoder.calcSizeForSlice(downloadDataBin);
    const buf = try allocator.alloc(u8, size);
    _ = try B64Decoder.decode(buf, downloadDataBin);
    const data = try protocol.ClientDownloadData.decode(buf, allocator);

    const rsp = protocol.PlayerHeartBeatScRsp{
        .retcode = 0,
        .client_time_ms = req.client_time_ms,
        .server_time_ms = @intCast(std.time.timestamp()),
        .download_data = data,
    };

    try session.send(CmdID.CmdPlayerHeartBeatScRsp, rsp);
}
