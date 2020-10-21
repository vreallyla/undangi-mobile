import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';

import 'user_card_view.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    TextEditingController cariUserInput = new TextEditingController();

    return Scaffold(
        appBar: appPolosBack(paddingPhone, () {
          Navigator.pop(context);
        }),
        body: Container(
          color: AppTheme.primaryBg,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              //search bar
              SearcBox(
                controll: cariUserInput,
                marginn: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                paddingg: EdgeInsets.only(left: 15, right: 15),
                widthh: sizeu.width - 60 - 30 - 30 - 20,
                heightt: 50,
                widthText: sizeu.width - 80 - 30 - 30,
                textL: 45,
                placeholder: "Cari Pekerjaan yang Anda Inginkan",
                eventtChange: (v) {
                  print(v);
                  // v is value of textfield
                },
                eventtSubmit: (v) {
                  // v is value of textfield
                },
              ),
              Row(
                children: [
                  //card
                  UserCardView(),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  UserCardView(),
                ],
              )
            ],
          ),
        ));
  }
}
