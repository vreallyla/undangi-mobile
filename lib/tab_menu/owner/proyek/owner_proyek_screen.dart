import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

import 'tab_pengerjaan_view.dart';
import 'tab_proyek_view.dart';

class OwnerProyekScreen extends StatefulWidget {
  @override
  _OwnerProyekScreenState createState() => _OwnerProyekScreenState();
}

class _OwnerProyekScreenState extends State<OwnerProyekScreen> {
  bool tabChange = false; //false=proyek;true=pengerjaan

  void chageTab(bool kond) {
    setState(() {
      tabChange = kond;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    // double _width = sizeu.width;
    // double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: appBarColloring(),
      body: Container(
          child: Column(
        children: [
          // menu & photo
          appDashboard(
            context,
            'assets/general/changwook.jpg',
            menuPublik(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(
                    left: 15,
                    top: 18,
                  ),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (AssetImage('assets/tab_icons/tab_1s.png')),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )),
            ),
          ),
          //motto
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: SizedBox(
              // width: sizeu.width - 50 - 40,
              child: Text(
                'Hello World, Wish me Luck Today',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.geyCustom,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),

          // tab,
          tabHead(),
          //tab proyek
          tabChange ? TabPengerjaanView() : TabProyekView(),
        ],
      )),
    );
  }

  Widget menuPublik() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        left: sizeu.width - 15 - 45 - 80,
      ),
      child: PopupMenuButton(
        child: Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.fromLTRB(80, 15, 15, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.primarymenu,
          ),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
        onSelected: (newValue) {
          if (newValue == 0) {
            // Navigator.pushNamed(context, '/ganti_password');
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Tampilan Publik"),
            value: 0,
          ),
        ],
      ),
    );
  }

  Widget tabHead() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
          bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
        ),
      ),
      child: Row(
        children: [
          //tab proyek
          InkWell(
            onTap: () {
              chageTab(false);
            },
            child: Container(
              width: sizeu.width / 2,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 120,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: !tabChange ? 0.5 : 0,
                        color: !tabChange
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 22,
                    ),
                    Text(
                      'PROYEK',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('99+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // tab pengerjaan
          InkWell(
            onTap: () {
              chageTab(true);
            },
            child: Container(
              width: sizeu.width / 2,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 171,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange ? 0.5 : 0,
                        color: tabChange
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.briefcase,
                      size: 18,
                    ),
                    Text(
                      'PENGERJAAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('99+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
