import 'package:bet/controller/transactions_history_controller.dart';
import 'package:bet/global/colors.dart';
import 'package:bet/global/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class DialogTransactionsHistory extends StatefulWidget {
  const DialogTransactionsHistory({Key? key}) : super(key: key);

  @override
  State<DialogTransactionsHistory> createState() =>
      _DialogTransactionsHistoryState();
}

class _DialogTransactionsHistoryState extends State<DialogTransactionsHistory> {
  final DialogTransactionsController controller =
      Get.put(DialogTransactionsController());

  @override
  void dispose() {
    Get.delete<DialogTransactionsController>();
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Transactions History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
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
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => CustomTextButton(
                      background: controller.isDeposit.value
                          ? const Color(0xff42BE65)
                          : Colors.transparent,
                      onPressed: () {
                        controller.isDeposit.value = true;
                      },
                      child: const Text(
                        "DEPOSIT",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Obx(
                  () => CustomTextButton(
                      background: !controller.isDeposit.value
                          ? const Color(0xff42BE65)
                          : Colors.transparent,
                      onPressed: () {
                        controller.isDeposit.value = false;
                      },
                      child: const Text(
                        "WITHDRAWAL",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => controller.loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.transactionsItems.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.transactionsItems.isEmpty
                            ? 1
                            : controller.transactionsItems.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: null,
                                  leading: null,
                                  title: Row(children: const <Widget>[
                                    Expanded(
                                      child: SelectableText(
                                        "Address",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: SelectableText("Amount",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                      child: SelectableText("Status",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                    Expanded(
                                      child: SelectableText("Last Update",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ]),
                                ),
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
                                child: SelectableText(
                                  controller
                                      .transactionsItems[index].publicAddress,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: SelectableText(
                                      "${controller.transactionsItems[index].amount.toString()} ${controller.transactionsItems[index].currency.toString()}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: SelectableText(
                                      controller.transactionsItems[index].status
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                              Expanded(
                                  child: SelectableText(
                                      getDate(controller
                                              .transactionsItems[index]
                                              .updatedAt)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ))),
                            ]),
                          );
                        },
                      )
                    : const Center(
                        child: SelectableText(
                          'Empty List!',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  String getDate(String isoDate) {
    var utc = DateTime.parse(isoDate);
    return DateFormat('MM/dd/yyyy - HH:mm').format(utc.toLocal());
  }
}
