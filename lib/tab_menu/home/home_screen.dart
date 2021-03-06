import 'dart:io';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/tab_model.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import 'package:undangi/tab_menu/home/header_view.dart';
import 'card_menu_data.dart';
import 'content_view.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:undangi/Constant/app_theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  List<CardMenuData> cardMenuData = CardMenuData.cardMenuDataList;

  bool isNotConnect = false;
  bool isLoading = false;

  _getDataCount() async {
    GeneralModel.checCk(() {
      TabModel.homeCount().then((v) {
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            cardMenuData[0].count = v.data['proyek'];
            cardMenuData[1].count = v.data['layanan'];
            cardMenuData[2].count = v.data['frelancer'];
          });
        }
      });
    }, () {
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataCount();
  }

  @override
  void dispose() {
    print('dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: ListView(children: <Widget>[
        HomeHeaderView(),
        Container(
          margin: EdgeInsets.fromLTRB(40, 20, 40, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // judul
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Our Product',
                  style: TextStyle(
                    color: AppTheme.textBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              HomeContentView(
                  cardMenuData: cardMenuData,
                  addClick: () {},
                  changeIndex: (int index) {
                    if (index == 0) {
                      Navigator.pushNamed(context, '/proyek_list');
                    } else if (index == 1) {
                      Navigator.pushNamed(context, '/layanan_list');
                    } else if (index == 2) {
                      Navigator.pushNamed(context, '/user_list');
                    }
                  }),
            ],
          ),
        ),
      ]),
    );
  }
}
