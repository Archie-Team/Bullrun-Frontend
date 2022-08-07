import 'package:bet/controller/swap_controller.dart';
import 'package:bet/global/notification.dart';
import 'package:bet/global/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SwapPage extends StatelessWidget {
  SwapPage({Key? key}) : super(key: key);

  final SwapController controller = Get.put(SwapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(() => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: SingleChildScrollView(
                  child: CardModel(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff31463A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 0.5)),
                      width:
                          ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SelectableText(
                                  "Swap",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.reloadData();
                                      },
                                      icon: const Icon(
                                        LineIcons.syncIcon,
                                        size: 20,
                                      ),
                                      splashRadius: 30,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.backButtonHandle();
                                      },
                                      icon: const Icon(
                                        LineIcons.times,
                                        size: 20,
                                      ),
                                      splashRadius: 30,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 0.5,
                            color: Colors.white,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                  Obx(
                                    () => SelectableText(
                                        controller
                                            .userModel.value.user!.balance!.busd
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )
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
                                  Obx(
                                    () => SelectableText(
                                        controller
                                            .userModel.value.user!.balance!.usdc
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )
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
                                  Obx(
                                    () => SelectableText(
                                        controller
                                            .userModel.value.user!.balance!.bux
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          wChange(),
                          wSwapButton(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
      ),
    );
  }

  Widget wChange() {
    return Obx(() => controller.buxToCoin.value ? wBuxToCoin() : wCoinToBux());
  }

  Widget wBuxToCoin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "BUX",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          WidgetTextField(
              context: Get.context!,
              label: "Enter value",
              icon: null,
              textInputType: const TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: controller.buxController),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  controller.buxToCoin.value = !controller.buxToCoin.value;
                },
                icon: const Icon(
                  LineIcons.syncIcon,
                  size: 20,
                ),
                splashRadius: 30,
              )),
          CupertinoSlidingSegmentedControl(
            children: const {
              'BUSD': Text(
                'BUSD',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              'USDC': Text(
                'USDC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            },
            groupValue: controller.isBusd.value ? "BUSD" : "USDC",
            padding: EdgeInsets.zero,
            onValueChanged: (value) {
              value == "BUSD"
                  ? controller.isBusd.value = true
                  : controller.isBusd.value = false;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border:
                      Border.all(width: 0.2, color: const Color(0x66ffffff))),
              child: Text(
                controller.coinValue.value,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget wCoinToBux() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoSlidingSegmentedControl(
            children: const {
              'BUSD': Text(
                'BUSD',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              'USDC': Text(
                'USDC',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            },
            groupValue: controller.isBusd.value ? "BUSD" : "USDC",
            padding: EdgeInsets.zero,
            onValueChanged: (value) {
              value == "BUSD"
                  ? controller.isBusd.value = true
                  : controller.isBusd.value = false;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          WidgetTextField(
              context: Get.context!,
              label: "Enter value",
              icon: null,
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
              ],
              controller: controller.coinController),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  controller.buxToCoin.value = !controller.buxToCoin.value;
                },
                icon: const Icon(
                  LineIcons.syncIcon,
                  size: 20,
                ),
                splashRadius: 30,
              )),
          const Text(
            "BUX",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border:
                      Border.all(width: 0.2, color: const Color(0x66ffffff))),
              child: Text(
                controller.buxValue.value,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget wSwapButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Obx(
          () => controller.loading.value
              ? const CircularProgressIndicator()
              : CustomTextButton(
                  onPressed: () {
                    if (controller.buxController.text.isNotEmpty ||
                        controller.coinController.text.isNotEmpty) {
                      controller.dialogSwap();
                    } else {
                      showSnackbar("Warning", "Enter Value",
                          LineIcons.exclamationTriangle);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: const Center(
                      child: Text(
                        "SWAP",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
        ));
  }
}
