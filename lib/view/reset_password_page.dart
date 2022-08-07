import 'package:bet/controller/reset_password_controller.dart';
import 'package:bet/global/notification.dart';
import 'package:bet/global/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nil/nil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  final ResetPasswordController controller = Get.put(ResetPasswordController());

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
          child: wReset(),
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
          onPressed: () => controller.backButtonHandle(),
          icon: const Icon(LineIcons.arrowLeft),
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget wReset() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SelectableText(
          "Reset Password",
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            width: 0.2, color: const Color(0x66ffffff))),
                    child: Text(
                      controller.params['email'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  WidgetTextField(
                      context: Get.context!,
                      label: "New Password",
                      icon: LineIcons.eyeSlash,
                      isPassword: true,
                      controller: controller.passwordController),
                  const SizedBox(
                    height: 20,
                  ),
                  WidgetTextField(
                      context: Get.context!,
                      label: "Repeat Password",
                      icon: LineIcons.eyeSlash,
                      isPassword: true,
                      controller: controller.repeatPasswordController),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: CustomTextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.isLoading.value = true;
                                controller.handleResetPassword();
                              },
                        child: const Text(
                          "Reset",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Obx(() => controller.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: showLoading(),
                        )
                      : nil)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
