import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:undangi/Model/general_model.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  String token;

  bool showVersion = false;

  String imgLoc = "assets/general/logo_circle.png";

  double heightImg = 0;
  double widthImg = 0;
  double marginLe = 0;

  // AnimationController animationController;
  // Animation<double> animation;

  // startTime(bool kond) async {
  //   var _duration = new Duration(seconds: 0);
  //   return new Timer(_duration, navigationPage(kond));
  // }

  navigationPage(kond) {
    // Navigator.of(context).pushReplacementNamed(PAY_TM);
    if (kond) {
      Navigator.pushNamed(context, '/home', arguments: {"index_route": 0});
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  _tokenCheck() async {
    await GeneralModel.token().then((v) {
      navigationPage(v.res != null);
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () {
      final sizeu = MediaQuery.of(context).size;
      setState(() {
        heightImg = 60;
        widthImg = 60;
        marginLe = sizeu.width / 2 - 20;
      });
      Future.delayed(Duration(milliseconds: 1500), () {
        setState(() {
          imgLoc = "assets/general/logo.png";
          marginLe = sizeu.width / 2 - 100;
        });
        Future.delayed(Duration(milliseconds: 1000), () {
          setState(() {
            showVersion = true;

            Future.delayed(Duration(milliseconds: 500), () {
              _tokenCheck();
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          AnimatedContainer(
            margin: EdgeInsets.only(top: sizeu.height / 2 - 20, left: marginLe),
            duration: Duration(milliseconds: 1500),
            height: heightImg,
            curve: Curves.fastOutSlowIn,
            child: Image.asset(
              imgLoc,
              height: heightImg,
              fit: BoxFit.fitHeight,
            ),
          ),
          !showVersion
              ? Container()
              : Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Text('Version 1.0'),
                )
        ]));
  }
}
