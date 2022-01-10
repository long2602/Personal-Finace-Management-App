import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String id;
  final num money;
  final String? description;
  final DateTime createAt;
  final String? location;
  final String? event;
  final String? imgs;
  final String idCategory;
  final bool type;
  final String? imgCategory;
  final String? nameCategory;

  Transactions({
    required this.id,
    required this.idCategory,
    required this.money,
    this.description,
    required this.createAt,
    this.location,
    this.event,
    this.imgs,
    required this.type,
    this.imgCategory,
    this.nameCategory,
  });

  factory Transactions.fromJson(
      Map<String, dynamic> json, String id, Map<String, dynamic> jsonCategory) {
    final Timestamp timestamp = json['createAt'];
    return Transactions(
      id: id,
      idCategory: json['idCategory'],
      money: json['money'],
      createAt: timestamp.toDate(),
      description: json['description'],
      location: json['location'],
      event: json['event'],
      imgs: json['img'],
      imgCategory: jsonCategory['img'],
      nameCategory: jsonCategory['name'],
      type: jsonCategory['type'] == 0 ? true : false,
    );
  }

  // static List<Transactions> fromJsonArray(List<dynamic> json) {
  //   List<Transactions> trans = [];

  //   json.forEach((element) {
  //     trans.add(Transactions.fromJson(element));
  //   });
  //   return trans;
  // }
}
