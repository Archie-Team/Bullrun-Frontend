import 'dart:convert';

class ChatModel {
  String? msg;
  Sender? sender;
  int? createdAt;

  ChatModel({this.msg, this.sender, this.createdAt});

  ChatModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'] as String;
    sender = json['sender'] != null
        ? Sender.fromJson(json['sender'])
        : null as dynamic;
    createdAt = json['createdAt'] as int;
  }
}

class Sender {
  late String username;
  late String id;

  Sender({required this.username, required this.id});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }
}

List<ChatModel> chatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));
