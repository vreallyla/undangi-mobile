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

  //ganti konten tab pengerjaan ke progress ketika ditekan button progress
  bool toProgress = false;

  //ganti konten tab proyek ke tambah proyek
  bool toAdd = false;

  //EDIT ID TRIGGER
  int editId = 0;

  void chageTab(bool kond) {
    setState(() {
      tabChange = kond;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    // double _width = sizeu.width;
    // double _height = sizeu.height;
    // final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return new WillPopScope(
      onWillPop: () {
        backHomeOrbackStay();
      },
      child: Scaffold(
        appBar: appBarColloring(),
        body: Container(
            child: Column(
          children: [
            // menu & photo
            appDashboard(
              context,
              'assets/general/changwook.jpg',
              condTransform() ? Text('') : menuPublik(),
              menuLeft(),
            ),
            //motto
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: SizedBox(
                // width: sizeu.width - 50 - 40,
                child: Text(
                  'Hello World, Wish me Luck Todays',
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

            //tool
            Container(
                margin: EdgeInsets.fromLTRB(
                    marginLeftRight, 5, marginLeftRight, 0),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.bgBlueSoft,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            toAdd = true;
                            tabChange = false;
                          });
                        },
                        child: Container(
                            width: 100,
                            height: 30,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                width: .5,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.plusCircle,
                                  size: 16,
                                  color: AppTheme.geySolidCustom,
                                ),
                                Text(' ' + 'TAMBAH',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.geySolidCustom,
                                    )),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        width: sizeu.width,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Cari : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.geySolidCustom,
                              ),
                            ),
                            Container(
                              height: 25,
                              width: 140,
                              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: .5,
                                  color: AppTheme.geySolidCustom,
                                ),
                                color: Colors.white,
                              ),
                              child: SizedBox(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '',
                                    suffixStyle: TextStyle(color: Colors.black),
                                    counterStyle: TextStyle(
                                      height: double.minPositive,
                                    ),
                                    counterText: "",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),

            //tab proyek
            tabChange
                ? TabPengerjaanView(
                    bottomKey: double.parse(bottom.toString()),
                    toProgress: toProgress,
                    toProgressFunc: () {
                      setState(() {
                        toProgress = !toProgress;
                      });
                    })
                : TabProyekView(
                    bottomKey: double.parse(bottom.toString()),
                    toAdd: toAdd,
                    editId: editId,
                    editEvent: (int id) {
                      editId = id;
                      setState(() {
                        
                      });
                    },
                    toAddFunc: () {
                      setState(() {
                       
                        toAdd = !toAdd;
                      });
                    }),
          ],
        )),
      ),
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

  Widget menuLeft() {
    return InkWell(
      onTap: () {
        backHomeOrbackStay();
      },
      child: Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 18,
          ),
          child: Container(
            height: 40,
            width: 40,
            child: condTransform()
                ? Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.nearlyWhite,
                    size: AppTheme.sizeIconMenu,
                  )
                : Image.asset('assets/tab_icons/tab_1s.png'),
          )),
    );
  }

  backHomeOrbackStay() {
    //pengerjaan
    if (tabChange && toProgress) {
      toProgress = !toProgress;
    }

    ///proyek
    else if (!tabChange && toAdd) {
      toAdd = !toAdd;
      editId = 0;
    } else {
      Navigator.pop(context);
    }
    setState(() {});
  }

  condTransform() {
    return (tabChange && toProgress) || (!tabChange && toAdd);
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
