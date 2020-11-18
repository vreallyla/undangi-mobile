import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/auth_model.dart';
import 'package:undangi/Model/general_model.dart';

import 'widget_group.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  var passwordNode = new FocusNode();
  var masukNode = new FocusNode();

  void _checkLogin(context, String email, String password) {
    onLoading(context);

    if (email == '' || password == '') {
      notice('Harap isi Form yang tersedia!',
          'Email atau password belum diisi...');
    } else {
      // GeneralModel.checCk(() {

      // }, () {
      //   notice('Koneksi terputus!', 'Silakan check koneksi anda...');
      // }).then((v) {
      //   print(v.res);
      // });

      AuthModel.login(email, password).then((value) {
        if (value.error) {
          notice('Terjadi kesalahan!', 'Pastikan data yang dimasukan benar...');
        } else {
          Navigator.pop(context); //pop dialog

          Navigator.pushNamed(context, '/home', arguments: {"index_route": 0});
        }
      });
    }
  }

  void notice(String label, String sub) {
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      openAlertBox(context, label, sub, 'OK', () {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // var size = context.size;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
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
                              TextField(
                                  controller: emailInput,
                                  onSubmitted: (v) => FocusScope.of(context)
                                      .requestFocus(passwordNode),
                                  decoration:
                                      textfieldDesign('Email / Username')),
                              Padding(padding: EdgeInsets.only(top: 15)),
                              TextField(
                                  focusNode: passwordNode,
                                  controller: passwordInput,
                                  onSubmitted: (v) => FocusScope.of(context)
                                      .requestFocus(masukNode),
                                  obscureText: true,
                                  decoration: textfieldDesign('Password')),
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
                                focusNode: masukNode,
                                color: AppTheme.primaryBlue,
                                onPressed: () {
                                  // Navigator.pushNamed(context, '/home',
                                  //     arguments: {"index_route": 0});
                                  _checkLogin(context, emailInput.text,
                                      passwordInput.text);
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
                                    side: BorderSide(
                                        color: AppTheme.primaryBlue)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                },
                                child: Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontSize: 16),
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
      ),
    );
  }
}
