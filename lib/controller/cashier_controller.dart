import 'dart:async';

import 'package:bet/global/widgets.dart';
import 'package:bet/view/dialog/dialog_transactions_history.dart';
import 'package:bet/wallet/metamask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nil/nil.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../config/config.dart';
import '../config/enum.dart';
import '../global/notification.dart';
import '../model/user_model.dart';
import '../services/remote_services.dart';

class CashierController extends GetxController {
  late MetaMask metaMask;
  RxInt money = 0.obs;
  RxBool loading = false.obs;
  RxBool sendToServer = false.obs;
  Rx<UserModel> userModel = UserModel().obs;
  TextEditingController twoStep = TextEditingController();
  Timer? timer;
  int pendingsItem = 0;

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
    metaMask = MetaMask(userModel.value.user?.publicAddress);
    startTimerReloadData();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  bool checkAddress() {
    if (userModel.value.user!.publicAddress == metaMask.currentAddress.value) {
      return true;
    } else {
      return false;
    }
  }

  void updateAddress(String address) {
    userModel.value.user!.publicAddress = address;
    metaMask.profilePublicAddress = address;
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

  void showTransactionsHistoryDialog() {
    Get.dialog(const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: DialogTransactionsHistory(),
    ));
  }

  void handleButtonConnect() {
    metaMask.connect();
  }

  Future<void> approve(Token tokenName) async {
    if (!checkAddress()) {
      showSnackbar(
          "Error", "You select wrong wallet", LineIcons.exclamationTriangle);
      return;
    }
    if (metaMask.currentAddress.value.isEmpty) {
      showSnackbar("Warning", "Please connect to wallet first",
          LineIcons.exclamationTriangle);
      return;
    }
    String tokenAddress =
        tokenName == Token.busd ? AddressConfig.busd : AddressConfig.usdc;
    String contractAddress = tokenName == Token.busd
        ? AddressConfig.contractBusd
        : AddressConfig.contractUsdc;
    final contract = ContractERC20(tokenAddress, provider!.getSigner());
    TransactionResponse response = await contract.approve(
        contractAddress, BigInt.parse("50000000000000000000000000000000000"));
    // final receipt =
    await response.wait();
    // print("1 " + response.toString());
    // print("2 " + response.data);
    // print("3 " + receipt.status.toString());
  }

