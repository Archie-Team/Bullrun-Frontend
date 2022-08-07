import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/storage.dart';

class TokenCheckMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    return (!Storage.isTokenSaved.value)
        ? const RouteSettings(name: "/login-signup")
        : null;
  }
}
