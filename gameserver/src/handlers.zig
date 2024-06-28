const std = @import("std");
const protocol = @import("protocol");
const Session = @import("Session.zig");
const Packet = @import("Packet.zig");
const avatar = @import("services/avatar.zig");
const item = @import("services/item.zig");
const battle = @import("services/battle.zig");
const login = @import("services/login.zig");
const lineup = @import("services/lineup.zig");
const mission = @import("services/mission.zig");
const scene = @import("services/scene.zig");
const misc = @import("services/misc.zig");

const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;
const CmdID = protocol.CmdID;

const log = std.log.scoped(.handlers);

const Action = *const fn (*Session, *const Packet, Allocator) anyerror!void;
const HandlerList = [_]struct { CmdID, Action }{
    .{ CmdID.CmdPlayerGetTokenCsReq, login.onPlayerGetToken },
    .{ CmdID.CmdPlayerLoginCsReq, login.onPlayerLogin },
    .{ CmdID.CmdPlayerHeartBeatCsReq, misc.onPlayerHeartBeat },
    .{ CmdID.CmdGetAvatarDataCsReq, avatar.onGetAvatarData },
    .{ CmdID.CmdGetMultiPathAvatarInfoCsReq, avatar.onGetMultiPathAvatarInfo },
    .{ CmdID.CmdGetBagCsReq, item.onGetBag },
    .{ CmdID.CmdChangeLineupLeaderCsReq, lineup.onChangeLineupLeader },
    .{ CmdID.CmdGetMissionStatusCsReq, mission.onGetMissionStatus },
    .{ CmdID.CmdGetCurLineupDataCsReq, lineup.onGetCurLineupData },
    .{ CmdID.CmdGetCurSceneInfoCsReq, scene.onGetCurSceneInfo },
    .{ CmdID.CmdSceneEntityMoveCsReq, scene.onSceneEntityMove },
    .{ CmdID.CmdStartCocoonStageCsReq, battle.onStartCocoonStage },
    .{ CmdID.CmdPVEBattleResultCsReq, battle.onPVEBattleResult },
};