  void deposit(Token tokenName) {
    if (!checkAddress()) {
      showSnackbar(
          "Error", "You select wrong wallet", LineIcons.exclamationTriangle);
      return;
    }
    if (metaMask.currentAddress.value.isEmpty) {
      showSnackbar("Warning", "Please connect to wallet first",
          LineIcons.exclamationTriangle);
      return;
    }
    TextEditingController txtController = TextEditingController();
    Get.defaultDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        title: "Confirm Deposit",
        titleStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        content: Flexible(
            child: WidgetTextField(
                context: Get.context!,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                label: "How much?",
                icon: null,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.parse(value) < 2) {
                      return "Minimum value = 2 ${tokenName == Token.busd ? 'BUSD' : 'USDC'}";
                    }
                  } else {
                    return null;
                  }
                  return null;
                },
                svgPath: tokenName == Token.busd
                    ? 'assets/images/busd.png'
                    : 'assets/images/usdc.png',
                helperText:
                    "Fee: 1 ${tokenName == Token.busd ? 'BUSD' : 'USDC'}",
                controller: txtController)),
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
            handleDeposit(txtController.text, tokenName);
          },
          child: const Text(
            "Confirm",
            style: TextStyle(
                fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ));
  }

  void withdraw(Token tokenName) {
    if (!checkAddress()) {
      showSnackbar(
          "Error", "You select wrong wallet", LineIcons.exclamationTriangle);
      return;
    }
    if (metaMask.currentAddress.value.isEmpty) {
      showSnackbar("Warning", "Please connect to wallet first",
          LineIcons.exclamationTriangle);
      return;
    }
    TextEditingController txtController = TextEditingController();
    TextEditingController totpController = TextEditingController();
    Get.defaultDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        title: "Confirm Withdraw",
        titleStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        content: Flexible(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WidgetTextField(
                context: Get.context!,
                textInputType: TextInputType.number,
                label: "How much?",
                icon: LineIcons.paperPlane,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.parse(value) < 2) {
                      return "Minimum value = 2 ${tokenName == Token.busd ? 'BUSD' : 'USDC'}";
                    }
                  } else {
                    return null;
                  }
                  return null;
                },
                helperText:
                    "Fee: 1 ${tokenName == Token.busd ? 'BUSD' : 'USDC'}",
                controller: txtController),
            const SizedBox(
              height: 5,
            ),
            WidgetTextField(
                context: Get.context!,
                textInputType: TextInputType.number,
                label: "Your totp code",
                icon: LineIcons.key,
                controller: totpController),
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
            handleWithdraw(txtController.text, totpController.text, tokenName);
          },
          child: const Text(
            "Confirm",
            style: TextStyle(
                fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ));
  }

  void handleDeposit(String amount, Token tokenName) async {
    loading.value = false;
    var data = {
      "type": "DEPOSIT",
      "currency": tokenName == Token.busd ? "BUSD" : "USDC",
      "amount": double.parse(amount),
      "operation": "INC"
    };
    dynamic json = await RemoteServices.depositService(data);
    if (json != null) {
      if (json['message'] == "OK") {
        var transactionId = json['data']['transaction']['id'];
        sendDepositToBlockChain(transactionId, double.parse(amount), tokenName);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void handleWithdraw(String amount, String totp, Token tokenName) async {
    loading.value = false;
    var data = {
      "type": "WITHDRAWAL",
      "amount": double.parse(amount),
      "currency": tokenName == Token.busd ? "BUSD" : "USDC",
      "operation": "DEC",
      "totp": totp
    };
    dynamic json = await RemoteServices.depositService(data);
    if (json != null) {
      if (json['message'] == "OK") {
        // var transactionId = json['data']['transaction']['id'];
        reloadData();
        // sendWithdrawToBlockChain(transactionId, int.parse(amount));
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  void sendDepositToBlockChain (String transactionId, double amount, Token tokenName) async {
    List<String> abi = [
      'function deposit(string,uint256)',
    ];
    String contractAddress = tokenName == Token.busd
        ? AddressConfig.contractBusd
        : AddressConfig.contractUsdc;
    Contract contract = Contract(contractAddress, abi, provider!.getSigner());
    await contract
        .call<String>('deposit', [transactionId, amount]).then((value) async {
      if (!timer!.isActive) {
        startTimerReloadData();
      }
      // await loadProfile().then((value) {
      //   userModel.value = value!;
      // });
    });
  }

  void showDialogChooseCoin(Tasks tasks) async {
    Get.defaultDialog(
      title: "Choose BUSD or USDC",
      content: Column(
        children: [
          tasks == Tasks.withdraw
              ? const Text(
                  "Withdrawals are settled within 12h of initiation\nand were put in place for on-chain security measures.",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                )
              : nil,
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Get.back();
                if (metaMask.currentChain.value == 56) {
                  doTask(tasks, Token.busd);
                } else {
                  showSnackbar("Error", "Select BSC network",
                      LineIcons.exclamationTriangle);
                }
              },
              child: const Text(
                "BUSD",
                style: TextStyle(fontSize: 12),
              )),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Get.back();
                if (metaMask.currentChain.value == 1) {
                  doTask(tasks, Token.usdc);
                } else {
                  showSnackbar("Error", "Select ETH network",
                      LineIcons.exclamationTriangle);
                }
              },
              child: const Text(
                "USDC",
                style: TextStyle(fontSize: 12),
              )),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () => {Get.back()},
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 12, color: Colors.redAccent),
              )),
        ],
      ),
    );
  }

  void doTask(Tasks tasks, Token tokenName) {
    switch (tasks) {
      case Tasks.approve:
        approve(tokenName);
        break;
      case Tasks.deposit:
        deposit(tokenName);
        break;
      case Tasks.withdraw:
        withdraw(tokenName);
        break;
    }
  }

  void reloadData() async {
    userModel.value = (await loadProfile())!;
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
