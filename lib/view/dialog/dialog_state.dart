import 'package:bet/controller/dialog_state_controller.dart';
import 'package:bet/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class DialogState extends StatelessWidget {
  final String userID;
  final String username;

  DialogState({Key? key, required this.userID, required this.username})
      : super(key: key);

  final DialogStateController controller = Get.put(DialogStateController());

  @override
  Widget build(BuildContext context) {
    controller.getState(userID);
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  "Stats of $username",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
            const SizedBox(
              height: 20,
            ),
            Obx(() => controller.loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SelectableText(
                            "Game Played",
                            style: TextStyle(fontSize: 15),
                          ),
                          SelectableText(
                            controller.stateModel.value.totalBets.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SelectableText(
                            "Total Wagered",
                            style: TextStyle(fontSize: 15),
                          ),
                          SelectableText(
                            controller.stateModel.value.wagered.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SelectableText(
                            "Net Profit",
                            style: TextStyle(fontSize: 15),
                          ),
                          SelectableText(
                            controller.stateModel.value.profit.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SelectableText(
                            "Profit All time High",
                            style: TextStyle(fontSize: 15),
                          ),
                          SelectableText(
                            controller.stateModel.value.ath.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SelectableText(
                            "Profit All time Low",
                            style: TextStyle(fontSize: 15),
                          ),
                          SelectableText(
                            controller.stateModel.value.atl.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
