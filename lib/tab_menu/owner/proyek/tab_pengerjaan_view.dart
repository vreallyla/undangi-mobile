import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class TabPengerjaanView extends StatefulWidget {
   const TabPengerjaanView({Key key, this.bottomKey =0,this.toProgress,this.toProgressFunc}) : super(key: key);

  final double bottomKey;
  final Function toProgressFunc;
  final bool toProgress;
  @override
  _TabPengerjaanViewState createState() => _TabPengerjaanViewState();
}

class _TabPengerjaanViewState extends State<TabPengerjaanView> {
 

  changeToProgress() {
    widget.toProgressFunc();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    double marginLeftRight = 10;
    double marginCard = 5;
    final heightKey = MediaQuery.of(context).viewInsets;


    return Container(
      child: Column(
        children: [
         
          //content proyek
//
         (widget.toProgress? Container(
            height:sizeu.height - 350-widget.bottomKey,
            child: ListView(
              children: [progressScreen(marginLeftRight, marginCard, _width)],
            ),
          ):
          pengejaanList(sizeu, marginLeftRight, marginCard)),
        ],
      ),
    );
  }
  

  Widget progressScreen(marginLeftRight, marginCard, _width) {
    return Container(
      margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
      padding: EdgeInsets.all(marginCard),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: .5,
          color: Colors.black,
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          color: AppTheme.bgBlue2Soft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset('assets/general/ilustration_desain.jpg'),
                ),
                Container(
                  width: _width - 121,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //judul

                      RichText(
                        text: TextSpan(
                          text: 'UI UX DESIGN ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppTheme.primarymenu,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '7 DAY',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //harga
                      RichText(
                          text: TextSpan(
                        text: 'Rp5.000.000',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: AppTheme.nearlyBlack,
                        ),
                      )),

                      //status
                      InkWell(
                                              child: Container(
                          margin: EdgeInsets.only(top: 3),
                          width: 150,
                          decoration: BoxDecoration(
                            color: AppTheme.primarymenu,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Menunggu Konfirmasi',
                            style: TextStyle(
                              color: AppTheme.nearlyWhite,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // progress
                      progressBar(_width - 121 - 50, 30),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                  width: 1,
                  color: AppTheme.primarymenu,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget progressBar(double width, double persen) {
    double marginLeft = 3;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 3, left: marginLeft),
            child: Text(
              'PROGRESS PEKERJAAN ANDA',
              style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.geySolidCustom,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            height: 50,
            child: Stack(
              children: [
                //putih
                Container(
                  margin: EdgeInsets.only(left: marginLeft),
                  height: 30,
                  width: width,
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),

                //biru
                Container(
                  margin: EdgeInsets.only(left: marginLeft),
                  height: 30,
                  width: width * persen / 100,
                  decoration: BoxDecoration(
                    color: AppTheme.primarymenu,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: AppTheme.nearlyWhite,
                    ),
                  ),
                ),

                // pparams
                Container(
                  margin: EdgeInsets.only(top: 33, left: marginLeft),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //25
                      Container(
                        height: 7,
                        width: width * 25 / 100,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                            top: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                          ),
                        ),
                      ),
                      //50
                      Container(
                        height: 7,
                        width: width * 25 / 100,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                            top: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                          ),
                        ),
                      ),
                      //75
                      Container(
                        height: 7,
                        width: width * 25 / 100,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                            top: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                          ),
                        ),
                      ),
                      //100
                      Container(
                        height: 7,
                        width: width * 25 / 100,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                            right: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                            top: BorderSide(
                                width: .5, color: AppTheme.geySolidCustom),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //0%
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    '0%',
                    style: TextStyle(fontSize: 11, color: AppTheme.primarymenu),
                  ),
                ),
                //25%
                Container(
                  margin: EdgeInsets.only(top: 40, left: width * 24 / 100),
                  child: Text(
                    '25%',
                    style: TextStyle(fontSize: 11, color: AppTheme.primarymenu),
                  ),
                ),
                //50%
                Container(
                  margin: EdgeInsets.only(top: 40, left: width * 48 / 100),
                  child: Text(
                    '50%',
                    style: TextStyle(fontSize: 11, color: AppTheme.primarymenu),
                  ),
                ),
                //75%
                Container(
                  margin: EdgeInsets.only(top: 40, left: width * 73 / 100),
                  child: Text(
                    '75%',
                    style: TextStyle(fontSize: 11, color: AppTheme.primarymenu),
                  ),
                ),
                //75%
                Container(
                  margin:
                      EdgeInsets.only(top: 40, left: width - (width * 3 / 100)),
                  child: Text(
                    '100%',
                    style: TextStyle(fontSize: 11, color: AppTheme.primarymenu),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pengejaanList(sizeu, double marginLeftRight, double marginCard) {
    return Container(
      margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
      padding: EdgeInsets.fromLTRB(marginCard, marginCard, marginCard, 1),
      alignment: Alignment.topLeft,
      height: sizeu.height - 350-widget.bottomKey,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: .5,
          color: Colors.black,
        ),
      ),
      child:
          // Text('Belum ada data Proyek...'),
          ListView(
        children: [
          TabPengerjaanCard(
            marginLeftRight: marginLeftRight,
            marginCard: marginCard,
            changeProgress:(){
              changeToProgress();
            },
          ),
        ],
      ),
    );
  }
}

class TabPengerjaanCard extends StatelessWidget {
  const TabPengerjaanCard({
    Key key,
    this.marginLeftRight: 0,
    this.marginCard: 0,
    this.changeProgress,
  }) : super(key: key);

  final double marginLeftRight;
  final double marginCard;
  final Function() changeProgress;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);

    return Container(
        // height: heightCard + 20,
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        padding: EdgeInsets.all(paddingCard),
        decoration: BoxDecoration(
          color: AppTheme.bgBlue2Soft,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headCard(context, paddingCard, widthCard),
            komenCard(context, paddingCard, widthCard),
          ],
        ));
  }

