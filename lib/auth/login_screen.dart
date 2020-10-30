import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';

import 'widget_group.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // var size = context.size;

    return Scaffold(
      bottomNavigationBar: footerView(),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            headerView('Masuk'),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 90),
              // height: 70,
              color: Colors.white,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(generalAssets + 'logo.png'),
                            fit: BoxFit.fitHeight,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(decoration: textfieldDesign('Username')),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            TextField(decoration: textfieldDesign('Password')),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: .3,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: Column(children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              color: AppTheme.primaryBlue,
                              onPressed: () {
                                Navigator.pushNamed(context, '/',
                                    arguments: {"index_route": 0});
                              },
                              child: Text(
                                'MASUK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 15)),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              color: AppTheme.white,
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: AppTheme.primaryBlue)),
                              onPressed: () {
                                // print('dasd');
                                Navigator.pushReplacementNamed(
                                    context, '/register');
                              },
                              child: Text(
                                'DAFTAR',
                                style: TextStyle(
                                    color: AppTheme.primaryBlue, fontSize: 16),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
