class UserModel {
  UserModel({
    this.address,
    this.fullName,
    this.email,
    this.phone,
    this.profilePic,
    this.token,
  });

  String? address;
  String? fullName;
  String? email;
  String? phone;
  String? profilePic;
  String? token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        address: json["address"],
        fullName: json["fullName"],
        email: json["email"],
        phone: json["phone"],
        profilePic: json["profilePic"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "profilePic": profilePic,
        "token": token,
      };
}