  Widget headCard(context, double paddingCard, double widthCard) {
    double imgCard = widthCard / 6;
    double heightCard = 90;
    double widthBtnShort = 100;

    double widthKonten = widthCard - imgCard - widthBtnShort - 2;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //row image
              Container(
                height: imgCard,
                width: imgCard,
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        (AssetImage('assets/general/ilustration_desain.jpg')),
                    fit: BoxFit.fitWidth,
                  ),
                  boxShadow: [
                    //background color of box
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4, // soften the shadow
                      spreadRadius: 1, //extend the shadow
                      offset: Offset(
                        .5, // Move to right 10  horizontally
                        3, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
              ),
              //kontent
              Container(
                width: widthKonten,
                height: heightCard,
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: Text(
                        'DESAIN UI',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppTheme.primarymenu,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Rp5.000.000',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      'KATEGORI Desain, Multimedia:',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Pembuatan Tampilan Web',
                      style: TextStyle(
                        color: AppTheme.primarymenu,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              //btn
              Container(
                width: widthBtnShort,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                    btnTool('assets/more_icon/progress_bar.png',
                        BorderRadius.circular(30.0), widthBtnShort - 15, () {
                      changeProgress();
                    }),
                     InkWell(
                        onTap: () {
                          print('das');
                          openAlertBox(context);
                        },
                                          child: Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.primarymenu,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Menunggu Konfirmasi',
                          style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //informasi
          Container(
            margin: EdgeInsets.only(left: imgCard + 5),
            child: Row(
              children: [
                Text(
                  'TOTAL BID: ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '1 ORANG  ',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primarymenu,
                  ),
                ),
                Image.asset(
                  'assets/more_icon/calender.png',
                  width: 15,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  ' Batas Waktu: ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '7 Hari',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget komenCard(context, double paddingCard, double widthCard) {
    double marginLeft = widthCard / 6 / 3;
    double marginRight = 0;
    double photoWidth = 45;
    double pembatas = 4;
    double wightboder = 3;
    double btnRight = 60;
    double marginLeftKomen = 15;
    double widthSub = widthCard - marginLeft - marginLeftKomen - btnRight;
    return Container(
      margin: EdgeInsets.only(
        left: marginLeft,
        right: marginRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'PEKERJA',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //photo comment
              Container(
                alignment: Alignment.center,
                height: photoWidth,
                width: photoWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (AssetImage('assets/general/changwook.jpg')),
                    fit: BoxFit.fitWidth,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              Stack(
                children: [
                  // nama & bintang
                  Padding(
                    padding: EdgeInsets.only(left: pembatas * 2 + wightboder),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/general/user_place.png',
                              width: 12,
                              fit: BoxFit.fitWidth,
                            ),
                            Text(
                              ' Sugiono Kusuma Dewa Ringrat',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                ' 4.5',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //komen frelencer
                  Container(
                    padding: EdgeInsets.only(
                      left: pembatas,
                      top: 33,
                      bottom: 5,
                    ),
                    margin: EdgeInsets.only(left: pembatas),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            width: wightboder, color: AppTheme.geySolidCustom),
                      ),
                    ),
                    child: Text(
                      'Lorem Ipsum',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //lampiran
              SizedBox(
                width: widthCard - marginLeft - marginRight - 1 - btnRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        'LAMPIRAN HASIL PEKERJAAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 3,
                      ),
                      child: Text(
                        '(Kosong)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        'TAUTAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 3,
                        bottom: 6,
                      ),
                      child: Text(
                        'https://link.in/JdHxs12',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              // btn
              Container(
                width: btnRight,
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      btnTool('assets/more_icon/file_alt.png',
                          BorderRadius.circular(30.0), 50, () {
                        print('file');
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                        ),
                      ),
                      btnTool('assets/more_icon/cc.png',
                          BorderRadius.circular(30.0), 50, () {
                        Navigator.pushNamed(context, '/owner_proyek_payment');
                      }),
                    ]),
              ),
            ],
          ),
          //SUB KOMEN
          Container(
              margin: EdgeInsets.only(left: marginLeftKomen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'ULASAN ANDA',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //photo comment
                      Container(
                        alignment: Alignment.center,
                        height: photoWidth,
                        width: photoWidth,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/general/changwook.jpg')),
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      Stack(
                        children: [
                          // nama & bintang
                          Container(
                            width: widthSub - photoWidth,
                            padding: EdgeInsets.only(
                                left: pembatas * 2 + wightboder),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/general/user_place.png',
                                      width: 12,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    SizedBox(
                                      width: widthSub -
                                          12 -
                                          photoWidth -
                                          (pembatas * 2 + wightboder),
                                      child: Text(
                                        ' Yukna Santoso',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      Text(
                                        ' 4.5',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //komen frelencer
                          Container(
                            width: widthSub - btnRight,
                            padding: EdgeInsets.only(
                              left: pembatas,
                              top: 33,
                              bottom: 5,
                            ),
                            margin: EdgeInsets.only(left: pembatas),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: wightboder,
                                    color: AppTheme.geySolidCustom),
                              ),
                            ),
                            child: Text(
                              'Lorem Ipsum',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                      btnTool('assets/more_icon/edit-button.png',
                          BorderRadius.circular(30.0), 50, () {
                        print('komen owner');
                      }),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget btnTool(String locationImg, BorderRadius radius, double width,
      Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: width,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            width: 1,
            color: AppTheme.nearlyBlack,
          ),
        ),
        child: Image.asset(
          locationImg,
          alignment: Alignment.center,
          // scale: 6,
        ),
      ),
    );
  }
}
