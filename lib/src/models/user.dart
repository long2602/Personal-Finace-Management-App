import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loda_app/src/models/wallet.dart';

class Users {
  final String name;
  final String email;
  final String? img;
  // final List<Wallet>? wallets;

  Users({
    required this.name,
    required this.email,
    this.img,
    // this.wallets,
  });

  @override
  String toString() {
    return "User{name: $name, email: $email}";
  }

  factory Users.fromJson(
    Map<String, dynamic> json,
  ) {
    return Users(
      name: json['name'],
      email: json['email'],
      img: json['img'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'img': img,
      'email': email,
    };
  }

  static Users fromSnapshot(DocumentSnapshot snapshot) {
    Users users = Users(
        name: snapshot['name'], email: snapshot['email'], img: snapshot['img']);
    return users;
  }
}
