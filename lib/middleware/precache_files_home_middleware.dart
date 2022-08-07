import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/gif_widget.dart';

class PrecacheFilesHomeMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    fetchGif(const AssetImage("assets/video/animated_logo.gif"));
    return super.onPageCalled(page);
  }
}
