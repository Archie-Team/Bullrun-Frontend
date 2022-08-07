import 'package:bet/model/state_model.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../global/notification.dart';
import '../services/remote_services.dart';

class DialogStateController extends GetxController {
  Rx<StateModel> stateModel = StateModel().obs;
  RxBool loading = true.obs;

  void getState(String userID) async {
    loading.value = true;
    dynamic json = await RemoteServices.getUserStateService(userID);
    loading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        stateModel.value = StateModel.fromJson(json['data']['stats']);
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }
}
