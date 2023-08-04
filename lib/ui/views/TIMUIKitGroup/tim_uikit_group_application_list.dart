import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';


import 'package:tencent_cloud_chat_uikit/data_services/group/group_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/extension/v2_tim_user_full_info_ext_entity.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';


import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

import '../../../tencent_cloud_chat_uikit.dart';

typedef GroupApplicationItemBuilder = Widget Function(
    BuildContext context, V2TimGroupApplication applicationInfo, int index);

enum ApplicationStatus {
  none,
  accept,
  reject,
}

class TIMUIKitGroupApplicationList extends StatefulWidget {
  /// the builder for the request item
  final GroupApplicationItemBuilder? itemBuilder;

  /// group ID
  final String groupID;

  const TIMUIKitGroupApplicationList(
      {Key? key, this.itemBuilder, required this.groupID})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TIMUIKitGroupApplicationListState();
}

class TIMUIKitGroupApplicationListState
    extends TIMUIKitState<TIMUIKitGroupApplicationList> {
  final TUIChatGlobalModel model = serviceLocator<TUIChatGlobalModel>();
  final GroupServices _groupServices = serviceLocator<GroupServices>();
  List<V2TimGroupApplication> groupApplicationList = [];
  List<ApplicationStatus> applicationStatusList = [];

  Map<String, V2TimUserFullInfo>? userMap;

  @override
  void initState() {
    super.initState();
    groupApplicationList = model.groupApplicationList
        .where((item) => (item.groupID == widget.groupID))
        .toList();

    applicationStatusList =
        groupApplicationList.map((item) => ApplicationStatus.none).toList();

    var userIds = groupApplicationList.where((item) => item.fromUser != null).map((e) => e.fromUser!).toList();
    final userResult =  TIMUIKitCore.getSDKInstance().getUsersInfo(userIDList: userIds);
    Map<String, V2TimUserFullInfo> tmpMap = {};
    userResult.then((value) {
      value.data?.forEach((user) {
        tmpMap[user.userID ?? ""] = user;
      });
      userMap = tmpMap;
      setState(() {

      });
    });
  }

  GroupApplicationItemBuilder _getItemBuilder() {
    return widget.itemBuilder ?? _defaultItemBuilder;
  }

  Widget _defaultItemBuilder (
      BuildContext context, V2TimGroupApplication applicationInfo, int index) {
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    final ApplicationStatus currentStatus = applicationStatusList[index];
    applicationInfo.fromUser;
    String _getUserName(V2TimUserFullInfo? userFullInfo) {
      return userFullInfo?.nickName ?? "";
      // if (applicationInfo.fromUserNickName != null &&
      //     applicationInfo.fromUserNickName!.isNotEmpty &&
      //     applicationInfo.fromUserNickName != applicationInfo.fromUser) {
      //   return "${applicationInfo.fromUserNickName} (${applicationInfo.fromUser})";
      // } else {
      //   return "${applicationInfo.fromUser}";
      // }
    }

    String _getRequestMessage() {
      String option2 = applicationInfo.requestMsg ?? "";
      return TIM_t_para("验证消息: {{option2}}", "验证消息: $option2")(
          option2: option2);
    }
    String fromUser = applicationInfo.fromUser ?? "";
    V2TimUserFullInfo? userFullInfo;
    if (userMap?.keys.contains(fromUser) ?? false) {
      userFullInfo = userMap?[fromUser];
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                color: theme.weakDividerColor ?? const Color(0xFFDBDBDB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: SizedBox(
              height: 40,
              width: 40,
              child: Avatar(
                  faceUrl: userFullInfo != null ? (userFullInfo.faceUrl ?? "") : (applicationInfo.fromUserFaceUrl ?? ""),
                  showName: userFullInfo?.nickName ?? "")
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getUserName(userFullInfo),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.darkTextColor),
              ),
              Text(
                _getRequestMessage(),
                style: TextStyle(fontSize: 15, color: theme.weakTextColor),
              ),
            ],
          )),
          if (currentStatus == ApplicationStatus.none &&
              applicationInfo.handleStatus == 0)
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8),
              child: InkWell(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: theme.primaryColor,
                        border: Border.all(
                            width: 1,
                            color: theme.weakTextColor ??
                                CommonColor.weakTextColor)),
                    child: Text(
                      TIM_t("同意"), // agree
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () async {
                    final res = await _groupServices.acceptGroupApplication(
                      groupID: applicationInfo.groupID,
                      fromUser: applicationInfo.fromUser!,
                      toUser: applicationInfo.toUser!,
                      type: applicationInfo.type,
                      addTime: applicationInfo.addTime ?? 0,
                    );
                    if (res.code == 0) {
                      setState(() {
                        applicationStatusList[index] = ApplicationStatus.accept;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        model.refreshGroupApplicationList();
                      });
                    }
                  }),
            ),
          if (currentStatus == ApplicationStatus.none &&
              applicationInfo.handleStatus == 0)
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color:
                            theme.weakTextColor ?? CommonColor.weakTextColor)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  TIM_t("拒绝"), // reject
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                ),
              ),
              onTap: () async {
                final res = await _groupServices.refuseGroupApplication(
                    addTime: applicationInfo.addTime!,
                    groupID: applicationInfo.groupID,
                    fromUser: applicationInfo.fromUser!,
                    toUser: applicationInfo.toUser!,
                    type:
                        GroupApplicationTypeEnum.values[applicationInfo.type]);
                if (res.code == 0) {
                  setState(() {
                    applicationStatusList[index] = ApplicationStatus.reject;
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    model.refreshGroupApplicationList();
                  });
                }
              },
            ),
          if (currentStatus == ApplicationStatus.accept ||
              applicationInfo.handleStatus == 1)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                TIM_t("已同意"),
                style: TextStyle(fontSize: 15, color: theme.weakTextColor),
              ),
            ),
          if (currentStatus == ApplicationStatus.reject ||
              applicationInfo.handleStatus == 2)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                TIM_t("已拒绝"),
                style: TextStyle(fontSize: 15, color: theme.weakTextColor),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: model)],
      builder: (context, w) {
        final isDesktopScreen =
            TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
        return Container(
          decoration: isDesktopScreen ? null : BoxDecoration(color: theme.weakBackgroundColor),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: groupApplicationList.length,
            itemBuilder: (context, index) {
              final applicationInfo = groupApplicationList[index];
              final itemBuilder = _getItemBuilder();
              return itemBuilder(context, applicationInfo, index);
            },
          ),
        );
      },
    );
  }
}
