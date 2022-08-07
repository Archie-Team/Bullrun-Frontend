class TransactionsModel {
  late String publicAddress;
  late dynamic amount;
  late String type;
  late String status;
  late String createdAt;
  late String updatedAt;
  late String currency;

  TransactionsModel(
      {required this.publicAddress,
      required this.amount,
      required this.type,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    publicAddress = json['publicAddress'] as String;
    amount = json['amount'] as dynamic;
    type = json['type'] as String;
    status = json['status'] as String;
    createdAt = json['createdAt'] as String;
    updatedAt = json['updatedAt'] as String;
    currency = json['currency'] as String;
  }
}
