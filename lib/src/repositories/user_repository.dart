import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loda_app/src/models/category.dart';
import 'package:loda_app/src/models/transaction.dart';
import 'package:loda_app/src/models/user.dart';
import 'package:loda_app/src/models/wallet.dart';
import 'package:loda_app/src/repositories/category_repository.dart';
import 'package:loda_app/src/widgets/text_input_formater.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  final users = FirebaseFirestore.instance.collection('users');
  final categories = FirebaseFirestore.instance.collection('categories');

  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  //Đăng nhập
  Future<dynamic> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
      return false;
    }
  }

  //Đăng nhập với google
  // Future<dynamic> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount!.authentication;
  //   final AuthCredential authCredential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.accessToken,
  //       accessToken: googleSignInAuthentication.idToken);
  //   await _firebaseAuth.signInWithCredential(authCredential);
  // }

  //tạo user
  Future<dynamic> createUserWithEmailAndPassword(
      String email, String password) async {
    final uid = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    return uid.user!.uid;
  }

  //SignOut
  Future<dynamic> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  //Kiểm tra có đang đăng nhập ko
  Future<bool> isSignedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  //get user
  Future<User> getUser() async {
    return _firebaseAuth.currentUser!;
  }

  //get uid user
  Future<String> getUidUser() async {
    return _firebaseAuth.currentUser!.uid;
  }

  // Future<String?> changePassword(String pass) async {
  //   _firebaseAuth.currentUser!
  //       .updatePassword(pass)
  //       .then((_) => print('Change passed'));
  // }
  Future<dynamic> reAuthen(String pass, String repass) async {
    User? user = FirebaseAuth.instance.currentUser!;
    try {
      UserCredential authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: pass,
        ),
      );
      authResult.user!.updatePassword(repass).then((_) {
        print("Your password changed Succesfully ");
        return true;
      }).catchError((err) {
        print("You can't change the Password" + err.toString());
        return false;
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
      return true;
    } on FirebaseAuthException catch (e) {
      print("You can't change the Password" + e.toString());
      return false;
    }
  }

  void changePassword(String password) async {
    //Create an instance of the current user.
    User? user = FirebaseAuth.instance.currentUser;

    //Pass in the password to updatePassword.
    user!.updatePassword(password).then((_) {
      print("Your password changed Succesfully ");
    }).catchError((err) {
      print("You can't change the Password" + err.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  // //insert user
  // Future<void> addUser(String id, String name, String email) {
  //   return users
  //       .add({
  //         'id': id,
  //         'name': name,
  //         'email': email,
  //         'img': "",
  //       })
  //       .then((value) => print("User added"))
  //       .catchError((onError) => print("failed"));
  // }

  Future<Users> getUserData(String id) async {
    Users? usersModel;
    // final List<Wallet> wallets = await getListWallet(id);
    final userSnapshot = await users.doc(id).get();
    Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
    usersModel = Users.fromJson(data);
    return usersModel;
  }

  // get wallet
  // Future<List<Wallet>> getListWallet(String id) async {
  //   List<Wallet> wallets = [];
  //   try {
  //     final walletSnapshot = await users.doc(id).collection('wallets').get();
  //     walletSnapshot.docs.forEach((element) async {
  //       Map<String, dynamic> data = element.data();
  //       final List<Transactions> trans =
  //           await getListTransaction(id, element.id);
  //       final item = Wallet.fromJson(data, trans, element.id);
  //       wallets.add(item);
  //     });
  //     return wallets;
  //   } catch (_) {
  //     return wallets;
  //   }
  // }

  //get transactions
  // Future<List<Transactions>> getListTransaction(
  //     String idUser, String idWallet) async {
  //   List<Transactions> trans = [];
  //   try {
  //     final walletSnapshot = await users
  //         .doc(idUser)
  //         .collection('wallets')
  //         .doc(idWallet)
  //         .collection("transactions")
  //         .get();
  //     walletSnapshot.docs.forEach((element) {
  //       Map<String, dynamic> data = element.data();
  //       final tran = Transactions.fromJson(data, element.id);
  //       trans.add(tran);
  //     });
  //     return trans;
  //   } catch (_) {
  //     return trans;
  //   }
  // }

  //insert data
  Future<void> insertUser(String id, String name, String email) async {
    return users
        .doc(id)
        .set({
          'name': name,
          'email': email,
          'img': "",
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  //update data
  Future<void> updateUser(String name, String img) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .update({'name': name, 'img': img})
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  //wallet
  Future<void> deleteWallet(String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    return walletSnapshot
        .doc(wid)
        .delete()
        .then((value) => print("Wallet deleted"))
        .catchError((error) => print("error: $error"));
  }

  Future<void> deleteAllTrans(String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    var collection =
        users.doc(id).collection('wallets').doc(wid).collection("transactions");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  //update data
  Future<void> updateWallet(String wid, String name, String img, String balance,
      String note, String currency, num remain) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    return walletSnapshot
        .doc(wid)
        .update({
          'balance': currencyToInt(balance),
          'img': img,
          'name': name,
          'note': note,
          'currency': currency,
          'remain': remain,
        })
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<void> updateMainWallet(bool check, String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    return walletSnapshot
        .doc(wid)
        .update({'status': check})
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<void> selectMainWallet(String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = await users.doc(id).collection('wallets').get();
    walletSnapshot.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      if (element.id == wid) {
        updateMainWallet(true, element.id);
      } else {
        updateMainWallet(false, element.id);
      }
    });
    // return walletSnapshot
    //     .doc(wid)
    //     .update({
    //       'balance': num.parse(balance),
    //       'img': img,
    //       'name': name,
    //       'note': note,
    //       'currency': currency,
    //       'remain': remain,
    //     })
    //     .then((_) => print('Update successfully'))
    //     .catchError((error) => print('Update failed: $error'));
  }

  Future<void> calculateWallet(num remain, String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    return walletSnapshot
        .doc(wid)
        .update({
          'remain': remain,
        })
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<void> insertWallet(String name, String balance, String note,
      String currency, String img) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc()
        .set({
          'name': name,
          'note': note,
          'img': img,
          'currency': currency,
          'balance': currencyToInt(balance),
          'status': false,
          'remain': currencyToInt(balance),
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<void> insertGeneralWallet(String name, String balance, String note,
      String currency, String img, String id) async {
    // String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc()
        .set({
          'name': name,
          'note': note,
          'img': img,
          'currency': currency,
          'balance': num.parse(balance),
          'status': true,
          'remain': num.parse(balance),
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<QuerySnapshot> getListWalletSnapshot() async {
    String id = _firebaseAuth.currentUser!.uid;
    return users.doc(id).collection('wallets').get();
  }

  Future<QuerySnapshot> getListBudget(String id) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users.doc(id).collection('budgets').get();
  }

  Future<dynamic> getListBudgetById(String bid) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users.doc(id).collection('budgets').doc(bid).get();
  }

  Future<void> deleteBudget(String bid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('budgets');
    return walletSnapshot
        .doc(bid)
        .delete()
        .then((value) => print("Wallet deleted"))
        .catchError((error) => print("error: $error"));
  }

  Future<void> insertBudget(
      String name,
      String balance,
      String currency,
      String idCategory,
      String idWallet,
      DateTime start,
      DateTime end,
      num remain) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('budgets')
        .doc()
        .set({
          'name': name,
          'balance': currencyToInt(balance),
          'currency': currency,
          'idCategory': idCategory,
          'idWallet': idWallet,
          'startDay': Timestamp.fromDate(start),
          'endDay': Timestamp.fromDate(end),
          'remain': remain
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<void> updateBudget(
    String bid,
    String name,
    String balance,
    String currency,
    String idCategory,
    String idWallet,
    DateTime start,
    DateTime end,
    num remain,
  ) async {
    String id = _firebaseAuth.currentUser!.uid;
    final budgetsnapshot = users.doc(id).collection('budgets');
    return budgetsnapshot
        .doc(bid)
        .update({
          'name': name,
          'balance': currencyToInt(balance),
          'currency': currency,
          'idCategory': idCategory,
          'idWallet': idWallet,
          'startDay': Timestamp.fromDate(start),
          'endDay': Timestamp.fromDate(end),
          'remain': remain,
        })
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<QuerySnapshot> getSelectedWallet() async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .where('status', isEqualTo: true)
        .get();
  }

  Future<DocumentSnapshot> getWalletById(String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users.doc(id).collection('wallets').doc(wid).get();
  }

  //Transaction
  Future<void> insertTransaction(
      String money,
      String note,
      String idwallet,
      String idcategory,
      DateTime dateTime,
      String event,
      String location,
      String img,
      bool type,
      String currency) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(idwallet)
        .collection('transactions')
        .doc()
        .set({
          'money': currencyToInt(money),
          'description': note,
          'event': event,
          'location': location,
          'img': img,
          'idCategory': idcategory,
          'createAt': Timestamp.fromDate(dateTime),
          'type': type,
          'currency': currency,
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<QuerySnapshot> getTransactions(String wid) {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .get();
  }

  Future<QuerySnapshot> getTransactionsByDate(String wid, DateTime date) {
    String id = _firebaseAuth.currentUser!.uid;
    DateTime checkS = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime checkE = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isGreaterThanOrEqualTo: checkS)
        .where('createAt', isLessThanOrEqualTo: checkE)
        .get();
  }

  Future<QuerySnapshot> getTransactionsByRange(
      String wid, DateTime dateS, DateTime dateE) {
    String id = _firebaseAuth.currentUser!.uid;
    DateTime checkS = DateTime(dateS.year, dateS.month, dateS.day, 0, 0, 0);
    DateTime checkE = DateTime(dateE.year, dateE.month, dateE.day, 23, 59, 59);
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isGreaterThanOrEqualTo: checkS)
        .where('createAt', isLessThanOrEqualTo: checkE)
        .get();
  }

  Future<QuerySnapshot> getTransactionsBeforeDate(String wid, DateTime date) {
    String id = _firebaseAuth.currentUser!.uid;
    DateTime checkE = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isLessThanOrEqualTo: checkE)
        .get();
  }

  Future<QuerySnapshot> getTransactionsAfterDate(String wid, DateTime date) {
    String id = _firebaseAuth.currentUser!.uid;
    DateTime checkE = DateTime(date.year, date.month, date.day, 0, 0, 0);
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isGreaterThanOrEqualTo: checkE)
        .get();
  }

  Future<QuerySnapshot> getTransactionsByRangeBudget(
      String wid, DateTime dateS, DateTime dateE, String idCategory) {
    String id = _firebaseAuth.currentUser!.uid;
    DateTime checkS = DateTime(dateS.year, dateS.month, dateS.day, 0, 0, 0);
    DateTime checkE = DateTime(dateE.year, dateE.month, dateE.day, 23, 59, 59);
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isGreaterThanOrEqualTo: checkS)
        .where('createAt', isLessThanOrEqualTo: checkE)
        // .where('idCategory', isEqualTo: idCategory)
        .get();
  }

  Future<void> deleteTransaction(String wid, String tid) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    return walletSnapshot
        .doc(wid)
        .collection('transactions')
        .doc(tid)
        .delete()
        .then((value) => print("transaction deleted"))
        .catchError((error) => print("error: $error"));
  }

  Future<void> updateTransaction(
      String money,
      String note,
      String idwallet,
      String idcategory,
      DateTime dateTime,
      String event,
      String location,
      String img,
      bool type,
      String currency,
      String idtransaction) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(idwallet)
        .collection('transactions')
        .doc(idtransaction)
        .update({
          'money': currencyToInt(money),
          'description': note,
          'event': event,
          'location': location,
          'img': img,
          'idCategory': idcategory,
          'createAt': Timestamp.fromDate(dateTime),
          'type': type,
          'currency': currency,
        })
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  Future<num> subRemain(String wid) async {
    String id = _firebaseAuth.currentUser!.uid;
    num remain = 0;
    final snap = await users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .get();
    snap.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      if (data['type'] == true)
        remain += data['money'];
      else
        remain -= data['money'];
    });
    return remain;
  }

  Future<void> calculateWallet2(String wid, num total) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('wallets');
    final remain = await subRemain(wid);
    return walletSnapshot
        .doc(wid)
        .update({
          'remain': total - remain,
        })
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<void> calculateBudget(String wid, num remain) async {
    String id = _firebaseAuth.currentUser!.uid;
    final walletSnapshot = users.doc(id).collection('budgets');
    return walletSnapshot
        .doc(wid)
        .update({
          'remain': remain,
        })
        .then((_) => print('Update successfully'))
        .catchError((error) => print('Update failed: $error'));
  }

  Future<void> remainBudget(
      String idCategory, String money, DateTime date, bool check) async {
    String id = _firebaseAuth.currentUser!.uid;
    final bug = await users
        .doc(id)
        .collection('budgets')
        .where('idCategory', isEqualTo: idCategory)
        .get();
    bug.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      DateTime s = (data['startDay'] as Timestamp).toDate();
      DateTime e = (data['endDay'] as Timestamp).toDate();
      if (date.isBefore(e) && date.isAfter(s)) {
        if (check == true) {
          num moi = data['remain'] + currencyToInt(money);
          calculateBudget(element.id, moi);
        } else {
          num moi = data['remain'] - currencyToInt(money);
          calculateBudget(element.id, moi);
        }
      }
    });
  }

  Future<num> calculatorRemainBudget(
      String wid, DateTime dateS, DateTime dateE, String cid) async {
    final results = await getTransactionsByTypeRange(wid, true, dateS, dateE);
    num tong = 0;
    results.docs.forEach((element) {
      final a = element.data() as Map<String, dynamic>;
      if (a['idCategory'] == cid) {
        tong += a['money'];
      }
    });
    return tong;
  }

  Future<QuerySnapshot> getTransactionsByType(String wid, bool isEx) {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('type', isEqualTo: isEx)
        .get();
  }

  Future<QuerySnapshot> getTransactionsByTypeRange(
      String wid, bool isEx, DateTime dateS, DateTime dateE) {
    DateTime checkS = DateTime(dateS.year, dateS.month, dateS.day, 0, 0, 0);
    DateTime checkE = DateTime(dateE.year, dateE.month, dateE.day, 23, 59, 59);
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('createAt', isGreaterThanOrEqualTo: checkS)
        .where('createAt', isLessThanOrEqualTo: checkE)
        .get();
  }

  Future<QuerySnapshot> getCategories() async {
    return categories.get();
  }

  //delete category
  Future<void> deleteCategory(String cid) async {
    final walletSnapshot = categories
        .doc(cid)
        .delete()
        .then((value) => print("Wallet deleted"))
        .catchError((error) => print("error: $error"));
  }

  Future<void> deleteategoryByUser(String wid, String cid) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users
        .doc(id)
        .collection('wallets')
        .doc(wid)
        .collection('transactions')
        .where('idCategory', isEqualTo: cid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  Future<void> deleteAllTransAndCategory(String cid) async {
    String id = _firebaseAuth.currentUser!.uid;
    return users.doc(id).collection('wallets').get().then((value) {
      value.docs.forEach((element) async {
        Map<String, dynamic> data = element.data();
        await deleteategoryByUser(element.id, cid);
        await calculateWallet2(element.id, data['balance']);
      });
    });
  }
}
