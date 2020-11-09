import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

Widget appBackWithPhoto(context, String photo) {
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

      //icon left
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
              child: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.nearlyWhite,
                size: AppTheme.sizeIconMenu,
              ),
            )),
      ),
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

openAlertBox(context,String title, String sub, String textBtn,Function eventButton) {
  Color myColor = Colors.green;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xfff7f7f7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 400.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.times,
                          color: AppTheme.geyCustom,
                          size: 16,
                        ))),
                Container(
                  width: 80,
                  height: 83,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (AssetImage('assets/general/notice_dung.jpeg')),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                 title,
                  style:
                      TextStyle(fontSize: 20, color: AppTheme.geySolidCustom),
                  textAlign: TextAlign.center,
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 14, color: AppTheme.geyCustom),
                  textAlign: TextAlign.center,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  child: RaisedButton(
                    color: AppTheme.primarymenu,
                    onPressed: () {
                      eventButton();
                    },
                    child: Text(
                      textBtn,
                      style: TextStyle(
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

openAlertBoxTwo(context,String title, String sub, 
String leftText,String rightText,
Function eventLeft, Function eventRight) {
 
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xfff7f7f7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 400.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(right: 20),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: FaIcon(
                          FontAwesomeIcons.times,
                          color: AppTheme.geyCustom,
                          size: 16,
                        ))),
                Container(
                  width: 80,
                  height: 83,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (AssetImage('assets/general/notice_dung.jpeg')),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                 title,
                  style:
                      TextStyle(fontSize: 20, color: AppTheme.geySolidCustom),
                  textAlign: TextAlign.center,
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 14, color: AppTheme.geyCustom),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: RaisedButton(
                          color: AppTheme.geyCustom,
                          onPressed: () {
                            eventLeft();
                          },
                          child: Text(
                            leftText,
                            style: TextStyle(
                              color: AppTheme.nearlyWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                                            child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: RaisedButton(
                          color: AppTheme.primarymenu,
                          onPressed: () {
                            eventRight();
                          },
                          child: Text(
                            rightText,
                            style: TextStyle(
                              color: AppTheme.nearlyWhite,
                            ),
                          ),
                        ),
                    ),
                     ),
                  
                  ],
                ),
              ],
            ),
          ),
        );
      });
}


passwordCheck(context, Function checkEvent) {
  Color myColor = AppTheme.bgChatBlue;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: 80,
                            child: Image.asset(
                              'assets/general/logo.png',
                              width: 80,
                              fit: BoxFit.fitWidth,
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 8),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: FaIcon(
                                  FontAwesomeIcons.times,
                                  size: 14,
                                )),
                          )),
                    ],
                  ),
                ),
                Container(
                  height: 5.0,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(.1), width: .5))),
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      // border: Border(
                      // bottom: BorderSide(width: .5,color: Colors.grey.withOpacity(.5))
                      // ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.5),
                            blurRadius: 3.0,
                            offset: Offset(0.0, 0.75))
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                  child: Text('Password'),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15),
                    child: TextField(
                      obscureText: true,
                      style: TextStyle(fontSize: 12, height: 1),
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Masukkan Password",
                          fillColor: Colors.white70),
                    )),
                InkWell(
                  onTap: ()=>checkEvent(),
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: myColor,
                    ),
                    child: Text(
                      "CHECK",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

sampleOpenAlertBox(context) {
  Color myColor = Colors.green;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Rate",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                        Icon(
                          Icons.star_border,
                          color: myColor,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Add Review",
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "Rate Product",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
