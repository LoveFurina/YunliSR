const std = @import("std");
const protobuf = @import("protobuf");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep_opts = .{ .target = target, .optimize = optimize };

    const protobuf_dep = b.dependency("protobuf", dep_opts);

    if (std.fs.cwd().access("protocol/StarRail.proto", .{})) {
        const protoc_step = protobuf.RunProtocStep.create(b, protobuf_dep.builder, target, .{
            .destination_directory = b.path("protocol/src"),
            .source_files = &.{
                "protocol/StarRail.proto",
            },
            .include_directories = &.{},
        });

        b.getInstallStep().dependOn(&protoc_step.step);
    } else |_| {} // don't invoke protoc if proto definition doesn't exist

    const dispatch = b.dependency("dispatch", dep_opts);
    b.installArtifact(dispatch.artifact("dispatch"));

    const gameserver = b.dependency("gameserver", dep_opts);
    b.installArtifact(gameserver.artifact("gameserver"));

    // "run-dispatch" command
    const dispatch_cmd = b.addRunArtifact(dispatch.artifact("dispatch"));
    dispatch_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        dispatch_cmd.addArgs(args);
    }

    const dispatch_step = b.step("run-dispatch", "Run the dispatch server");
    dispatch_step.dependOn(&dispatch_cmd.step);

    // "run-gameserver" command
    const gameserver_cmd = b.addRunArtifact(gameserver.artifact("gameserver"));
    gameserver_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        gameserver_cmd.addArgs(args);
    }

    const gameserver_step = b.step("run-gameserver", "Run the game server");
    gameserver_step.dependOn(&gameserver_cmd.step);
}
