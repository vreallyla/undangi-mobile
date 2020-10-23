import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:undangi/Constant/app_theme.dart';

class SearchTabScreen extends StatefulWidget {
  @override
  _SearchTabScreenState createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController cariKategoriInput = new TextEditingController();
  String dropdownValue;

  // List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  // void initState() {
  //   tabIconsList.forEach((TabIconData tab) {
  //     tab.isSelected = false;
  //   });
  //       tabIconsList[0].isSelected = true;

  // }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    double defaultWidth = 411.42857142857144;
    double fontSearch = sizeu.width / defaultWidth * 12;

    double paddingWidthCard = 15;
    double marginWidthCard = 20;
    double pembatasSearch = 0;

    //search
    double widthSearhInput =
        (sizeu.width - marginWidthCard - paddingWidthCard) / 1.6;
    double widthKategoriSelect = sizeu.width -
        marginWidthCard -
        paddingWidthCard -
        widthSearhInput -
        pembatasSearch;

    //card
    double pembatasCard = 7;
    double widthCard = (sizeu.width - marginWidthCard - pembatasCard) / 2;

    return Scaffold(
      appBar: appPolosBack(paddingPhone, () {
        Navigator.pop(context);
      }),
      body: Container(
        color: AppTheme.primaryBg,
        margin: EdgeInsets.fromLTRB(
            marginWidthCard / 2, 20, marginWidthCard / 2, 20),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            //search bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearcBox(
                  iconWidth: 10,
                  fontSize: fontSearch,
                  controll: cariKategoriInput,
                  marginn: EdgeInsets.only(
                      bottom: 20,
                      left: paddingWidthCard / 2,
                      right: paddingWidthCard / 2),
                  paddingg: EdgeInsets.only(left: 10, right: 10),
                  widthh: widthSearhInput,
                  heightt: 50,
                  widthText: widthSearhInput - 50,
                  textL: 45,
                  radiusBorder: 30,
                  placeholder: "Cari Kategori yang anda inginkan",
                  eventtChange: (v) {
                    print(v);
                    // v is value of textfield
                  },
                  eventtSubmit: (v) {
                    // v is value of textfield
                  },
                ),
                Container(
                  width: widthKategoriSelect,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  height: 50,
                  margin: EdgeInsets.only(left: pembatasSearch),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      hint: Text('Proyek/Layanan',
                          style: TextStyle(
                              color: AppTheme.textBlue, fontSize: fontSearch)),
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: <String>[
                        'Proyek',
                        'Layanan',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(
                                  color: AppTheme.textBlue,
                                  fontSize: fontSearch)),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //animasi
                  Container(
                    width: widthCard,
                    margin: EdgeInsets.only(right: pembatasCard),
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppTheme.geySolidCustom, width: 1),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: widthCard / 1.6,
                            height: widthCard / 1.6,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (AssetImage(
                                    'assets/kategori_icon/animasi.png')),
                                fit: BoxFit.fitWidth,
                              ),
                            )),
                        Text(
                          'ANIMASI, AUDIO, VIDEO',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  //bisnis
                  Container(
                    width: widthCard,
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppTheme.geySolidCustom, width: 1),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: widthCard / 1.6,
                            height: widthCard / 1.6,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (AssetImage(
                                    'assets/kategori_icon/bisnis.png')),
                                fit: BoxFit.fitWidth,
                              ),
                            )),
                        Text(
                          'BISNIS & PEMASARAN',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
