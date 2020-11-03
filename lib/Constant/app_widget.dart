import 'package:flutter/material.dart';

import 'app_theme.dart';

Widget appBarColloring() {
  return PreferredSize(
      preferredSize: Size.fromHeight(0.0),
      child: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryBlue,
      ));
}

Widget appPolosBack(paddingPhone, Function event) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70.0),
    child: AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(60),
        ),
      ),
      backgroundColor: AppTheme.primaryBlue,

      automaticallyImplyLeading: false, // hides leading widget
      flexibleSpace: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: paddingPhone.top, left: 10),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.primaryWhite,
            size: AppTheme.sizeIconMenu,
          ),
          // color: Colors.white,
          onPressed: () {
            event();
          },
        ),
      ),
    ),
  );
}

Widget appActionHead(paddingPhone, String judul, String textAct,
    Function backEvent, Function actEvent) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70.0),
    child: AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(60),
        ),
      ),
      backgroundColor: AppTheme.primaryBlue,

      automaticallyImplyLeading: false, // hides leading widget
      flexibleSpace: Stack(
        children: [
          //batal
          InkWell(
            onTap: () => backEvent(),
            child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(bottom: paddingPhone.top, left: 20),
                child: Text('Batal',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ))),
          ),
          //simpan
          InkWell(
            onTap: () => actEvent(),
            child: Container(
              // width: sizeu.width,
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(bottom: paddingPhone.top, right: 20),
              child: Text(
                textAct,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          //title
          Container(
            // width: sizeu.width,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
              bottom: paddingPhone.top - 2,
            ),
            child: Text(
              judul,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget appDashboard(context, String photo, Widget btnMenu, Widget btnLeft) {
  final sizeu = MediaQuery.of(context).size;

  return Stack(
    children: [
      //bg
      Container(
        height: 80,
        width: sizeu.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
          color: AppTheme.primaryBlue,
        ),
      ),
      //icon right
      btnMenu,
      //icon left
      btnLeft,
      //photo
      Container(
        alignment: Alignment.center,
        height: 120,
        width: 120,
        margin: EdgeInsets.only(top: 20, left: sizeu.width / 2 - 60),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (AssetImage(photo)),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.circular(60),
        ),
      ),
    ],
  );
}
