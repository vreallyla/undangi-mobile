import 'package:flutter/material.dart';

import 'package:undangi/Constant/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      color: AppTheme.primaryBg,
      child: ListView(
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
                    }else{
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    LoginScreen()), (Route<dynamic> route) => false);
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
                margin: EdgeInsets.only(top: 20, left: sizeu.width / 2 - 60),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (AssetImage('assets/general/changwook.jpg')),
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
                    'Hello World, Wish me Luck Today',
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
                    Navigator.pushNamed(context, '/profil_edit');
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (AssetImage('assets/more_icon/pen_edit.png')),
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
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
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
                          color: tabProfil ? Colors.black : AppTheme.geyCustom,
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
                          color: !tabProfil ? Colors.black : AppTheme.geyCustom,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          !tabProfil ? PortfolioView() : ProfileView(),
        ],
      ),
    );
  }
}
