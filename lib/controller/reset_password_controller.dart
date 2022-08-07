import 'package:bet/global/notification.dart';
import 'package:bet/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ResetPasswordController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  RxBool isLoading = false.obs;
  late Map params;

  @override
  void onInit() {
    params = Get.parameters;
    super.onInit();
  }

  handleResetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (passwordController.text != repeatPasswordController.text) {
      showSnackbar(
          "Error", "Password not to same", LineIcons.exclamationTriangle);
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    Map data = {
      "token": params['token'],
      "password": passwordController.text,
    };
    dynamic json = await RemoteServices.resetPasswordService(data);
    isLoading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        showSnackbar("Success", "Login Now!", LineIcons.check);
        backButtonHandle();
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void backButtonHandle() {
    Get.offAllNamed("/home");
  }
}
