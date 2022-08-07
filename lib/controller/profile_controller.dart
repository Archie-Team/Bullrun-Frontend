import 'package:bet/view/dialog/dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/notification.dart';
import '../global/storage.dart';
import '../global/widgets.dart';
import '../model/user_model.dart';
import '../services/remote_services.dart';

class ProfileController extends GetxController {
  TextEditingController twoStep = TextEditingController();
  Rx<UserModel> userModel = UserModel().obs;
  RxBool loading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserProfile().then((value) {
      userModel.value = value!;
      if (!userModel
          .value.user!.security!.twoFactorAuthentication!.isEnabled!) {
        showDialogEnableAuth(
            imageData: userModel
                .value.user!.security!.twoFactorAuthentication!.otpAuthQR!,
            secret: userModel
                .value.user!.security!.twoFactorAuthentication!.secret!);
      }
    });
  }

  Future<UserModel?> getUserProfile() async {
    dynamic json = await RemoteServices.getUserInfoService();
    if (json != null) {
      if (json['message'] == "OK") {
        loading.value = false;
        print(json['data']);
        return UserModel.fromJson(json['data']);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
        return null;
      }
    }
    return null;
  }

  void logout() async {
    dynamic json = await RemoteServices.logOutService();
    if (json != null) {
      if (json['message'] == "OK") {
        clearAll();
        Get.offAllNamed('/home');
        Storage.isTokenSaved.value = false;
        showSnackbar("Success", "Logout", LineIcons.check);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void changePassword() async {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    showGetDialog(
        title: "Change Password",
        content: Column(
          children: [
            WidgetTextField(
                context: Get.context!,
                label: "Current Password",
                controller: currentPasswordController,
                icon: LineIcons.unlock),
            const SizedBox(
              height: 20,
            ),
            WidgetTextField(
                context: Get.context!,
                label: "New Password",
                controller: newPasswordController,
                icon: LineIcons.lock),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        if (currentPasswordController.text.isEmpty ||
                            newPasswordController.text.isEmpty) {
                          showSnackbar("Error", "Fields Empty",
                              LineIcons.exclamationTriangle);
                        } else {
                          changePasswordHandle(
                              currentPass: currentPasswordController.text,
                              newPass: newPasswordController.text);
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  void changePasswordHandle(
      {required String currentPass, required String newPass}) async {
    Get.back();
    var data = {"currentPassword": currentPass, "newPassword": newPass};
    dynamic json = await RemoteServices.changePasswordService(data);
    if (json != null) {
      if (json['message'] == "OK") {
        showSnackbar("Success", "Password Changed", LineIcons.check);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void showDialogEnableAuth(
      {required String imageData, required String secret}) {
    twoStep.clear();
    showGetDialog(
        cancelable: false,
        title: "You must enable 2FA to continue",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text:
                    "1. Scan the QR code or enter the secret manually in your authenticator app. (We recommend",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              TextSpan(
                text: " Google Authenticator ",
                style: TextStyle(color: Colors.amber, fontSize: 12),
              ),
              TextSpan(
                text: "on your smartphone.)",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ])),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "2. Enter the 2FA code you get from the authenticator app then click submit",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            ResponsiveRowColumn(
              columnSpacing: 10,
              rowSpacing: 20,
              layout: ResponsiveWrapper.of(Get.context!).isSmallerThan(DESKTOP)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                  child: Image.network(imageData),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Column(
                    children: [
                      const Text(
                          "To make your account even more secure, we recommend enabling two-factor authentication (2FA)."),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            "Secret",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: GestureDetector(
                              child: Text(
                                secret,
                                style: const TextStyle(fontSize: 15),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: secret))
                                    .then((_) {
                                  showSnackbar("Copied to clipboard", secret,
                                      LineIcons.copy);
                                });
                              },
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      WidgetTextField(
                          context: Get.context!,
                          label: "2FA Code",
                          controller: twoStep,
                          icon: LineIcons.key),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    Get.back();
                    enableTwoAuthHandle();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ));
  }

  void enableTwoAuthHandle() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Map data = {
      "totp": twoStep.text,
      "option": "TWO_FACTOR_ATH",
      "enabled": true,
    };
    dynamic json = await RemoteServices.twoAuthOptionService(data);
    if (json != null) {
      if (json['message'] == "OK") {
        getUserProfile();
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void showDialogDisableAuth() {
    twoStep.clear();
    showGetDialog(
        title: "Disable Two Factor Authentication",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the 2FA code you get from the authenticator app then click submit",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            WidgetTextField(
                context: Get.context!,
                label: "2FA Code",
                controller: twoStep,
                icon: LineIcons.key),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        enableDisableTwoAuth(code: twoStep.text, enable: false);
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  void enableDisableTwoAuth(
      {required String code, required bool enable}) async {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 10,
            ),
          ),
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    Map data = {
      "totp": code,
      "option": "TWO_FACTOR_ATH",
      "enabled": enable,
    };
    dynamic json = await RemoteServices.twoAuthOptionService(data);
    Navigator.of(Get.overlayContext!).pop();
    if (json != null) {
      if (json['message'] == "OK") {
        Get.back();
        reloadProfile();
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void reloadProfile() async {
    await removeValue("user");
    getUserProfile();
  }

  void backButtonHandle() {
    if (Get.previousRoute.isNotEmpty) {
      Get.offAndToNamed(Get.previousRoute);
    } else {
      Get.offAndToNamed('/home');
    }
  }

  showState(String userID, String username) {
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: DialogState(
        userID: userID,
        username: username,
      ),
    ));
  }
}
