import 'package:flutter/material.dart';

class PlayersModel {
  late dynamic username;
  late dynamic amount;
  dynamic? cashedOutAt;
  double? profit;
  late String userId;
  Color? color = Colors.transparent;

  PlayersModel(
      {required this.userId,
      required this.username,
      required this.amount,
      this.cashedOutAt,
        this.profit,
      required this.color});

  PlayersModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] as String;
    username = json['username'] as dynamic;
    amount = json['amount'] as dynamic;
    cashedOutAt =
        json.containsKey('cashedOutAt') ? json['cashedOutAt'] as dynamic : null;
    profit = json.containsKey("profit") ? json['profit'] as dynamic : null;
    color = profit! > 0 ? Colors.green : Colors.redAccent;
  }
}
