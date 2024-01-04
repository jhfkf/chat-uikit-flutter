import 'package:flutter/material.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:url_launcher/url_launcher.dart';


class TIMUIKitSearchNotSupport extends TIMUIKitStatelessWidget {
  TIMUIKitSearchNotSupport({Key? key}) : super(key: key);

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final theme = value.theme;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: hexToColor("ecf3fe"),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // 因为底部有波浪图， icon向上一点，感觉视觉上更协调
              margin: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Text(
                    TIM_t("Web网页端不支持搜索"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.darkTextColor,
                    ),
                  ),
                  Text(
                    TIM_t("请使用 Android/iOS 或 PC 端体验"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  ElevatedButton(
                      onPressed: () {
                        launchUrl(
                          Uri.parse("http://www.suapp.cc"),
                          mode: LaunchMode
                              .externalApplication,
                        );
                      },
                      child: Text(TIM_t("立即下载")))
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                "images/logo_bottom.png",
                package: 'tencent_cloud_chat_uikit',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
              ),
            )
          ],
        ),
      ),
    );
  }
}
