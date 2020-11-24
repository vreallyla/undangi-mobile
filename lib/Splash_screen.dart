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

  AnimationController animationController;
  Animation<double> animation;

  startTime(bool kond) async {
    var _duration = new Duration(seconds: 0);
    return new Timer(_duration, navigationPage(kond));
  }

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
      print(v.res);
      if (v.res == null) {
        startTime(false);
      } else {
        GeneralModel.checCk(() {
          startTime(true);
        }, () {
          startTime(false);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    _tokenCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/general/logo_circle.png",
                width: animation.value * 150,
                height: animation.value * 150,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
