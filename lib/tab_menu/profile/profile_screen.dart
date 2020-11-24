import 'package:flutter/material.dart';

import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';
import 'package:undangi/Splash_screen.dart';
import 'package:undangi/auth/login_screen.dart';
// import 'package:undangi/Constant/app_widget.dart';

import 'portfolio_view.dart';
import 'profile_view.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool tabProfil = true;
  bool loading = false;
  bool check = false;
  Map<String, dynamic> dataProfil;

  _logout() async {
    onLoading(context);

    await GeneralModel.setToken(null).then((v) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadApi();
  }

  _loadApi() async {
    loadingSet(true);
    await GeneralModel.checCk(
        //internet connect
        () {
      ProfileModel.get().then((v) {
        loadingSet(false);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            dataProfil = (v.data);
          });
        }
      });
    },
        //internet disconnect
        () {
      loadingSet(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context);
      });
    });
  }

  loadingSet(bool v) {
    setState(() {
      dataProfil = {};
      loading = v;
    });
  }

  checkData() {
    setState(() {
      check = dataProfil.containsKey('bio');
    });
    return check;
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      color: AppTheme.primaryBg,
      child: loading
          ? onLoading2()
          : ListView(
              children: [
                // header
                Stack(
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
                    //icon menu
                    Container(
                      margin: EdgeInsets.only(left: sizeu.width - 15 - 45 - 80),
                      child: PopupMenuButton(
                        child: Container(
                          width: 45,
                          height: 45,
                          margin: EdgeInsets.fromLTRB(80, 15, 15, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.primarymenu,
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        onSelected: (newValue) {
                          if (newValue == 0) {
                            Navigator.pushNamed(context, '/ganti_password');
                          } else {
                            openAlertBoxTwo(context, 'Logout!',
                                'Anda akan keluar?', 'TIDAK', 'YA', () {
                              Navigator.pop(context);
                            }, () {
                              Navigator.pop(context);
                              _logout();
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Ganti Password"),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: Text("Logout"),
                            value: 1,
                          ),
                        ],
                      ),
                    ),

                    //photo
                    Container(
                      alignment: Alignment.center,
                      height: 120,
                      width: 120,
                      margin:
                          EdgeInsets.only(top: 20, left: sizeu.width / 2 - 60),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: checkData()
                              ? NetworkImage(
                                  domainChange(dataProfil['bio']['foto']))
                              : AssetImage('assets/general/user.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ],
                ),
                //motto
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 15, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: sizeu.width - 50 - 40,
                        child: Text(
                          checkData() ? dataProfil['bio']['status'] : '-',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.geyCustom,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profil_edit')
                              .then((v) {
                            if (v) {
                              _loadApi();
                            }
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  (AssetImage('assets/more_icon/pen_edit.png')),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //tab
                Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                      bottom:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              bool kond = !tabProfil;
                              tabProfil = true;
                              if (kond) {
                                setState(() {});
                              }
                            },
                            child: Text(
                              'Profil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tabProfil
                                    ? Colors.black
                                    : AppTheme.geyCustom,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              bool kond = tabProfil;
                              tabProfil = false;
                              if (kond) {
                                setState(() {});
                              }
                            },
                            child: Text(
                              'Porfolio',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !tabProfil
                                    ? Colors.black
                                    : AppTheme.geyCustom,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                !tabProfil
                    ? PortfolioView(
                        dataPort: dataProfil['portofolio'],
                        checkData: check,
                      )
                    : ProfileView(
                        dataProfile: dataProfil,
                        checkData: check,
                        getApi: () {
                          _loadApi();
                        },
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 80),
                )
              ],
            ),
    );
  }
}
