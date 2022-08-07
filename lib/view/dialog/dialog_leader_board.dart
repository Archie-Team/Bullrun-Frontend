import 'package:bet/controller/dialog_leader_board_controller.dart';
import 'package:bet/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class DialogLeaderBoard extends StatelessWidget {
  DialogLeaderBoard({Key? key}) : super(key: key);

  final DialogLeaderBoardController controller =
      Get.put(DialogLeaderBoardController());

  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SelectableText(
                  "Leaderboard",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    LineIcons.times,
                    size: 20,
                  ),
                  splashRadius: 30,
                )
              ],
            ),
            Obx(() => controller.loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.leaderBoardItems.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.leaderBoardItems.isEmpty
                            ? 1
                            : controller.leaderBoardItems.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Obx(() => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      onTap: null,
                                      leading: null,
                                      title: Row(children: <Widget>[
                                        const Expanded(
                                          child: Text(
                                            "Player",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Text("Wagered",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: controller.filterBy
                                                                .value.name
                                                                .toLowerCase() ==
                                                            "wagered"
                                                        ? Colors.yellow
                                                        : Colors.white)),
                                            onTap: () {
                                              controller.filterBy.value =
                                                  FilterBy.wagered;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Text("Profit",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: controller.filterBy
                                                                .value.name
                                                                .toLowerCase() ==
                                                            "profit"
                                                        ? Colors.yellow
                                                        : Colors.white)),
                                            onTap: () {
                                              controller.filterBy.value =
                                                  FilterBy.profit;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Text("ATH",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: controller.filterBy
                                                                .value.name
                                                                .toLowerCase() ==
                                                            "ath"
                                                        ? Colors.yellow
                                                        : Colors.white)),
                                            onTap: () {
                                              controller.filterBy.value =
                                                  FilterBy.ath;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Text("ATL",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: controller.filterBy
                                                                .value.name
                                                                .toLowerCase() ==
                                                            "atl"
                                                        ? Colors.yellow
                                                        : Colors.white)),
                                            onTap: () {
                                              controller.filterBy.value =
                                                  FilterBy.atl;
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            child: Text("Bets",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: controller.filterBy
                                                                .value.name
                                                                .toLowerCase() ==
                                                            "totalbets"
                                                        ? Colors.yellow
                                                        : Colors.white)),
                                            onTap: () {
                                              controller.filterBy.value =
                                                  FilterBy.totalBets;
                                            },
                                          ),
                                        ),
                                      ]),
                                    )),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  height: 1,
                                )
                              ],
                            );
                          }
                          index -= 1;
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            onTap: null,
                            leading: null,
                            title: Row(children: <Widget>[
                              Expanded(
                                child: TextButton(
                                  onPressed: () => controller.showState(
                                      controller.leaderBoardItems[index].userId,
                                      controller
                                          .leaderBoardItems[index].username),
                                  style: ButtonStyle(
                                      alignment: Alignment.centerLeft,
                                      minimumSize:
                                          MaterialStateProperty.all(Size.zero),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero)),
                                  child: Text(
                                    controller.leaderBoardItems[index].username,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                      controller.leaderBoardItems[index].wagered
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: Text(
                                      controller.leaderBoardItems[index].profit.toStringAsFixed(2).replaceAll(regex, '')
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: Text(
                                      controller.leaderBoardItems[index].ath.toStringAsFixed(2).replaceAll(regex, '')
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: Text(
                                      controller.leaderBoardItems[index].atl.toStringAsFixed(2).replaceAll(regex, '')
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: Text(
                                      controller
                                          .leaderBoardItems[index].totalBets
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                            ]),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No one has played yet!',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
