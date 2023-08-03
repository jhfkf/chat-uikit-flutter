import '../tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/extension/v2_tim_group_info_ext_entity.dart';

class GroupUtils {
  static Future<bool> canCheckAuthToFriendInfo(
      V2TimGroupInfo? groupInfo, String targetUser) async {
    final res = await TIMUIKitCore.getSDKInstance().getLoginUser();
    if (res.code != 0) {
      return false;
    }
    if (res.data! == targetUser) {
      return true;
    }
    if (groupInfo?.isPrivate ?? false) {
      // 是否私聊模式
      final isGroupOwner =
          groupInfo?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER;
      final isAdmin =
          groupInfo?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
      final isMember =
          groupInfo?.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
      if (isMember) {
        // 自己是成员
        final res = await TencentImSDKPlugin.v2TIMManager
            .getGroupManager()
            .getGroupMembersInfo(
                groupID: groupInfo!.groupID, memberList: [targetUser]);
        if (res.code == 0 && (res.data?.isNotEmpty ?? false)) {
          V2TimGroupMemberFullInfo info = res.data!.first;
          final isGroupOwner =
              info.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_OWNER;
          final isAdmin =
              info.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_ADMIN;
          final isMember =
              info.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
          if (isGroupOwner || isAdmin) {
            // 对方是群主或者管理员
          } else {
            return false;
          }
        }
      }
    }
    return true;
  }

  static Future<V2TimGroupMemberFullInfo?> canCheckAuthToManager(
      V2TimGroupInfo? groupInfo, String targetUser) async {
    if (groupInfo == null) {
      return null;
    }
    final currentUserResult =
        await TIMUIKitCore.getSDKInstance().getLoginUser();
    if (currentUserResult.code != 0) {
      return null;
    }
    if (groupInfo.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER) {
      return null;
    }
    final res = await TencentImSDKPlugin.v2TIMManager
        .getGroupManager()
        .getGroupMembersInfo(
            groupID: groupInfo.groupID, memberList: [targetUser]);
    if (res.code == 0 && (res.data?.isNotEmpty ?? false)) {
      V2TimGroupMemberFullInfo info = res.data!.first;
      final isMember =
          info.role == GroupMemberRoleType.V2TIM_GROUP_MEMBER_ROLE_MEMBER;
      if (isMember) {
        // 对方是群主或者管理员
        return info;
      }
    }
    return null;
  }
}
