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

    return Container(
      child: Column(
        children: [
          //tool
          Container(
            margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 85,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    btnTool(
                      'EXCEL',
                      FaIcon(
                        FontAwesomeIcons.fileExcel,
                        size: 16,
                        color: AppTheme.geySolidCustom,
                      ),
                      BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                      90,
                    ),
                    btnTool(
                      'TAMBAH',
                      FaIcon(
                        FontAwesomeIcons.plusCircle,
                        size: 16,
                        color: AppTheme.geySolidCustom,
                      ),
                      BorderRadius.circular(0),
                      100,
                    ),
                    btnTool(
                      'CETAK',
                      FaIcon(
                        FontAwesomeIcons.print,
                        size: 16,
                        color: AppTheme.geySolidCustom,
                      ),
                      BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      90,
                    )
                  ],
                )),
                Container(
                  width: sizeu.width,
                  padding: EdgeInsets.only(
                    right: (sizeu.width - 30) / 2 - 140,
                    top: 10,
                  ),
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
                )
              ],
            ),
          ),
          //content proyek
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            height: sizeu.height - 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: .5,
                color: Colors.black,
              ),
            ),
            child: Text('Belum ada data Proyek...'),
          ),
        ],
      ),
    );
  }

  Widget btnTool(String text, FaIcon iconn, BorderRadius radius, double width) {
    return Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            width: .5,
            color: AppTheme.geySolidCustom,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconn,
            Text(' ' + text,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.geySolidCustom,
                )),
          ],
        ));
  }
}
