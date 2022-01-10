import 'package:flutter/material.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/addWalletScreen/addWalletPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';

Widget itemWallets(
  Map wallet,
  UserRepository userRepository,
  BuildContext context,
) {
  return OptionContainer(
    margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
    padding: EdgeInsets.zero,
    child: ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return AddWalletPage(
              userRepository: userRepository,
              wallet: wallet,
            );
          }),
        );
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage(wallet['img']),
        radius: 20.0,
      ),
      title: Text(
        wallet['name'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(
        "${AppStyle.moneyFormat.format(wallet['remain'] ?? 0)} VNĐ",
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    ),
  );
}
