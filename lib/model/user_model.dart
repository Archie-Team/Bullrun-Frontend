class UserModel {
  User? user;

  UserModel({this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  Email? email;
  Security? security;
  Balance? balance;
  String? username;
  String? createdAt;
  String? updatedAt;
  String? id;
  String? publicAddress = "";

  User(
      {this.email,
      this.security,
      this.balance,
      this.username,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.publicAddress});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'] != null ? Email.fromJson(json['email']) : null;
    security =
        json['security'] != null ? Security.fromJson(json['security']) : null;
    balance =
        json['balance'] != null ? Balance.fromJson(json['balance']) : null;
    username = json['username'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    publicAddress = json['publicAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (email != null) {
      data['email'] = email!.toJson();
    }
    if (security != null) {
      data['security'] = security!.toJson();
    }
    if (balance != null) {
      data['balance'] = balance!.toJson();
    }
    data['username'] = username;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['publicAddress'] = publicAddress;
    return data;
  }
}

class Email {
  String? current;
  bool? isEmailVerified;

  Email({this.current, this.isEmailVerified});

  Email.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['isEmailVerified'] = isEmailVerified;
    return data;
  }
}

class Security {
  TwoFactorAuthentication? twoFactorAuthentication;

  Security({this.twoFactorAuthentication});

  Security.fromJson(Map<String, dynamic> json) {
    twoFactorAuthentication = json['twoFactorAuthentication'] != null
        ? TwoFactorAuthentication.fromJson(json['twoFactorAuthentication'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (twoFactorAuthentication != null) {
      data['twoFactorAuthentication'] = twoFactorAuthentication!.toJson();
    }
    return data;
  }
}

class TwoFactorAuthentication {
  bool? isEnabled;
  String? secret;
  String? otpAuthQR;

  TwoFactorAuthentication({this.isEnabled, this.secret, this.otpAuthQR});

  TwoFactorAuthentication.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];
    secret = json['secret'];
    otpAuthQR = json['otpAuthQR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isEnabled'] = isEnabled;
    data['secret'] = secret;
    data['otpAuthQR'] = otpAuthQR;
    return data;
  }
}

class Balance {
  double? busd;
  double? bux;
  double? usdc;

  Balance({this.busd, this.bux});

  Balance.fromJson(Map<String, dynamic> json) {
    busd = json['busd'];
    bux = json['bux'];
    usdc = json['usdc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['busd'] = busd;
    data['bux'] = bux;
    data['usdc'] = usdc;
    return data;
  }
}
