import 'package:bet/controller/home_controller.dart';
import 'package:bet/global/notification.dart';
import 'package:bet/global/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../global/colors.dart';
import '../global/gif_widget.dart';
import '../global/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());
  FlutterGifController? gifController;

  @override
  void initState() {
    super.initState();
    gifController = FlutterGifController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    gifController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: wAppbar(),
      body: wContent(),
    );
  }

  PreferredSizeWidget wAppbar() {
    return AppBar(
      backgroundColor: cardColor,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => Storage.isTokenSaved.value
                  ? CustomTextButton(
                      onPressed: () {
                        clearAll();
                        Storage.isTokenSaved.value = false;
                        showSnackbar("Success", "Logout", LineIcons.check);
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  : CustomTextButton(
                      onPressed: controller.handleButton,
                      child: const Text(
                        "Login/Signup",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          )),
    );
  }

  Widget wContent() {
    return SingleChildScrollView(
      controller: controller.scrollC,
      padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          MouseRegion(
            child: Stack(
              children: [
                GifImage(
                    image: const AssetImage(
                      "assets/video/animated_logo.gif",
                    ),
                    height: ResponsiveWrapper.of(context).screenHeight / 3,
                    controller: gifController!)
              ],
            ),
            onEnter: (e) {
              if (!controller.hover.value) {
                controller.hover.value = true;
                // gifController?.animateTo(42,
                //     duration: const Duration(seconds: 5));
                gifController?.reset();
                gifController?.repeat(
                    min: 0, max: 42, period: const Duration(seconds: 4));
              }
            },
            onExit: (e) {
              if (controller.hover.value) {
                controller.hover.value = false;
                gifController?.stop();
                gifController?.reset();
              }
            },
          ),
          CustomTextButton(
            onPressed: () async {
              Get.toNamed("/bet");
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Play Now",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          wDescription(),
          const SizedBox(
            height: 50,
          ),
          wHowToPlay(),
          const SizedBox(
            height: 20,
          ),
          wBiggestWinners(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget wDescription() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.listDes.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CardModel(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectableText(
                      controller.listDes[index].title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color(0xff437157),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: controller.listDes[index].image.contains(".svg")
                          ? SvgPicture.asset(
                              controller.listDes[index].image,
                              width: 40,
                              height: 40,
                            )
                          : Image.asset(
                              controller.listDes[index].image,
                              width: 40,
                              height: 40,
                            ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0),
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(controller.listDes[index].des,
                      style: const TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget wHowToPlay() {
    return Column(
      children: [
        const SelectableText(
          "How To Play",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        IntrinsicHeight(
          child: ResponsiveRowColumn(
            columnSpacing: 10,
            rowSpacing: 20,
            layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CardModel(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          "STEP 1",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Create Account",
                            style: TextStyle(
                                color: Color(0xffc1c7cd),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                            "Signup with your email and by signup you agree to terms and conditions",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CardModel(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          "STEP 2",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: WidgetShaderMask(
                          text: const Text("Connect Wallet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                            "Connect your wallet in cashier and deposit with BUSD or USDC. Once clear you can head to Swap and exchange for BUX then play!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CardModel(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          "STEP 3",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Play Now",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffE5E4E2))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                            "You can play whenever you want. BullRun is a real time game",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget wBiggestWinners() {
    return CardModel(
      child: Column(
        children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: SelectableText(
                    "Leaderboard",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
          Container(
            color: const Color(0xffD7B458),
            height: 1,
          ),
          Obx(() => controller.leaderBoardItems.isEmpty
              ? const Center(
                  child: Text(
                    'No one has played yet!',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.leaderBoardItems.length < 5
                      ? controller.leaderBoardItems.length
                      : 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SelectableText(
                                    "#${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    onPressed: () => controller.showState(
                                        controller
                                            .leaderBoardItems[index].userId,
                                        controller
                                            .leaderBoardItems[index].username),
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            Size.zero),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.zero)),
                                    child: Text(
                                        controller
                                            .leaderBoardItems[index].username,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              SelectableText(
                                  "Total ${controller.leaderBoardItems[index].totalBets} Bets with ${controller.leaderBoardItems[index].profit} BUX",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
