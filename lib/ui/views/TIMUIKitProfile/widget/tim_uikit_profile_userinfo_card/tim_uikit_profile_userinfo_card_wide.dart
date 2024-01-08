import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/api/api.dart';
import 'package:tencent_cloud_chat_uikit/api/utils_api.dart';
import 'package:tencent_cloud_chat_uikit/util/user_utils.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/avatar.dart';

import 'package:tencent_cloud_chat_uikit/extension/v2_tim_user_full_info_ext_entity.dart';

class TIMUIKitProfileUserInfoCardWide extends TIMUIKitStatelessWidget {
  /// User info
  final V2TimUserFullInfo? userInfo;
  final bool isJumpToPersonalProfile;
  final VoidCallback? onClickAvatar;

  /// If shows the arrow icon on the right
  final bool showArrowRightIcon;

  TIMUIKitProfileUserInfoCardWide(
      {Key? key,
      this.userInfo,
      this.onClickAvatar,
      @Deprecated(
          "This info card can no longer navigate to default personal profile page automatically, please deal with it manually.")
      this.isJumpToPersonalProfile = false,
      this.showArrowRightIcon = false})
      : super(key: key);

  Future uniqueId() async {
    String loginUser = await UserUtils.loginUser();
    if (userInfo?.userID == loginUser) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("uniqueId") ?? "";
    }
    // 搜索好友
    Map<String, dynamic> params = {
      "accid": userInfo?.userID ?? ""
    };
    DataResult result = await UtilsApi.baseQueryPost(
        url: Api.appUserQueryUserId, params: params,  isLongAwaitShow: false);
    Map resultMap = result.data;
    if (resultMap.keys.contains("uniqueId")) {
      return "${resultMap['uniqueId']}";
    }
    return "";
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final faceUrl = userInfo?.faceUrl ?? "";
    final nickName = userInfo?.nickName ?? "";
    final signature = userInfo?.selfSignature;

    final showName = nickName != "" ? nickName : userInfo?.accid;

    return Container(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: SelectableText(
                    showName ?? "",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  margin: const EdgeInsets.only(right: 10),
                ),
                Row(
                  children: [
                    Text(
                      "ID:  ",
                      style:
                          TextStyle(fontSize: 12, color: theme.weakTextColor),
                    ),
                    Expanded(
                        child: FutureBuilder(
                      future: uniqueId(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SelectableText(
                            "${snapshot.data}",
                            style: TextStyle(
                                fontSize: 12, color: theme.weakTextColor),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
                  ],
                ),
                if (signature != null)
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    child: SelectableText(signature,
                        style: TextStyle(
                            fontSize: 14, color: hexToColor("7f7f7f"))),
                  )
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: InkWell(
                  onTap: onClickAvatar,
                  child: Avatar(
                    faceUrl: faceUrl,
                    isShowBigWhenClick: onClickAvatar == null,
                    showName: showName ?? "",
                    type: 1,
                  ),
                ),
              ),
              showArrowRightIcon
                  ? const Icon(Icons.keyboard_arrow_right)
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
