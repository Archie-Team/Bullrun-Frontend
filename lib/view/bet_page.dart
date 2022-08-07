import 'package:bet/controller/bet_controller.dart';
import 'package:bet/global/animated_flip_counter.dart';
import 'package:bet/global/blink_text.dart';
import 'package:bet/global/gif_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../config/enum.dart';
import '../global/colors.dart';
import '../global/counter_down/count_down.dart';
import '../global/storage.dart';
import '../global/widgets.dart';

class BetPage extends StatefulWidget {
  const BetPage({Key? key}) : super(key: key);

  @override
  State<BetPage> createState() => _BetPageState();
}

class _BetPageState extends State<BetPage> {
  final BetController controller = Get.put(BetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: wAppbar(),
        body: Obx(() => controller.loadingPage.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: SingleChildScrollView(
                  controller: controller.scrollC,
                  padding: ResponsiveWrapper.of(context)
                          .isSmallerThan("DESKTOP")
                      ? const EdgeInsets.symmetric(horizontal: 20, vertical: 0)
                      : const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                  child: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
                      ? mainResponsiveMobile()[0]
                      : mainResponsiveDesktop()[0],
                ),
              )));
  }

  PreferredSizeWidget wAppbar() => AppBar(
        backgroundColor: cardColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Get.offAllNamed('/home');
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: const Text(
                      "Home",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )),
                CustomTextButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onPressed: controller.showLeaderBoard,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          LineIcons.meteor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Leaderboard",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                CustomTextButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onPressed: controller.handleCashier,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          LineIcons.alternateExchange,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Cashier",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                CustomTextButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onPressed: controller.handleSwap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Icon(
                          LineIcons.syncIcon,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Swap",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                CustomTextButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onPressed: controller.handleIconButtonLogin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          LineIcons.userAlt,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Obx(() => Text(
                              Storage.isTokenSaved.value
                                  ? "Profile"
                                  : "Login/Signup",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ))
                      ],
                    )),
              ],
            ),
          ),
        ),
      );

  List<Widget> mainResponsiveMobile() {
    var size = MediaQuery.of(context).size;
    return [
      Column(
        children: [
          SizedBox(
            height: (size.height - AppBar().preferredSize.height) - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: wMainBet()),
                wRowBetHistory(),
                const SizedBox(
                  height: 10,
                ),
                wBetButtons(),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: CardModel(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          wChatListView(),
                          const SizedBox(
                            height: 5,
                          ),
                          wMessageTextField()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: ResponsiveWrapper.of(Get.context!).screenHeight / 1.5,
            child: CardModel(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                            onTap: null,
                            leading: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                            ),
                            title: Row(children: const <Widget>[
                              Expanded(
                                child: Text(
                                  "Username",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Bet",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Profit",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ])),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xffD7B458),
                        ),
                        controller.playersItems.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Center(
                                  child: Text(
                                    "No Players",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: ListView.builder(
                                    controller: controller
                                        .scrollControllerOnlinePlayers,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: controller.playersItems.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        color: controller
                                            .playersItems[index].color,
                                        child: ListTile(
                                            onTap: null,
                                            leading: null,
                                            title: Row(children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  controller.playersItems[index]
                                                      .username
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.playersItems[index]
                                                      .amount
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.playersItems[index]
                                                              .profit ==
                                                          null
                                                      ? "_"
                                                      : "${controller.playersItems[index].profit?.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ])),
                                      );
                                    }),
                              ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff121619),
                          borderRadius: BorderRadius.circular(20)),
                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "online: ${controller.onlineUsers.value}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Playing: ${controller.players.value}",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Betting: ${controller.gameTotalBet.value} bux",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      )
    ];
  }

  List<Widget> mainResponsiveDesktop() {
    var size = MediaQuery.of(context).size;
    return [
      Center(
        child: SizedBox(
          height: (size.height - AppBar().preferredSize.height) - 30,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: chatUI(),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: wMainBet()),
                        wRowBetHistory(),
                        const SizedBox(
                          height: 10,
                        ),
                        wBetButtons()
                      ],
                    ),
                  )),
              Expanded(
                flex: 2,
                child: wOnlinePlayers(),
              )
            ],
          ),
        ),
      ),
    ];
  }

  Widget wMainBet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () {
          return controller.gameState.value == GameState.pending
              ? const Text(
                  "Loading Game",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                )
              : controller.gameState.value == GameState.starting
                  ? Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Stack(
                            children: [
                              Image.asset(
                                "assets/video/starting.gif",
                                width: double.infinity,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    child: Obx(() => Image.asset(
                                          !controller.mute.value
                                              ? "assets/images/volume.png"
                                              : "assets/images/mute.png",
                                          width: 28,
                                          height: 28,
                                          color: const Color(0xff999999),
                                        )),
                                    onTap: () {
                                      controller.handleMute();
                                    }),
                              )
                            ],
                          ),
                        ),
                        Obx(() {
                          return Countdown(
                            seconds: controller.startAtTime.value,
                            build: (BuildContext context, double time) => Text(
                              time.toString(),
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            interval: const Duration(milliseconds: 100),
                            controller: controller.controller,
                          );
                        })
                      ],
                    )
                  : controller.gameState.value == GameState.started
                      ? Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: controller.firstGif.value
                                  ? GifImage(
                                      image: const AssetImage(
                                          "assets/video/started1-no-loop.gif"),
                                      controller: controller.gifController!,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "assets/video/started2.gif",
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Obx(() {
                                return AnimatedFlipCounter(
                                  value: controller.gameTick.value / 100,
                                  fractionDigits: 2,
                                  prefix: "X",
                                  textStyle: const TextStyle(
                                      fontSize: 40,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold),
                                );
                              }),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            // Image.asset(
                            //   "assets/video/end.gif",
                            //   width: double.infinity,
                            //   fit: BoxFit.cover,
                            // ),
                            GifImage(
                              image: const AssetImage(
                                "assets/video/end.gif",
                              ),
                              controller: controller.gifEndController!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Obx(() {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.endedData['crashPoint'] != 1
                                        ? "X${controller.endedData['crashPoint'] / 100}"
                                        : "X1",
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  BlinkText(
                                      text:
                                          (controller.endedData['crashPoint'] /
                                                      100) <
                                                  2
                                              ? "REKT"
                                              : "NUKE",
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                      beginColor: Colors.white,
                                      endColor: Colors.transparent,
                                      times: 5,
                                      duration:
                                          const Duration(milliseconds: 500))
                                ],
                              );
                            }),
                          ],
                        );
        },
      ),
    );
  }

  Widget wGifOne() {
    var key = UniqueKey();
    return Image.asset(
      "assets/video/started1.gif",
      key: key,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget wRowBetHistory() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: controller.gameHistory
              .map((e) => Text(
                    "X$e",
                    style: TextStyle(
                        fontSize: 12,
                        color: e > 2 ? const Color(0xff42BE65) : redColor,
                        fontWeight: FontWeight.bold),
                  ))
              .toList())),
    );
  }

  Widget wBetButtons() {
    return CardModel(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: WidgetTextField(
                              context: Get.context!,
                              label: "Bet",
                              // enable: controller.isbet.value,
                              icon: LineIcons.lightningBolt,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              helperText: "Max bet = 200 BUX",
                              validator: (value) {
                                if (value!.isNotEmpty &&
                                    int.parse(value) > 200) {
                                  return "Max bet = 200 BUX";
                                } else {
                                  return null;
                                }
                              },
                              controller: controller.amountController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  controller.maxCashOut.value = controller
                                      .roundDown(5000 / int.parse(value), 2);
                                } else {
                                  controller.maxCashOut.value = 0;
                                }
                              }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "BUX",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff42BE65),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    WidgetTextField(
                        context: Get.context!,
                        label: "Auto Cash Out",
                        icon: LineIcons.creditCard,
                        helperText: "Max Cash Out: ${controller.maxCashOut}",
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (double.parse(value) <= 1) {
                              return "Min Cash Out: 1";
                            } else if (double.parse(value) >
                                controller.maxCashOut.value) {
                              return "Max Cash Out: ${controller.maxCashOut}";
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        controller: controller.autoCashOutController),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                wButtonBet()
              ],
            )),
      ),
    );
  }

  Widget chatUI() {
    return CardModel(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            wChatListView(),
            const SizedBox(
              height: 5,
            ),
            wMessageTextField()
          ],
        ),
      ),
    );
  }

  Widget wChatListView() {
    return Flexible(
      child: Obx(() => ListView.builder(
          itemCount: controller.chatItems.length,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getDate(controller.chatItems[index].createdAt!),
                    style: const TextStyle(fontSize: 12, color: greyColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      controller.showState(
                          controller.chatItems[index].sender!.id,
                          controller.chatItems[index].sender!.username);
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    child: Text(
                      "${controller.chatItems[index].sender?.username}: ",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: SelectableText(
                    controller.chatItems[index].msg!,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.white, letterSpacing: 0.5),
                  ))
                ],
              ),
            );
          })),
    );
  }

  Widget wOnlinePlayers() {
    return CardModel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                    onTap: null,
                    leading: null,
                    title: Row(children: const <Widget>[
                      Expanded(
                        child: Text(
                          "Username",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Bet",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Profit",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xffD7B458),
                ),
                controller.playersItems.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Center(
                          child: Text(
                            "No Players",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    : Flexible(
                        child: ListView.builder(
                            controller:
                                controller.scrollControllerOnlinePlayers,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.playersItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: controller.playersItems[index].color,
                                child: ListTile(
                                    onTap: null,
                                    leading: null,
                                    title: Row(children: <Widget>[
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            controller.showState(
                                                controller
                                                    .playersItems[index].userId,
                                                controller.playersItems[index]
                                                    .username);
                                          },
                                          style: ButtonStyle(
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size.zero),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          child: Text(
                                            controller
                                                .playersItems[index].username
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.playersItems[index].amount
                                              .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.playersItems[index]
                                                      .profit ==
                                                  null
                                              ? "_"
                                              : "${controller.playersItems[index].profit?.toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ])),
                              );
                            }),
                      ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: const Color(0xff121619),
                  borderRadius: BorderRadius.circular(20)),
              child: Obx(
                () => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "online: ${controller.onlineUsers.value}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Playing: ${controller.players.value}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Betting: ${controller.gameTotalBet.value} bux",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget wMessageTextField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => !Storage.isTokenSaved.value
            ? Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: greyColor),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "You must login first",
                  style: TextStyle(fontSize: 15),
                ),
              )
            : TextFormField(
                textInputAction: TextInputAction.send,
                controller: controller.chatController,
                focusNode: controller.focusNode,
                onFieldSubmitted: controller.handleSendMessage,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "message",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: buttonColor, width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white.withAlpha(100), width: 0.5),
                  ),
                ),
              ),
      ),
    );
  }

  Widget wButtonBet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        SelectableText(
            "Available: ${controller.availableMoney.value.toStringAsFixed(2)} BUX"),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextButton(
                  onPressed:
                      !Storage.isTokenSaved.value ? null : controller.handleBet,
                  child: const Text(
                    "BET",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextButton(
                  onPressed: !Storage.isTokenSaved.value
                      ? null
                      : controller.handleCashOut,
                  child: const Text(
                    "Cash Out",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  String getDate(int unixTime) {
    return DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(unixTime));
  }
}
