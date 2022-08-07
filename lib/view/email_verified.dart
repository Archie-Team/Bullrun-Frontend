import 'package:bet/global/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EmailVerified extends StatelessWidget {
  const EmailVerified({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveWrapper.of(context).isSmallerThan("DESKTOP")
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: wVerified(),
        ),
      ),
    );
  }

  Widget wVerified() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SelectableText(
          "Your Email Verified",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextButton(
            onPressed: () {
              Get.offAllNamed("/home");
            },
            child: const Text("Back To Home Page"))
      ],
    );
  }
}
