import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';

class TabProyekView extends StatefulWidget {
  @override
  _TabProyekViewState createState() => _TabProyekViewState();
}

class _TabProyekViewState extends State<TabProyekView> {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);
    double imgCard = widthCard / 6;
    double heightCard = 110;
    double widthBtnShort = 85;
    double widthBtnPlay = 40;
    double widthKonten = widthCard - imgCard - widthBtnShort - widthBtnPlay - 2;

    return Container(
      child: Column(
        children: [
          //tool
          Container(
            margin:
                EdgeInsets.fromLTRB(marginLeftRight, 25, marginLeftRight, 0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.bgBlueSoft,
            ),
            child: Column(
              children: [
                //btn tool
                Container(
                    // padding: EdgeInsets.only(
                    //   left: (sizeu.width - 30) / 2 - 190,
                    //   right: (sizeu.width - 30) / 2 - 190,
                    // ),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
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
                          ],
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
          //content proyek
          Container(
            margin:
                EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
            padding: EdgeInsets.all(marginCard),
            alignment: Alignment.topLeft,
            height: sizeu.height - 380,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: .5,
                color: Colors.black,
              ),
            ),
            child:
                // Text('Belum ada data Proyek...'),
                ListView(
              children: [
                Container(
                    // height: heightCard + 55,
                    margin: EdgeInsets.only(
                      bottom: 5,
                    ),
                    padding: EdgeInsets.all(paddingCard),
                    decoration: BoxDecoration(
                      color: AppTheme.bgRedSoft,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //row image
                        Container(
                          height: imgCard,
                          width: imgCard,
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: (AssetImage(
                                  'assets/general/ilustration_desain.jpg')),
                              fit: BoxFit.fitWidth,
                            ),
                            boxShadow: [
                              //background color of box
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4, // soften the shadow
                                spreadRadius: 1, //extend the shadow
                                offset: Offset(
                                  .5, // Move to right 10  horizontally
                                  3, // Move to bottom 10 Vertically
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                'DESAIN UI',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: AppTheme.primarymenu,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //konten
                                Container(
                                  width: widthKonten,
                                  height: heightCard,
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rp5.000.000',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'KATEGORI Desain, Multimedia:',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Pembuatan Tampilan Web',
                                        style: TextStyle(
                                          color: AppTheme.primarymenu,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Lorem ipsum dolor siamet, consetetru sadipsting elitr Lorem ipsum dolor siamet,',
                                        style: TextStyle(
                                          // color: AppTheme.primarymenu,
                                          fontSize: 12,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),

                                // row shorcut
                                Container(
                                  height: heightCard,
                                  width: widthBtnShort,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          btnTool(
                                              'assets/more_icon/info.png',
                                              BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                bottomLeft:
                                                    Radius.circular(30.0),
                                              ), () {
                                            print('info');
                                          }),
                                          btnTool(
                                              'assets/more_icon/file_alt.png',
                                              BorderRadius.only(
                                                topRight: Radius.circular(30.0),
                                                bottomRight:
                                                    Radius.circular(30.0),
                                              ), () {
                                            print('info');
                                          }),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          btnTool(
                                              'assets/more_icon/edit-button.png',
                                              BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                bottomLeft:
                                                    Radius.circular(30.0),
                                              ), () {
                                            print('info');
                                          }),
                                          btnTool(
                                              'assets/more_icon/remove-file.png',
                                              BorderRadius.only(
                                                topRight: Radius.circular(30.0),
                                                bottomRight:
                                                    Radius.circular(30.0),
                                              ), () {
                                            print('info');
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                //BUTTON PLAY
                                Container(
                                  height: heightCard,
                                  width: widthBtnPlay,
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/home/circle_quatral.png'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          // borderRadius:
                                          //     BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: AppTheme.textPink,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'TOTAL BID: ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '1 ORANG  ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.primarymenu,
                                  ),
                                ),
                                Image.asset(
                                  'assets/more_icon/calender.png',
                                  width: 15,
                                  fit: BoxFit.fitWidth,
                                ),
                                Text(
                                  ' Batas Waktu: ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '7 Hari',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget btnTool(
      String locationImg, BorderRadius radius, Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: 40,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            width: .5,
            color: AppTheme.nearlyBlack,
          ),
        ),
        child: Image.asset(
          locationImg,
          alignment: Alignment.center,
          // scale: 6,
        ),
      ),
    );
  }
}
