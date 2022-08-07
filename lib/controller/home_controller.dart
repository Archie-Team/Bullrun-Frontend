import 'package:bet/model/data_model.dart';
import 'package:bet/model/leader_board_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../global/notification.dart';
import '../global/storage.dart';
import '../services/remote_services.dart';
import '../view/dialog/dialog_state.dart';

class HomeController extends GetxController {
  final ScrollController scrollC = ScrollController();
  RxBool hover = false.obs;
  var leaderBoardItems = List<LeaderBoardModel>.empty().obs;

  List<DataModel> listDes = [
    DataModel(
        title: "What's BullRun?",
        des:
            "BullRun is an online multiplayer decentralised gambling game consisting of an increasing curve that can crash anytime. It's fun and thrilling. It can also make you millions.",
        image: "assets/images/whats.svg"),
    DataModel(
        title: "How does it work?",
        des:
            "Swap your busd for our gaming token BUX. Place a bet. Watch the multiplier increase from x1 upwards! Cash out any time to get your bet multiplied by that multiplier. But be careful because the game can NUKE at any time, and you'll get REKT!",
        image: "assets/images/how_does.svg"),
    DataModel(
        title: "Social & Real Time",
        des:
            "Be part of our unique community. Watch your fortune rise and play with friends in real time.",
        image: "assets/images/real_time.svg"),
    DataModel(
        title: "Provably Fair",
        des:
            "BullRun's outcome can be proven as fair. There are third party scripts you can use to verify the game hashes and calculate the results.",
        image: "assets/images/fair.png"),
  ];

  @override
  void onInit() async {
    super.onInit();
    getLeaderBoard();
  }

  void getLeaderBoard() async {
    dynamic json = await RemoteServices.leaderboardService(
        sort: "wagered", order: "-1", date: "all_time");
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

  handleButton() async {
    Storage.isTokenSaved.value
        ? Get.toNamed("/profile")
        : Get.toNamed("/login-signup");
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
