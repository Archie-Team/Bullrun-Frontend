import 'package:bet/global/notification.dart';
import 'package:bet/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/colors.dart';
import '../global/storage.dart';
import '../global/widgets.dart';

class LoginSignupController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController twoStep = TextEditingController();
  TextEditingController passwordAgain = TextEditingController();
  RxBool isLogin = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    twoStep.dispose();
    isLogin.close();
    isLoading.close();
  }

  void repeatPassword() {
    if (!emailController.text.isEmail) {
      showSnackbar(
          "Error", "Email not validated", LineIcons.exclamationTriangle);
      isLoading.value = false;
      return;
    }
    showGetDialog(
        title: "Repeat Password",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "To make sure you memorized your password, please enter your password again",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 10,
            ),
            WidgetTextField(
                context: Get.overlayContext!,
                label: "Password again",
                controller: passwordAgain,
                icon: LineIcons.eyeSlash),
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
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(dismissColor)),
                    child: const Text(
                      "See Again",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (passwordAgain.text == passwordController.text) {
                        Navigator.of(Get.overlayContext!).pop();
                        isLoading.value = true;
                        handleSignUp();
                      } else {
                        showSnackbar("Error", "Your password not mach",
                            LineIcons.exclamationTriangle);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(buttonColor)),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  handleSignUp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Map data = {
      "username": usernameController.text,
      "password": passwordController.text,
      "email": emailController.text
    };
    dynamic json = await RemoteServices.signUpService(data);
    isLoading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        await saveValue("token", json['data']['auth']['token']).then((value) {
          Storage.isTokenSaved.value = true;
          showDialogAuth(
            imageData: json['data']['user']['security']
                ['twoFactorAuthentication']['otpAuthQR'],
            secret: json['data']['user']['security']['twoFactorAuthentication']
                ['secret'],
          );
        });
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  handleLogIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar("Error", "Enter Value", LineIcons.exclamationTriangle);
      isLoading.value = false;
      return;
    }
    var data = {
      "username": usernameController.text,
      "password": passwordController.text,
    };
    dynamic json = await RemoteServices.logInService(data);
    isLoading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        try {
          if (json['data']['auth']['state'] == "AUTHENTICATED") {
            await saveValue("token", json['data']['auth']['token'])
                .then((value) {
              Storage.isTokenSaved.value = true;
              backButtonHandle();
              showSnackbar("Success!", "Welcome ${usernameController.text}",
                  LineIcons.check);
            });
          } else {
            showDialogAuthForLogin(token: json['data']['auth']['token']);
          }
        } catch (e) {
          // print(e.toString());
        }
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void showDialogAuthForLogin({required String token}) {
    twoStep.clear();
    showGetDialog(
        title: "Two Factor Authentication",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the 2FA code you get from the authenticator app for login, then click submit",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            WidgetTextField(
                context: Get.context!,
                label: "2FA Code",
                maxLenght: 6,
                textInputType: TextInputType.number,
                controller: twoStep,
                icon: LineIcons.key),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {
                    Get.back();
                    handleTwoAuthForLogin(token);
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ));
  }

  void resetTextController() {
    usernameController.clear();
    passwordController.clear();
    emailController.clear();
  }

  void handleTwoAuthForLogin(String token) async {
    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (twoStep.text.isEmpty) {
      showSnackbar("Error", "Enter Value", LineIcons.exclamationTriangle);
      return;
    }
    var data = {
      "totp": twoStep.text,
    };
    dynamic json = await RemoteServices.twoAuthForLogin(data, token);
    isLoading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        isLoading.value = true;
        try {
          if (json['data']['auth']['state'] == "AUTHENTICATED") {
            saveValue("token", json['data']['auth']['token']).then((value) {
              Storage.isTokenSaved.value = true;
              showSnackbar("Success!", "Welcome ${usernameController.text}",
                  LineIcons.check);
              backButtonHandle();
            });
          } else {
            showDialogAuthForLogin(token: json['data']['auth']['token']);
          }
        } catch (e) {
          // print(e.toString());
        }
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void showDialogAuth({required String imageData, required String secret}) {
    twoStep.clear();
    showGetDialog(
        cancelable: false,
        title: "Success SignUp!",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You must enable 2FA to continue",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
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
                    enableTwoAuthHandle(imageData: imageData, secret: secret);
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ));
  }

  void enableTwoAuthHandle(
      {required String imageData, required String secret}) async {
    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    Map data = {
      "totp": twoStep.text,
      "option": "TWO_FACTOR_ATH",
      "enabled": true,
    };
    dynamic json = await RemoteServices.twoAuthOptionService(data);
    if (json != null) {
      isLoading.value = false;
      if (json['message'] == "OK") {
        backButtonHandle();
      } else {
        showDialogAuth(imageData: imageData, secret: secret);
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void showDialogForgetPassword() {
    TextEditingController emailController = TextEditingController();
    Get.defaultDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        title: "Submit Your Email Address",
        titleStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        content: Flexible(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetTextField(
                context: Get.context!,
                textInputType: TextInputType.emailAddress,
                label: "Email",
                icon: LineIcons.at,
                controller: emailController),
            const SizedBox(
              height: 5,
            ),
          ],
        )),
        cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
                fontSize: 15,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold),
          ),
        ),
        confirm: TextButton(
          onPressed: () {
            Get.back();
            handleSendForgetPassword(email: emailController.text);
          },
          child: const Text(
            "Confirm",
            style: TextStyle(
                fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ));
  }

  void handleSendForgetPassword({required String email}) async {
    if (email.isEmpty) {
      return;
    }
    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    var data = {
      "email": email,
    };
    dynamic json = await RemoteServices.sendForgetPasswordService(data);
    isLoading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        isLoading.value = false;
        showSnackbar("Success", "Reset Password Link Sent To Your Email",
            LineIcons.check);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void backButtonHandle({int i = 0}) {
    if (i == 1) {
      if (Get.previousRoute.isNotEmpty) {
        Get.offAndToNamed(Get.previousRoute);
      } else {
        Get.back();
      }
    } else {
      Get.offAllNamed("/home");
    }
  }
}
