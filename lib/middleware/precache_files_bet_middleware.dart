import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global/gif_widget.dart';

class PrecacheFilesBetMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    precacheImage(const AssetImage('assets/video/starting.gif'), Get.context!);
    fetchGif(const AssetImage("assets/video/started1-no-loop.gif"));
    precacheImage(const AssetImage("assets/video/started2.gif") , Get.context!);
    fetchGif(const AssetImage('assets/video/end.gif'));
    return super.onPageCalled(page);
  }
}
