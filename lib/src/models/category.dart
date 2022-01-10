// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Category {
  final String id;
  final String name;
  final String img;
  final int type;
  final String status;

  Category({
    required this.id,
    required this.name,
    required this.img,
    required this.type,
    required this.status,
  });

  @override
  String toString() {
    return "Category{name: $name, img: $img, type: ${type == 0 ? 'expense' : 'income'} ,status: $status}";
  }

  // Category.fromJson(Map<String, dynamic> json) {
  //   // id = json['id'];
  //   name = json['name'];
  //   img = json['img'];
  //   type = json['type'];
  //   status = json['status'];
  // }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   // data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['img'] = this.img;
  //   data['type'] = this.type;
  //   data['status'] = this.status;
  //   return data;
  // }
  Category.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          img: json['img']! as String,
          type: json['type']! as int,
          status: json['status']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'img': img,
      'type': type,
      'status': status,
    };
  }

  static Category fromSnapshot(DocumentSnapshot snapshot, String id) {
    Category category = Category(
        id: id,
        name: snapshot['name'],
        img: snapshot['img'],
        type: snapshot['type'],
        status: snapshot['status']);
    return category;
  }

  static List CategoriesByType(List categories, int type, String id) {
    return categories.where((element) {
      return (element['type'] == type &&
          (element['status'] == "" || element['status'] == id));
    }).toList();
  }

  static List CategoriesByStatus(List categories, String id) {
    return categories.where((element) {
      return element['status'] == id;
    }).toList();
  }
}
