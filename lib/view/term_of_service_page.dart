import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class TermOfServicePage extends StatelessWidget {
  const TermOfServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: wAppbar(),
      body: SingleChildScrollView(
        padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(),
      ),
    );
  }

  PreferredSizeWidget wAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(LineIcons.arrowLeft),
              splashRadius: 20,
            ),
          ],
        ),
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () => controller.handleIconButton(),
      //     icon: Icon(
      //         controller.token.isEmpty ? Feather.log_in : Feather.user),
      //     splashRadius: 20,
      //   )
      // ],
      // leading:  IconButton(
      //   onPressed: () {
      //     Get.back(canPop: true);
      //   },
      //   icon: Icon(Feather.arrow_left),
      //   splashRadius: 20,
      // ),
    );
  }
}
