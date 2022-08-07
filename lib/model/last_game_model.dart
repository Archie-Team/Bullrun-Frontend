class LastGameModel {
  int? id;
  String? hash;
  double? crashPoint;
  String? state;
  String? createdAt;
  String? updatedAt;

  LastGameModel(
      {this.id,
      this.hash,
      this.crashPoint,
      this.state,
      this.createdAt,
      this.updatedAt});

  LastGameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hash = json['hash'];
    crashPoint = json['crashPoint'];
    state = json['state'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hash'] = hash;
    data['crashPoint'] = crashPoint;
    data['state'] = state;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
