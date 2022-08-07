import 'package:bet/config/enum.dart';
import 'package:bet/controller/cashier_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/widgets.dart';

class CashierPage extends StatelessWidget {
  CashierPage({Key? key}) : super(key: key);

  final CashierController controller = Get.put(CashierController());

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
                        mainAxisSize: MainAxisSize.min,
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
                                  "Cashier",
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
                          //Your wallet
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SelectableText(
                                        "Your wallet",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SvgPicture.asset(
                                        "assets/images/metamask.svg",
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                  Flexible(
                                    child: Obx(
                                      () => SelectableText(
                                        controller.metaMask.isConnected.value &&
                                                controller.metaMask
                                                    .isInOperatingChain.value
                                            ? controller
                                                .metaMask.currentAddress.value
                                            : controller.metaMask.isConnected
                                                        .value &&
                                                    !controller
                                                        .metaMask
                                                        .isInOperatingChain
                                                        .value
                                                ? "Wrong chain. Please connect to ${controller.metaMask.operatingChain}"
                                                : controller.metaMask.isEnabled
                                                    ? "Connect first"
                                                    : "Please Install MetaMask wallet",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
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
                                children: [
                                  //connect wallet
                                  CustomTextButton(
                                      onPressed: () {
                                        controller.handleButtonConnect();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Center(
                                          child: Text(
                                            "Connect Wallet",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //Approve
                                  CustomTextButton(
                                      onPressed: () {
                                        controller
                                            .showDialogChooseCoin(Tasks.approve);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Center(
                                          child: Text(
                                            "Approve",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //Deposit
                                  CustomTextButton(
                                      onPressed: () async {
                                        // controller.deposit();
                                        controller
                                            .showDialogChooseCoin(Tasks.deposit);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Center(
                                          child: Text(
                                            "Deposit",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //withdraw
                                  CustomTextButton(
                                      onPressed: () {
                                        // controller.withdraw();
                                        controller
                                            .showDialogChooseCoin(Tasks.withdraw);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Center(
                                          child: Text(
                                            "Withdraw",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //deposits
                                  CustomTextButton(
                                      onPressed: () {
                                        controller
                                            .showTransactionsHistoryDialog();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: const Center(
                                          child: Text(
                                            "Transactions history",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
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
}
