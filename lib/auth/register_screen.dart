import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';

import 'widget_group.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // var size = context.size;

    return Scaffold(
      bottomNavigationBar: footerView(),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            headerView('Daftar'),
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
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(generalAssets + 'logo.png'),
                            fit: BoxFit.fitHeight,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                generalAssets + 'kartun_jendela.png'),
                            fit: BoxFit.fitHeight,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextField(
                                decoration: textfieldDesign('Nama Lengkap')),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            TextField(decoration: textfieldDesign('Username')),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            TextField(decoration: textfieldDesign('Email')),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            TextField(decoration: textfieldDesign('Password')),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            TextField(
                                decoration: textfieldDesign('Ulangi Password')),
                            // Padding(padding: EdgeInsets.only(top: 5)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 15),
                        child: Column(children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              color: AppTheme.primaryBlue,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text(
                                'DAFTAR',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Sudah Punya akun? '),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                  child: Text('Masuk',
                                      style: TextStyle(
                                          color: AppTheme.primaryBlue)),
                                )
                              ],
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
