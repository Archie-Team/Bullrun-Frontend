import 'package:bet/controller/login_signup_controller.dart';
import 'package:bet/global/notification.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/colors.dart';
import '../global/widgets.dart';

class LoginSignUpPage extends StatelessWidget {
  LoginSignUpPage({Key? key}) : super(key: key);

  final LoginSignupController controller = Get.put(LoginSignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: wAppbar(),
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() => controller.isLogin.value ? wLogin() : wSignup()),
        ),
      ),
    );
  }

  PreferredSizeWidget wAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: IconButton(
          onPressed: () => controller.backButtonHandle(i: 1),
          icon: const Icon(LineIcons.arrowLeft),
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget wLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SelectableText(
          "Welcome Back!",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: ResponsiveWrapper.of(Get.context!).isSmallerThan("DESKTOP")
              ? double.infinity
              : ResponsiveWrapper.of(Get.context!).screenWidth / 3,
          child: CardModel(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetTextField(
                      context: Get.context!,
                      label: "Username",
                      icon: LineIcons.userAlt,
                      controller: controller.usernameController),
                  const SizedBox(
                    height: 20,
                  ),
                  WidgetTextField(
                      context: Get.context!,
                      label: "Password",
                      icon: LineIcons.eyeSlash,
                      isPassword: true,
                      controller: controller.passwordController),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomTextButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.isLoading.value = true;
                              controller.handleLogIn();
                            },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  if (controller.isLoading.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: showLoading(),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  controller.showDialogForgetPassword();
                },
          child: const Text(
            "Forgot Password",
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  controller.isLogin.value = false;
                  controller.resetTextController();
                },
          child: const Text(
            "Register a new account",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget wSignup() {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SelectableText(
              "Welcome!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: ResponsiveWrapper.of(Get.context!).isSmallerThan("DESKTOP")
                  ? double.infinity
                  : ResponsiveWrapper.of(Get.context!).screenWidth / 3,
              child: CardModel(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetTextField(
                          context: Get.context!,
                          label: "Username",
                          icon: LineIcons.userAlt,
                          controller: controller.usernameController),
                      const SizedBox(
                        height: 20,
                      ),
                      WidgetTextField(
                          context: Get.context!,
                          label: "Email",
                          icon: LineIcons.at,
                          textInputType: TextInputType.emailAddress,
                          controller: controller.emailController),
                      const SizedBox(
                        height: 20,
                      ),
                      WidgetTextField(
                          context: Get.context!,
                          label: "Password",
                          icon: LineIcons.eyeSlash,
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                value.length < 8) {
                              return "Password must be at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r"\s\b|\b\s")),
                          ],
                          controller: controller.passwordController),
                      const SizedBox(
                        height: 20,
                      ),
                      const SelectableText(
                        "Store your password in a safe place.",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                          text: "You agree with the",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        TextSpan(
                          text: " term of service ",
                          style: const TextStyle(
                              color: linkTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Get.toNamed("/term");
                            },
                        ),
                        const TextSpan(
                          text: "with signup",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: CustomTextButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.repeatPassword();
                                },
                          child: const Text(
                            "Signup",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      if (controller.isLoading.value)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: showLoading(),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      controller.isLogin.value = true;
                      controller.resetTextController();
                    },
              child: const Text(
                "Have an account? Login",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ));
  }

  // Widget wPasswordGenerator() {
  //   return Obx(() => IntrinsicHeight(
  //         child: Row(
  //           children: [
  //             const Icon(
  //               LineIcons.eyeSlash,
  //               size: 20,
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Expanded(
  //               child: Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(2),
  //                     border: Border.all(
  //                         width: 0.2, color: const Color(0x66ffffff))),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     const SelectableText(
  //                       "Password",
  //                       style: TextStyle(fontSize: 15),
  //                     ),
  //                     const SizedBox(
  //                       width: 10,
  //                     ),
  //                     SelectableText(
  //                       controller.generatePassword.value,
  //                       style: const TextStyle(
  //                           fontSize: 15, fontWeight: FontWeight.bold),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             GestureDetector(
  //               onTap: () {
  //                 Clipboard.setData(ClipboardData(
  //                         text: controller.generatePassword.value))
  //                     .then((_) {
  //                   showSnackbar("Copied to clipboard",
  //                       controller.generatePassword.value, LineIcons.copy);
  //                 });
  //               },
  //               child: const Icon(
  //                 LineIcons.copy,
  //                 size: 20,
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             GestureDetector(
  //               onTap: controller.generatePasswordString,
  //               child: const Icon(
  //                 LineIcons.syncIcon,
  //                 size: 20,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }
}
