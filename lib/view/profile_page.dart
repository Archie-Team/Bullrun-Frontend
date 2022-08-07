import 'package:bet/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/widgets.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Obx(() => controller.loading.value
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CardModel(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff31463A),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.white, width: 0.5)),
                        width: ResponsiveWrapper.of(context)
                                .isSmallerThan("DESKTOP")
                            ? double.infinity
                            : ResponsiveWrapper.of(context).screenWidth / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SelectableText(
                                    "Profile",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (Get.previousRoute.isNotEmpty) {
                                        Get.back();
                                      } else {
                                        Get.offAllNamed("/home");
                                      }
                                    },
                                    icon: const Icon(
                                      LineIcons.times,
                                      size: 20,
                                    ),
                                    splashRadius: 30,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.white,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //Balance BUSD
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SelectableText(
                                      "Balance (BUSD)",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                        "${controller.userModel.value.user!.balance!.busd} BUSD",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            //Balance USDC
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SelectableText(
                                      "Balance (USDC)",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                        "${controller.userModel.value.user!.balance!.usdc} USDC",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            //Balance BUX
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SelectableText(
                                      "Balance (BUX)",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                        "${controller.userModel.value.user!.balance!.bux} BUX",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            //Username
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SelectableText(
                                      "Username",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                        controller
                                            .userModel.value.user!.username
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            //Email
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SelectableText(
                                      "Email",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SelectableText(
                                        controller.userModel.value.user!.email!
                                            .current
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: IntrinsicWidth(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextButton(
                                          onPressed: () {
                                            controller.changePassword();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: const Center(
                                              child: Text(
                                                "Change Password",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextButton(
                                          onPressed: () {
                                            controller.showState(
                                                controller
                                                    .userModel.value.user!.id!,
                                                controller.userModel.value.user!
                                                    .username!);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: const Center(
                                              child: Text(
                                                "Stats",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextButton(
                                          onPressed: () {
                                            controller.logout();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: const Center(
                                              child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
        ),
      ),
    );
  }
}
