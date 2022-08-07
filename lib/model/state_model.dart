class StateModel {
  String? sId;
  double? wagered;
  double? profit;
  double? loss;
  double? ath;
  double? atl;
  double? totalBets;

  StateModel(
      {this.sId,
      this.wagered = 0,
      this.profit = 0,
      this.loss = 0,
      this.ath = 0,
      this.atl = 0,
      this.totalBets = 0});

  StateModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    wagered = json['wagered'];
    profit = json['profit'];
    loss = json['loss'];
    ath = json['ath'];
    atl = json['atl'];
    totalBets = json['totalBets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['wagered'] = wagered;
    data['profit'] = profit;
    data['loss'] = loss;
    data['ath'] = ath;
    data['atl'] = atl;
    data['totalBets'] = totalBets;
    return data;
  }

  bool checkIfAnyIsNull() {
    return [sId, wagered, profit, loss, ath, atl, totalBets].contains(null);
  }
}
