// ignore_for_file: non_constant_identifier_names

import 'package:loda_app/src/models/currency.dart';

class AppUI {
  static final String imagePath = "assets/images/";
  static final String iconPath1x = "assets/icons/1x/";
  static final String iconPath2x = "assets/icons/2x/";
  static final String iconPathExpense = "assets/icons/expense/";
  static final String iconPathIncome = "assets/icons/income/";

  //logo
  static final String logo = imagePath + 'logo.png';
  static final String logoRec = imagePath + 'logoRec.png';
  static final String longng = imagePath + 'longng.jpg';

  //ava
  static final String ava1 = imagePath + 'ava1.png';
  static final String ava2 = imagePath + 'ava2.png';
  static final String ava3 = imagePath + 'ava3.png';
  static final String ava4 = imagePath + 'ava4.png';
  static final String ava5 = imagePath + 'ava5.png';
  static final String ava6 = imagePath + 'ava6.png';

  //facebook
  static final String facebook = iconPath2x + 'facebook.png';
  //Google
  static final String google = iconPath2x + 'google.png';

  //wallet
  static final String wallet = iconPath1x + 'wallet.png';
  static final String wallet2x = iconPath2x + 'wallet2x.png';
  //budget
  static final String budget = iconPath1x + 'budget.png';
  static final String budget2x = iconPath2x + 'budget2x.png';
  //history/transaction
  static final String history = iconPath1x + 'history.png';
  static final String history2x = iconPath2x + 'history2x.png';

  static final String repass2x = iconPath2x + 'repass2x.png';

  static final String warning2x = iconPath2x + 'warning2x.png';
  static final String walletWarning2x = iconPath2x + 'walletwarning2x.png';

  static final String wallet1 = iconPath2x + 'wallet1.png';
  static final String wallet2 = iconPath2x + 'wallet2.png';

  static final String logout = iconPath2x + 'logout.png';

  //icon category
  //expense
  static final String Ebeauty = iconPathExpense + 'beauty.png';
  static final String Ebillfee = iconPathExpense + 'billsandfees.png';
  static final String Ecar = iconPathExpense + 'car.png';
  static final String Edrink = iconPathExpense + 'drink.png';
  static final String Eeducation = iconPathExpense + 'education.png';
  static final String Eentertainment = iconPathExpense + 'entertaiment.png';
  static final String Efood = iconPathExpense + 'food.png';
  static final String Egifts = iconPathExpense + 'gifts.png';
  static final String Egroceries = iconPathExpense + 'groceries.png';
  static final String Ehealthcare = iconPathExpense + 'healthcare.png';
  static final String Ehome = iconPathExpense + 'home.png';
  static final String Eother = iconPathExpense + 'other.png';
  static final String Eshopping = iconPathExpense + 'shopping.png';
  static final String Esportandhobbies =
      iconPathExpense + 'sportandhobbies.png';
  static final String Esupermarket = iconPathExpense + 'supermarket.png';
  static final String Etransport = iconPathExpense + 'transport.png';
  static final String Etravel = iconPathExpense + 'travel.png';
  static final String Ework = iconPathExpense + 'work.png';
  static final String Elove = iconPathExpense + 'love.png';
  static final String Ebox = iconPathExpense + 'box.png';
  static final String ECamera = iconPathExpense + 'camera.png';

  //income
  static final String Ibusiness = iconPathIncome + 'business.png';
  static final String Iextraincome = iconPathIncome + 'extraincome.png';
  static final String Igifts = iconPathIncome + 'gifts.png';
  static final String Iinsurances = iconPathIncome + 'insurance.png';
  static final String Iloan = iconPathIncome + 'loan.png';
  static final String Iother = iconPathIncome + 'other.png';
  static final String Iparentalleave = iconPathIncome + 'parentalleave.png';
  static final String Isalary = iconPathIncome + 'salary.png';

  static final List imgs = [
    AppUI.Ebeauty,
    AppUI.Ebillfee,
    AppUI.ECamera,
    AppUI.Ecar,
    AppUI.Edrink,
    AppUI.Eeducation,
    AppUI.Eentertainment,
    AppUI.Efood,
    AppUI.Egifts,
    AppUI.Egroceries,
    AppUI.Ehealthcare,
    AppUI.Ehome,
    AppUI.Eother,
    AppUI.Eshopping,
    AppUI.Esportandhobbies,
    AppUI.Esupermarket,
    AppUI.Etransport,
    AppUI.Etravel,
    AppUI.Ework,
    AppUI.Ibusiness,
    AppUI.Iextraincome,
    AppUI.Iinsurances,
    AppUI.Iloan,
    AppUI.Iparentalleave,
    AppUI.Isalary,
    AppUI.Ebox,
    AppUI.Elove,
    AppUI.wallet1,
    AppUI.wallet2
  ];

  static final List currencies = [
    new currency(name: "", unit: 23000, symbol: "USD"),
  ];
}

// assets/icons/income/business.png
// assets/icons/expense/healthcare.png

// assets\images\longng.jpg