const DummyCmdList = [_]struct { CmdID, CmdID }{
    .{ CmdID.CmdGetBasicInfoCsReq, CmdID.CmdGetBasicInfoScRsp },
    .{ CmdID.CmdGetMultiPathAvatarInfoCsReq, CmdID.CmdGetMultiPathAvatarInfoScRsp },
    .{ CmdID.CmdGetBagCsReq, CmdID.CmdGetBagScRsp },
    .{ CmdID.CmdGetMarkItemListCsReq, CmdID.CmdGetMarkItemListScRsp },
    .{ CmdID.CmdGetPlayerBoardDataCsReq, CmdID.CmdGetPlayerBoardDataScRsp },
    .{ CmdID.CmdGetCurAssistCsReq, CmdID.CmdGetCurAssistScRsp },
    .{ CmdID.CmdGetAllLineupDataCsReq, CmdID.CmdGetAllLineupDataScRsp },
    .{ CmdID.CmdGetAllServerPrefsDataCsReq, CmdID.CmdGetAllServerPrefsDataScRsp },
    .{ CmdID.CmdGetActivityScheduleConfigCsReq, CmdID.CmdGetActivityScheduleConfigScRsp },
    .{ CmdID.CmdGetMissionDataCsReq, CmdID.CmdGetMissionDataScRsp },
    .{ CmdID.CmdGetMissionEventDataCsReq, CmdID.CmdGetMissionEventDataScRsp },
    .{ CmdID.CmdGetQuestDataCsReq, CmdID.CmdGetQuestDataScRsp },
    .{ CmdID.CmdGetCurChallengeCsReq, CmdID.CmdGetCurChallengeScRsp },
    .{ CmdID.CmdGetRogueCommonDialogueDataCsReq, CmdID.CmdGetRogueCommonDialogueDataScRsp },
    .{ CmdID.CmdGetRogueInfoCsReq, CmdID.CmdGetRogueInfoScRsp },
    .{ CmdID.CmdGetRogueHandbookDataCsReq, CmdID.CmdGetRogueHandbookDataScRsp },
    .{ CmdID.CmdGetRogueEndlessActivityDataCsReq, CmdID.CmdGetRogueEndlessActivityDataScRsp },
    .{ CmdID.CmdChessRogueQueryCsReq, CmdID.CmdChessRogueQueryScRsp },
    .{ CmdID.CmdRogueTournQueryCsReq, CmdID.CmdRogueTournQueryScRsp },
    .{ CmdID.CmdSyncClientResVersionCsReq, CmdID.CmdSyncClientResVersionScRsp },
    .{ CmdID.CmdDailyFirstMeetPamCsReq, CmdID.CmdDailyFirstMeetPamScRsp },
    .{ CmdID.CmdGetBattleCollegeDataCsReq, CmdID.CmdGetBattleCollegeDataScRsp },
    .{ CmdID.CmdGetNpcStatusCsReq, CmdID.CmdGetNpcStatusScRsp },
    .{ CmdID.CmdGetSecretKeyInfoCsReq, CmdID.CmdGetSecretKeyInfoScRsp },
    .{ CmdID.CmdGetHeartDialInfoCsReq, CmdID.CmdGetHeartDialInfoScRsp },
    .{ CmdID.CmdGetVideoVersionKeyCsReq, CmdID.CmdGetVideoVersionKeyScRsp },
    .{ CmdID.CmdGetCurBattleInfoCsReq, CmdID.CmdGetCurBattleInfoScRsp },
    .{ CmdID.CmdHeliobusActivityDataCsReq, CmdID.CmdHeliobusActivityDataScRsp },
    .{ CmdID.CmdGetEnteredSceneCsReq, CmdID.CmdGetEnteredSceneScRsp },
    .{ CmdID.CmdGetAetherDivideInfoCsReq, CmdID.CmdGetAetherDivideInfoScRsp },
    .{ CmdID.CmdGetMapRotationDataCsReq, CmdID.CmdGetMapRotationDataScRsp },
    .{ CmdID.CmdGetRogueCollectionCsReq, CmdID.CmdGetRogueCollectionScRsp },
    .{ CmdID.CmdGetRogueExhibitionCsReq, CmdID.CmdGetRogueExhibitionScRsp },
    .{ CmdID.CmdPlayerReturnInfoQueryCsReq, CmdID.CmdPlayerReturnInfoQueryScRsp },
    .{ CmdID.CmdPlayerLoginFinishCsReq, CmdID.CmdPlayerLoginFinishScRsp },
    .{ CmdID.CmdGetLevelRewardTakenListCsReq, CmdID.CmdGetLevelRewardTakenListScRsp },
    .{ CmdID.CmdGetMainMissionCustomValueCsReq, CmdID.CmdGetMainMissionCustomValueScRsp },
    .{ CmdID.CmdRelicRecommendCsReq, CmdID.CmdRelicRecommendScRsp },
};

const SuppressLogList = [_]CmdID{CmdID.CmdSceneEntityMoveCsReq};

pub fn handle(session: *Session, packet: *const Packet) !void {
    var arena = ArenaAllocator.init(session.allocator);
    defer arena.deinit();

    const cmd_id: CmdID = @enumFromInt(packet.cmd_id);

    inline for (HandlerList) |handler| {
        if (handler[0] == cmd_id) {
            try handler[1](session, packet, arena.allocator());
            if (!std.mem.containsAtLeast(CmdID, &SuppressLogList, 1, &[_]CmdID{cmd_id})) {
                log.debug("packet {} was handled", .{cmd_id});
            }
            return;
        }
    }

    inline for (DummyCmdList) |pair| {
        if (pair[0] == cmd_id) {
            try session.send_empty(pair[1]);
            return;
        }
    }

    log.warn("packet {} was ignored", .{cmd_id});
}
