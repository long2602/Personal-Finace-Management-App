import 'package:loda_app/src/models/transaction.dart';

class Wallet {
  final String id;
  final String name;
  final num balance;
  final String currency;
  final String note;
  final String img;
  final bool status;
  final List<Transactions>? transactions;
  Wallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.currency,
    required this.note,
    required this.img,
    required this.status,
    this.transactions,
  });

  factory Wallet.fromJson(
      Map<String, dynamic> json, List<Transactions> trans, String id) {
    return Wallet(
        id: id,
        name: json['name'],
        balance: json['balance'],
        currency: json['currency'],
        note: json['note'],
        img: json['img'],
        status: json['status'],
        transactions: trans);
  }

  // static List<Wallet> fromJsonArray(List<dynamic> jsonArray) {
  //   List<Wallet> wallets = [];
  //   jsonArray.forEach((element) {
  //     wallets.add(Wallet.fromJson(element));
  //   });
  //   return wallets;
  // }
}
