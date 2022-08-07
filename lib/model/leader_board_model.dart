class LeaderBoardModel {
  late String username;
  late String userId;
  late double wagered;
  late double profit;
  late double loss;
  late double ath;
  late double atl;
  late int totalBets;

  LeaderBoardModel(
      {required this.username,
      required this.userId,
      required this.wagered,
      required this.profit,
      required this.loss,
      required this.ath,
      required this.atl,
      required this.totalBets});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    username = json['_id'];
    userId = json['userId'];
    wagered = json['wagered'];
    profit = json['profit'];
    loss = json['loss'];
    ath = json['ath'];
    atl = json['atl'];
    totalBets = json['totalBets'];
  }
}
