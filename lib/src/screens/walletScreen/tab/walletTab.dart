import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/repositories/user_repository.dart';
import 'package:loda_app/src/screens/addWalletScreen/addWalletPage.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/itemWallet.dart';

class WalletTab extends StatefulWidget {
  final UserRepository _userRepository;
  const WalletTab({
    Key? key,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(key: key);

  @override
  _WalletTabState createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    print('intil tab');
  }

  @override
  Widget build(BuildContext context) {
    print("builf tab wallet");
    return FutureBuilder<QuerySnapshot>(
      future: _userRepository.getListWalletSnapshot(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            final List storedocs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storedocs.add(a);
              a['id'] = document.id;
            }).toList();
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OptionContainer(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.asset(AppUI.wallet2x),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 18),
                            child: AutoSizeText(
                              "Create your own wallet.\nEasily manage different wallets for easier management of revenue and spending.",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: AutoSizeText(
                        "Wallet in use",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: storedocs.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return Slidable(
                          child: itemWallets(
                              storedocs[index], _userRepository, context),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: [
                            IconSlideAction(
                              onTap: () => _deleteDialog(
                                  context, storedocs[index]['id']),
                              color: Color(0xfff1f4f8),
                              iconWidget: Padding(
                                padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: AppStyle.mainBorder),
                                  child: Icon(
                                    Icons.delete,
                                    color: AppStyle.lightColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AddWalletPage(
                                userRepository: _userRepository,
                              );
                            }));
                          },
                          borderRadius: AppStyle.mainBorder,
                          splashColor: AppStyle.blueColor,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: DottedDecoration(
                              borderRadius: AppStyle.mainBorder,
                              shape: Shape.box,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Icon(
                                    FontAwesomeIcons.wallet,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    "Add New Wallet",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text('no data');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _deleteDialog(BuildContext context, String wid) async {
    await showDialog(
      context: context,
      builder: (BuildContext context1) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppUI.walletWarning2x,
                width: 100.w,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 22),
                child: Text(
                  "Deleting this wallet will also, delete all transactions under this wallet. Deleted data cannot be recovered. Are you sure you want to proceed?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.backgroundColor,
                          elevation: 0,
                          onPressed: () => Navigator.pop(context1),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.hintTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.blueColor,
                          elevation: 0,
                          onPressed: () {
                            _userRepository.deleteAllTrans(wid);
                            _userRepository.deleteWallet(wid);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.lightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppStyle.mainBorder),
      ),
      barrierDismissible: false,
    );
  }
}
