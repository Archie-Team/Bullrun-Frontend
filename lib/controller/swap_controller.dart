import 'dart:async';

import 'package:bet/global/notification.dart';
import 'package:bet/global/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/user_model.dart';
import '../services/remote_services.dart';

class SwapController extends GetxController {
  RxBool buxToCoin = false.obs;
  TextEditingController coinController = TextEditingController();
  TextEditingController buxController = TextEditingController();
  RxString buxValue = "".obs;
  RxString coinValue = "".obs;
  RxBool loading = false.obs;
  Rx<UserModel> userModel = UserModel().obs;
  TextEditingController twoStep = TextEditingController();
  final Function()? callback = Get.arguments;
  Timer? timer;
  int pendingsItem = 0;
  RxBool isBusd = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await loadProfile().then((value) {
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
    buxToCoin.listen((p0) {
      buxController.clear();
      coinController.clear();
    });
    buxController.addListener(() {
      buxController.text.isNotEmpty
          ? coinValue.value = (int.parse(buxController.text) / 10).toString()
          : coinValue.value = "0";
    });
    coinController.addListener(() {
      coinController.text.isNotEmpty
          ? buxValue.value = (int.parse(coinController.text) * 10).toString()
          : buxValue.value = "0";
    });
    startTimerReloadData();
  }

  void startTimerReloadData() {
    const oneSec = Duration(seconds: 7);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        handleCheckData(timer);
      },
    );
  }

  void handleCheckData(Timer timer) async {
    // transactionsItems.clear();
    int temp = 0;
    dynamic json = await RemoteServices.transactionsHistoryService(
        type: "DEPOSIT", status: "ALL", order: 1, page: 1, limit: 50);
    if (json['data'] == null) {
      timer.cancel();
      return;
    } else {
      if (json['message'] == "OK") {
        json['data']['transactions'].forEach((item) {
          if (item['status'] == "PENDING") temp++;
        });
        if (temp < pendingsItem) {
          showSnackbar(
              "Success", "One of your transactions completed", LineIcons.check);
          timer.cancel();
          reloadData();
        }
        pendingsItem = temp;
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  Future<UserModel?> loadProfile() async {
    loading.value = true;
    dynamic json = await RemoteServices.getUserInfoService();
    if (json != null) {
      if (json['message'] == "OK") {
        loading.value = false;
        return UserModel.fromJson(json['data']);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
        return null;
      }
    }
    return null;
  }

  void dialogSwap() {
    loading.value = true;
    handleFee();
  }

  void handleSwap() async {
    loading.value = true;
    var data = {
      "type": buxToCoin.value
          ? isBusd.value
              ? "bux_to_busd"
              : "bux_to_usdc"
          : isBusd.value
              ? "busd_to_bux"
              : "usdc_to_bux",
      "amount": buxToCoin.value
          ? int.parse(buxController.text)
          : double.parse(coinController.text)
    };
    dynamic json = await RemoteServices.swapService(data);
    loading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        buxController.clear();
        coinController.clear();
        userModel.value = (await loadProfile())!;
        if (callback != null) {
          callback!();
        }
        showSnackbar("Success", "Converted Successfully", LineIcons.check);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void handleFee() async {
    var data = {
      "type": buxToCoin.value ? "bux_to_busd" : "busd_to_bux",
      "amount": buxToCoin.value
          ? int.parse(buxController.text)
          : double.parse(coinController.text)
    };
    dynamic json = await RemoteServices.getFeeService(data);
    loading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        var finalValue = json['data']['result']['final'].toString();
        Get.defaultDialog(
            barrierDismissible: false,
            titlePadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            title: "Confirm Swap",
            titleStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            content: Flexible(
              child: Text(
                "You get $finalValue ${buxToCoin.value ? isBusd.value ? "BUSD" : "USDC" : "BUX"} from this swap",
                style: const TextStyle(fontSize: 18),
              ),
            ),
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
                handleSwap();
              },
              child: const Text(
                "Confirm",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ));
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void reloadData() async {
    userModel.value = (await loadProfile())!;
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
    loading.value = true;
    FocusManager.instance.primaryFocus?.unfocus();
    Map data = {
      "totp": twoStep.text,
      "option": "TWO_FACTOR_ATH",
      "enabled": true,
    };
    dynamic json = await RemoteServices.twoAuthOptionService(data);
    if (json != null) {
      loading.value = false;
      if (json['message'] == "OK") {
        await loadProfile().then((value) {
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
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void backButtonHandle() {
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      Get.offAndToNamed('/home');
    }
  }
}
