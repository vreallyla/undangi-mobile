import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/search_box.dart';

class HomeHeaderView extends StatefulWidget {
  @override
  _HomeHeaderViewState createState() => _HomeHeaderViewState();
}

class _HomeHeaderViewState extends State<HomeHeaderView> {
  TextEditingController cariLayananInput = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        //abstract bg
        Container(
          height: sizeu.height * 2 / 5,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(60.0),
              bottomLeft: Radius.circular(60.0),
            ),
            image: DecorationImage(
              image: (AssetImage('assets/general/abstract_bg.png')),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // cowo vector
        Container(
          width: sizeu.width,
          // height: sizeu.height * 2 / 5.5,
          alignment: Alignment.bottomRight,
          child: ClipRect(
            child: Container(
              padding: EdgeInsets.only(top: 35),
              alignment: Alignment.bottomRight,
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1,
                heightFactor: 0.65,
                child: Image.asset(
                  'assets/general/cowo_berdiri.png',
                  scale: 1.3,
                ),
              ),
            ),
          ),
        ),
        // chat icon
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/chat');
          },
          child: Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 5, right: 10),
            height: 40,
            child: Image.asset(
              'assets/general/chat-shadow.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        //card biru mudah
        Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
                top: sizeu.height * 2 / 5 - 60, left: 40, right: 40),
            height: 130,
            padding: EdgeInsets.only(left: 30, right: 30, top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppTheme.softBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 140,
                  height: 50,
                  child: Text('Buat Proyek Pertama-mu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textBlue,
                      )),
                ),
                SizedBox(
                  width: 140,
                  height: 40,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {},
                    color: AppTheme.primaryBlue,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            'Buat',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        // gambar tidur
        Container(
          width: sizeu.width,
          margin: EdgeInsets.only(top: sizeu.height * 2 / 5 - 70, right: 20),
          // height: sizeu.height * 2 / 5.5,
          alignment: Alignment.bottomRight,
          child: ClipRect(
            child: Container(
              padding: EdgeInsets.only(top: 25),
              alignment: Alignment.bottomRight,
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 1,
                heightFactor: 1,
                child: Image.asset(
                  'assets/general/santuy.png',
                  // scale: 1.3,
                ),
              ),
            ),
          ),
        ),
        //text intro
        Container(
          width: sizeu.width,
          margin: EdgeInsets.only(top: sizeu.height * 2 / 5 - 200),
          // height: sizeu.height * 2 / 5.5,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 40, right: 40),
          child: SizedBox(
            width: sizeu.width - 80 - 50,
            // color: Colors.black,
            child: Text(
              'Selamat Datang Undagi',
              style: TextStyle(
                  fontSize: 33,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        //searchbox
        SearcBox(
          controll: cariLayananInput,
          marginn: EdgeInsets.only(
              top: sizeu.height * 2 / 5 - 110, left: 40, right: 40),
          paddingg: EdgeInsets.only(left: 15, right: 15),
          widthh: sizeu.width,
          heightt: 40,
          widthText: sizeu.width - 80 - 30 - 30,
          textL: 45,
          placeholder: "Cari Proyek/Layanan Baru",
          eventtChange: (v) {
            print(v);
            // v is value of textfield
          },
          eventtSubmit: (v) {
            // v is value of textfield
          },
        )
      ],
    );
  }
}
