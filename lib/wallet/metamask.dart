import 'package:bet/config/config.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../controller/cashier_controller.dart';
import '../global/notification.dart';
import '../services/remote_services.dart';

class MetaMask {
  RxString currentAddress = ''.obs;
  List<int> operatingChain = AddressConfig.chainID;
  RxInt currentChain = 0.obs;

  bool get isEnabled => ethereum != null;

  RxBool get isInOperatingChain => (operatingChain.contains(currentChain.value)).obs;

  RxBool get isConnected => (isEnabled && currentAddress.isNotEmpty).obs;

  String? profilePublicAddress;

  final CashierController _cashierController = Get.find<CashierController>();

  MetaMask(String? publicAddress) {
    profilePublicAddress = publicAddress;
    init();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        if (isInOperatingChain.value) {
          currentAddress.value = EthUtils.getAddress(accounts.first);
          handleUpdateAddress(EthUtils.getAddress(accounts.first));
        }
      });
      ethereum!.onChainChanged((accounts) {
        currentChain.value = accounts;
      });
      isInOperatingChain.listen((p0) {
        // print("isIn " + p0.toString());
      });
    }
  }

  void connect() async {
    // print("connecting");
    if (isEnabled) {
      try {
        await ethereum!.requestAccount().then((value) async {
          if (value.isNotEmpty) {
            currentAddress.value = EthUtils.getAddress(value.first);
          }
          currentChain.value = await ethereum!.getChainId();
          if (isInOperatingChain.value) {
            handleUpdateAddress(EthUtils.getAddress(currentAddress.value));
          }
        });
      } on EthereumUserRejected {
        // print('User rejected the modal');
      } catch (e) {
        // print(e.toString());
      }
    } else {
      // print("disable");
    }
  }

  clear() {
    currentAddress.value = '';
    currentChain.value = -1;
    // notifyListeners();
  }

  void handleUpdateAddress(String address) async {
    if (profilePublicAddress == address) return;
    var data = {"value": address};
    dynamic json = await RemoteServices.updateAddressService(data);
    if (json != null) {
      if (json['message'] == "OK") {
        showSnackbar("Success", "Your Address Changed", LineIcons.check);
        _cashierController.updateAddress(address);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }
}
