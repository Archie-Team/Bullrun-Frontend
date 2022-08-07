import 'package:bet/model/transactions_model.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../global/notification.dart';
import '../services/remote_services.dart';

class DialogTransactionsController extends GetxController {
  var transactionsItems = List<TransactionsModel>.empty().obs;
  RxBool loading = true.obs;
  RxBool isDeposit = true.obs;

  @override
  void onInit() {
    super.onInit();
    getLeaderBoard();
    isDeposit.listen((p0) {
      getLeaderBoard();
    });
  }

  void getLeaderBoard() async {
    loading.value = true;
    transactionsItems.clear();
    dynamic json = await RemoteServices.transactionsHistoryService(
        type: isDeposit.value ? "DEPOSIT" : "WITHDRAWAL",
        status: "ALL",
        order: 1,
        page: 1,
        limit: 50);
    loading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        json['data']['transactions'].forEach((item) {
          transactionsItems.add(TransactionsModel.fromJson(item));
        });
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }
}
