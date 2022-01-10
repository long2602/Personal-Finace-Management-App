import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loda_app/src/blocs/account_bloc.dart';
import 'package:loda_app/src/blocs/tab_bloc.dart';
import 'package:loda_app/src/constants/app_style.dart';
import 'package:loda_app/src/constants/app_ui.dart';
import 'package:loda_app/src/events/account_event.dart';
import 'package:loda_app/src/events/tab_event.dart';
import 'package:loda_app/src/states/account_state.dart';
import 'package:loda_app/src/widgets/OptionContain_widget.dart';
import 'package:loda_app/src/widgets/buttons/appBarBtn.dart';
import 'package:loda_app/src/widgets/generalAppbar.dart';
import 'package:loda_app/src/widgets/inputNoLabel.dart';
import 'package:loda_app/src/widgets/snackBar.dart';
import 'package:path/path.dart' as Path;

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? imgPath;
  String imgUrl = "";
  // late AccountBloc _accountBloc;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _accountBloc = BlocProvider.of<AccountBloc>(context);
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);

      // final imgPermanent = await saveImage(image.path);
      setState(() {
        this.imgPath = imageTemporary;
      });
      print(imgPath!.path);
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

  Future uploadImage() async {
    if (imgPath == null) return;
    final filename = Path.basename(imgPath!.path);
    final destination = filename;
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final task = ref.putFile(imgPath!);
      final snapshot = await task.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      setState(() {
        imgUrl = url;
      });
    } on FirebaseException catch (_) {
      return null;
    }
  }

  //chọn kiểu chọn ảnh
  Future _selectPhoto(BuildContext context) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyle.lightColor,
                      borderRadius: AppStyle.mainBorder,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera),
                          title: Text("Camera"),
                          onTap: () {
                            Navigator.of(context).pop();
                            pickImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.image),
                          title: Text("Gallery"),
                          onTap: () {
                            Navigator.of(context).pop();
                            pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                      borderRadius: AppStyle.mainBorder,
                      child: MaterialButton(
                        minWidth: double.infinity,
                        color: AppStyle.blueColor,
                        elevation: 0,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppStyle.lightColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        _nameController.text = state.user.name;
        _emailController.text = state.user.email;
        imgUrl = state.user.img!;
        if (state is AccountStateLoadding) {
          WidgetsBinding.instance!.addPostFrameCallback(
              (_) => loadingIndicator(context, "Loading..."));
        } else if (state is AccountStateUpdate) {
          WidgetsBinding.instance!.addPostFrameCallback(
              (_) => createSnackBar("Updated successfully", context));
        }
        return Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          appBar: GeneralAppbar(
            "My Account",
            AppBarBtn(
              onPressed: () {
                Navigator.pop(context, true);
              },
              isAlign: true,
              icon: Icons.arrow_back_rounded,
            ),
            SizedBox(
              width: 45.w,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppStyle.mainPadding),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      width: double.infinity,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectPhoto(context),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppStyle.blueColor,
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: imgPath == null
                                    ? (state.user.img!.isNotEmpty
                                        ? Image.network(
                                            state.user.img!,
                                            height: 220,
                                            width: 220,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            AppUI.ava1,
                                            height: 220,
                                            width: 220,
                                            fit: BoxFit.cover,
                                          ))
                                    : Image.file(
                                        imgPath!,
                                        height: 220,
                                        width: 220,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    OptionContainer(
                      width: double.infinity,
                      child: Form(
                        child: Column(
                          children: [
                            InputNoLabel(
                              text: state.user.name,
                              type: TextInputType.text,
                              isEnable: true,
                              controller: _nameController,
                            ),
                            InputNoLabel(
                              text: state.user.email,
                              type: TextInputType.emailAddress,
                              isEnable: false,
                              controller: _emailController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: ClipRRect(
                        borderRadius: AppStyle.mainBorder,
                        child: MaterialButton(
                          minWidth: double.infinity,
                          color: AppStyle.blueColor,
                          elevation: 0,
                          onPressed: () async {
                            await uploadImage();
                            BlocProvider.of<AccountBloc>(context).add(
                                AccountEventUpdatePress(
                                    imgPath: imgUrl,
                                    name: _nameController.text));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppStyle.lightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void loadingIndicator(BuildContext context, String title) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            content: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        });
  }
}
