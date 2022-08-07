import 'package:bet/model/leader_board_model.dart';
import 'package:bet/view/dialog/dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../global/notification.dart';
import '../services/remote_services.dart';

class DialogLeaderBoardController extends GetxController {
  var leaderBoardItems = List<LeaderBoardModel>.empty().obs;
  Rx<FilterBy> filterBy = FilterBy.wagered.obs;
  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getLeaderBoard();
    filterBy.listen((p0) {
      getLeaderBoard(sort: p0.name);
    });
  }

  void getLeaderBoard({String sort = "wagered"}) async {
    loading.value = true;
    leaderBoardItems.clear();
    dynamic json = await RemoteServices.leaderboardService(
        sort: sort, order: "-1", date: "all_time");
    loading.value = false;
    if (json != null) {
      if (json['message'] == "OK") {
        leaderBoardItems.clear();
        json['data']['leaderbord'].forEach((item) {
          leaderBoardItems.add(LeaderBoardModel.fromJson(item));
        });
      } else {
        showSnackbar("Error", json['message'], LineIcons.exclamationTriangle);
      }
    }
  }

  showState(String userID, String username) {
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: DialogState(
        userID: userID,
        username: username,
      ),
    ));
  }
}

enum FilterBy { wagered, profit, ath, atl, totalBets }
