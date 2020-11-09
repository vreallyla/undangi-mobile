import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/tab_menu/frelencer/proyek/proyek_list_frelence_tab.dart';

class ProyekFrenlenceScreen extends StatefulWidget {
  @override
  _ProyekFrenlenceScreenState createState() => _ProyekFrenlenceScreenState();
}

class _ProyekFrenlenceScreenState extends State<ProyekFrenlenceScreen> {
  int tabChange = 0; //0=bid;1=undangan;2=pengerjaan

  void chageTab(int kond) {
    setState(() {
      tabChange = kond;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double _width = sizeu.width;
    double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;


    return Scaffold(
      appBar: appBarColloring(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // menu & photo
        appDashboard(
          context,
          'assets/general/changwook.jpg',
          menuPublik(),
          menuLeft(),
        ),
        //motto
        Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          width: _width,
          child: Text(
            'Hello World, Wish Me Luck Today!',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.geyCustom,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // tab,
        tabHead(),

        //tool
        Container(
            margin: EdgeInsets.fromLTRB(marginLeftRight, 5, marginLeftRight, 0),
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
                        // toAdd = true;
                        // tabChange = false;
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
                            Text('' + 'TAMBAH',
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

        ProyekListFrelenceTab(
          bottomKey: double.parse(bottom.toString()),
                    toAdd: false,
                    editId: 0,
                    editEvent: (int id) {
                    
                      setState(() {
                        
                      });
                    },
                    toAddFunc: () {
                      setState(() {
                       
                        
                      });
                    }),
        
      
      ]),
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
            child: Image.asset('assets/tab_icons/tab_1s.png'),
          )),
    );
  }

  Widget tabHead() {
    final sizeu = MediaQuery.of(context).size;
    double sisaTab = sizeu.width - 60 - 101 - 121;
    double tabsisaBagi = sisaTab / 4;

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
          //tab bid

          InkWell(
            onTap: () {
              chageTab(0);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 60,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 60,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 0 ? 0.5 : 0,
                        color: tabChange == 0
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'BID',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('99+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //undangan
          InkWell(
            onTap: () {
              chageTab(1);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 101,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 101,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 1 ? 0.5 : 0,
                        color: tabChange == 1
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'UNDANGAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('99+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //PENGERJAAN
          InkWell(
            onTap: () {
              chageTab(2);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 122,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 122,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 2 ? 0.5 : 0,
                        color: tabChange == 2
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'PENGERJAAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('99+',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
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
