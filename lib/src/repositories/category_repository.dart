import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loda_app/src/models/category.dart';

class CategoryRepository {
  final categories = FirebaseFirestore.instance.collection('categories');
  // final Stream<QuerySnapshot> categoryStream =
  //     FirebaseFirestore.instance.collection("categories").snapshots();

  // Stream<List<Category>> categories() {
  //   return category.snapshots().map((snapshot) {});
  // }

  Future getCategoriesList() async {
    List listCategory = [];
    try {
      await categories.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          listCategory.add(element.data());
        });
      });
      return listCategory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<QuerySnapshot> getCategories() async {
    return categories.get();
  }

  Future getCategoriesListByType(int type) async {
    List listCategories = [];
    try {
      await categories.where('type', isEqualTo: type).get().then((value) {
        value.docs.forEach((element) {
          listCategories.add(element.data());
        });
      });
      return listCategories;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> addCategory(
      String name, String img, String status, int type) async {
    return categories.doc().set({
      'name': name,
      'img': img,
      'status': status,
      'type': type
    }).catchError((_) => print("fail"));
  }

  Future<void> deleteCategory(String id) async {
    return categories
        .doc(id)
        .delete()
        .then((value) => print("category deleted"))
        .catchError((error) => print("error: $error"));
  }

  Future<Map<String, dynamic>> getCategoryById(String id) async {
    final snapshot = await categories.doc(id).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    data['id'] = snapshot.id;
    return data;
  }

  Future<void> updateCategory(
      String name, String img, int type, String id) async {
    return categories
        .doc(id)
        .update({'name': name, 'img': img, 'type': type})
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }
}
