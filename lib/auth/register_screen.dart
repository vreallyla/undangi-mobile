import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/auth_model.dart';

import 'widget_group.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController nameInput = new TextEditingController();
  TextEditingController usernameInput = new TextEditingController();
  TextEditingController passRepeatInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  var usernameNode = new FocusNode();
  var emailNode = new FocusNode();
  var passwordNode = new FocusNode();
  var passRepeatNode = new FocusNode();

  Map<String, dynamic> validation;

  void _register(context) {
    onLoading(context);

    // GeneralModel.checCk(() {

    // }, () {
    //   notice('Koneksi terputus!', 'Silakan check koneksi anda...');
    // }).then((v) {
    //   print(v.res);
    // });

    AuthModel.register(
      emailInput.text,
      nameInput.text,
      usernameInput.text,
      passwordInput.text,
      passRepeatInput.text,
    ).then((value) {
      validation = {};
      if (value.error) {
        var res = jsonDecode(value.data);

        if (res.containsKey('revisi')) {
          Navigator.pop(context);
          validation = res['message'];
        } else {
          notice('Terjadi kesalahan!', 'Coba beberapa saat lagi...');
        }
        setState(() {});
      } else {
        Navigator.pop(context); //pop dialog

        Navigator.pushReplacementNamed(context, '/home',
            arguments: {"index_route": 0});
      }
    });
  }

  void notice(String label, String sub) {
    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      openAlertBox(context, label, sub, 'OK', () {
        Navigator.pop(context);
      });
    });
  }

  Widget noticeText(trgt) {
    var kond = validation.containsKey(trgt);
    return Text(
      kond ? validation[trgt].join(', ') : '',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.red,
        fontSize: kond ? 12 : 0,
      ),
    );
  }

  void removeValidation() {
    setState(() {
      validation.removeWhere((key, value) => key == "name");
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                  onChanged: (v) => removeValidation(),
                                  controller: nameInput,
                                  onSubmitted: (v) => FocusScope.of(context)
                                      .requestFocus(usernameNode),
                                  decoration: textfieldDesign('Nama Lengkap')),
                              noticeText('name'),
                              TextField(
                                  onChanged: (v) => removeValidation(),
                                  controller: usernameInput,
                                  onSubmitted: (v) => FocusScope.of(context)
                                      .requestFocus(emailNode),
                                  decoration: textfieldDesign('Username')),
                              noticeText('username'),
                              TextField(
                                onChanged: (v) => removeValidation(),
                                controller: emailInput,
                                onSubmitted: (v) => FocusScope.of(context)
                                    .requestFocus(passwordNode),
                                decoration: textfieldDesign('Email'),
                              ),
                              noticeText('email'),
                              TextField(
                                  obscureText: true,
                                  onChanged: (v) => removeValidation(),
                                  controller: passwordInput,
                                  onSubmitted: (v) => FocusScope.of(context)
                                      .requestFocus(passRepeatNode),
                                  decoration: textfieldDesign('Password')),
                              noticeText('password'),
                              TextField(
                                  obscureText: true,
                                  onChanged: (v) => removeValidation(),
                                  controller: passRepeatInput,
                                  onSubmitted: (v) {},
                                  decoration:
                                      textfieldDesign('Ulangi Password')),
                              noticeText('password_confirmation'),
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
                                  _register(context);
                                  // Navigator.pushReplacementNamed(
                                  //     context, '/login');
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
      ),
    );
  }
}
