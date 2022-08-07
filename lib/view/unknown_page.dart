import 'package:flutter/material.dart';

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    body: Center(
      child: Text("Oops!\nPage not found" , style: TextStyle(fontSize: 20),),
    ),
    );
  }
}
