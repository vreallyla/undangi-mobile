import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/tab_menu/owner/proyek/sub/payment_proyek_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TabPengerjaanView extends StatefulWidget {
  const TabPengerjaanView({
    Key key,
    this.paddingTop,
    this.waktuLoadRepeat,
    this.pauseLoad,
    this.dataReresh,
    this.dataNext,
    this.refresh,
    this.dataPengerjaan,
    this.paddingBottom,
    this.loading,
    this.bottomKey = 0,
    this.toProgress,
    this.toProgressFunc,
  }) : super(key: key);

  final double bottomKey;
  final RefreshController refresh;
  final List dataPengerjaan;
  final double paddingTop;
  final double paddingBottom;
  final Function toProgressFunc;
  final Function dataReresh;
  final Function dataNext;

  final Function(int waktu) waktuLoadRepeat;
  final Function(bool pauseLoad) pauseLoad;

  final bool toProgress;
  final bool loading;
  @override
  _TabPengerjaanViewState createState() => _TabPengerjaanViewState();
}

class _TabPengerjaanViewState extends State<TabPengerjaanView> {
  changeToProgress() {
    widget.toProgressFunc();
  }

  double star = 0;

  int colorChange = 0;

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
          (widget.toProgress
              ? Container(
                  height: sizeu.height -
                      310 -
                      widget.bottomKey -
                      widget.paddingBottom -
                      widget.paddingTop,
                  child: ListView(
                    children: [
                      progressScreen(marginLeftRight, marginCard, _width)
                    ],
                  ),
                )
              : pengejaanList(sizeu, marginLeftRight, marginCard)),
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
      height: sizeu.height -
          310 -
          widget.bottomKey -
          widget.paddingBottom -
          widget.paddingTop,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: .5,
          color: Colors.black,
        ),
      ),
      child: widget.loading
          ? onLoading2()
          : (widget.dataPengerjaan.length == 0
              ? dataKosong()
              : SmartRefresher(
                  header: ShimmerHeader(
                    text: Text(
                      "PullToRefresh",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    baseColor: AppTheme.bgChatBlue,
                  ),
                  footer: ShimmerFooter(
                    text: Text(
                      "PullToRefresh",
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    noMore: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "AllUserLoaded",
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                    ),
                    baseColor: AppTheme.bgChatBlue,
                  ),
                  controller: widget.refresh,
                  enablePullUp: true,
                  child: ListView.builder(
                      itemCount: widget.dataPengerjaan.length,
                      // itemExtent: 100.0,
                      itemBuilder: (c, i) {
                        return TabPengerjaanCard(
                            waktuLoadRepeat: (c) => widget.waktuLoadRepeat(c),
                            pauseLoad: (c) => widget.pauseLoad(c),
                            marginLeftRight: marginLeftRight,
                            marginCard: marginCard,
                            changeProgress: () {
                              changeToProgress();
                            },
                            star: star,
                            data: widget.dataPengerjaan[i],
                            index: i,
                            starEvent: (double st) {
                              star = st;
                              setState(() {});
                            });
                      }),
                  onRefresh: widget.dataReresh,
                  onLoading: widget.dataNext,
                )),

      // Text('Belum ada data Proyek...'),
      //     ListView(
      //   children: [
      //     TabPengerjaanCard(
      //         marginLeftRight: marginLeftRight,
      //         marginCard: marginCard,
      //         changeProgress: () {
      //           changeToProgress();
      //         },
      //         star: star,
      //         starEvent: (double st) {
      //           star = st;
      //           setState(() {});
      //         }),
      //   ],
      // ),
    );
  }
}

int colorChange = 0;

class TabPengerjaanCard extends StatelessWidget {
  const TabPengerjaanCard({
    Key key,
    this.data,
    this.index,
    this.waktuLoadRepeat,
    this.pauseLoad,
    this.marginLeftRight: 0,
    this.marginCard: 0,
    this.changeProgress,
    this.star,
    this.starEvent,
  }) : super(key: key);

  final double marginLeftRight;
  final double marginCard;
  final Map data;
  final int index;
  final Function() changeProgress;
  final Function(double st) starEvent;

  final Function(int v) waktuLoadRepeat;
  final Function(bool v) pauseLoad;

  final double star;
  transColor(i) {
    int res = 0;
    if ((i + 1) % 1 == 0) {
      res = 0;
    }
    if ((i + 1) % 2 == 0) {
      res = 1;
    }
    if ((i + 1) % 3 == 0) {
      res = 2;
    }
    if ((i + 1) % 4 == 0) {
      res = 3;
    }
    return res;
  }

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
          color: AppTheme.renoReno[transColor(index)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headCard(context, paddingCard, widthCard, data),
            komenCard(context, paddingCard, widthCard, data),
          ],
        ));
  }

  Widget headCard(context, double paddingCard, double widthCard, Map data) {
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
                child: imageLoad(data['thumbnail'], false, imgCard, imgCard),
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
                        data['judul'] ?? empty,
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
                        'Rp' + decimalPointTwo(data['harga'].toString()),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        'KATEGORI ' +
                            (data.containsKey('kategori')
                                ? data['kategori']['nama']
                                : unknown) +
                            ":",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      data.containsKey('subkategori')
                          ? data['subkategori']['nama']
                          : 'sub ' + unknown,
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
                        openAlertBox(
                            context,
                            'APAKAH ANDA YAKIN?',
                            'Untuk menyelesaikan PEKERJAAN ini',
                            'KONFIRMASI', () {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.primarymenu,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          data['pengerjaan'] != null
                              ? (data['pengerjaan']['status'] ??
                                  'belum diketahui')
                              : 'belum diketahui',
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
                  moreThan99(data['total_bid']!=null?(int.parse(data['total_bid'].toString()) ):0)+ ' ORANG  ',
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
                  pointGroup(
                          int.parse(data['waktu_pengerjaan'].toString()) ?? 0) +
                      ' Hari',
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

  komenOwner(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfff7f7f7),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 400.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'ULASAN ANDA',
                      style: TextStyle(
                        color: AppTheme.textBlue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppTheme.geyCustom),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            // padding: EdgeInsets.only(right: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: FaIcon(
                                FontAwesomeIcons.times,
                                color: AppTheme.geyCustom,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(
                            'Ratings',
                            style: TextStyle(
                              color: AppTheme.geyCustom,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: double.infinity,
                            child: RatingBar(
                              maxRating: 5,
                              onRatingChanged: (rating) => starEvent(rating),
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              halfFilledIcon: Icons.star_half,
                              isHalfAllowed: true,
                              filledColor: Colors.amber,
                              size: 36,
                            ),
                          ),
                          Text(
                            'Ulasan Anda',
                            style: TextStyle(
                              color: AppTheme.geyCustom,
                              fontSize: 18,
                            ),
                          ),
                          TextField(
                            style: TextStyle(fontSize: 12),
                            maxLines: 3,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle:
                                    new TextStyle(color: Colors.grey[800]),
                                hintText: "Ulasan",
                                fillColor: Colors.white70),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 80),
                            alignment: Alignment.topRight,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: AppTheme.bgChatBlue,
                              child: Text(
                                'Simpan',
                                style: TextStyle(color: AppTheme.nearlyWhite),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget komenCard(context, double paddingCard, double widthCard, Map data) {
    final sizeu = MediaQuery.of(context).size;

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
                  borderRadius: BorderRadius.circular(60),
                ),
                child: data['pengerjaan'].containsKey('pekerja')
                    ? imageLoad(data['pengerjaan']['pekerja']['foto'], true,
                        photoWidth, photoWidth)
                    : Image.asset(
                        'assets/general/user.png',
                        width: photoWidth,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              Stack(
                children: [
                  // nama & bintang
                  Container(
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
                              ' ' +
                                  (data['pengerjaan'].containsKey('pekerja')
                                      ? data['pengerjaan']['pekerja']['nama']
                                      : tanpaNama),
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
                                ' ' +
                                    (data['pengerjaan'].containsKey('pekerja')
                                        ? data['pengerjaan']['pekerja']
                                            ['bintang']
                                        : '0'),
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
                    width: sizeu.width - photoWidth - 74,
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
                      (data['pengerjaan'].containsKey('pekerja')
                          ? data['pengerjaan']['pekerja']['status']
                          : empty),
                      // '',
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
                        (data.containsKey('lampiran') &&
                                data['lampiran'].length > 0
                            ? data['lampiran'].length.toString() + ' lampiran'
                            : empty),
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
                      child: InkWell(
                        onTap: () async {
                          if (data['pengerjaan']!=null&&
                              data['pengerjaan']['tautan'] != null) {
                             String url = data['pengerjaan']['tautan'];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              // throw 'Could not launch $url';
                              print(url);
                            }
                          }
                        },
                        child: Text(
                          data['pengerjaan']!=null &&
                                  data['pengerjaan']['tautan'] != null
                              ? data['pengerjaan']['tautan'].toString()
                              : empty,
                          style: TextStyle(fontSize: 12,
                          color:data['pengerjaan']!=null &&
                                  data['pengerjaan']['tautan'] != null?AppTheme.bgChatBlue:Colors.black ,
                           decoration: data['pengerjaan']!=null &&
                                  data['pengerjaan']['tautan'] != null?TextDecoration.underline: TextDecoration.none,),
                        ),
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
                        waktuLoadRepeat(560);
                        pauseLoad(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentProyekScreen(
                              proyekId: data['id'],
                            ),
                          ),
                        ).then((value) {
                          waktuLoadRepeat(3);
                          pauseLoad(false);
                        });
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
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: data['pengerjaan'].containsKey('ulasan') &&
                                data['pengerjaan']['ulasan']
                                    .containsKey('ulasan_pekerja')
                            ? imageLoad(
                                data['pengerjaan']['ulasan']['ulasan_pekerja']
                                    ['foto'],
                                true,
                                photoWidth,
                                photoWidth)
                            : Image.asset(
                                'assets/general/user.png',
                                width: photoWidth,
                                fit: BoxFit.fitWidth,
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
                                        ' ' +
                                            (data['pengerjaan'].containsKey(
                                                        'ulasan') &&
                                                    data['pengerjaan']['ulasan']
                                                        .containsKey(
                                                            'ulasan_pekerja')
                                                ? data['pengerjaan']['ulasan']
                                                            ['ulasan_pekerja']
                                                        ['nama']
                                                    .toString()
                                                : tanpaNama),
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
                                        ' ' +
                                            (data['pengerjaan'].containsKey(
                                                        'ulasan') &&
                                                    data['pengerjaan']['ulasan']
                                                        .containsKey(
                                                            'ulasan_pekerja') &&
                                                    data['pengerjaan']['ulasan']
                                                                [
                                                                'ulasan_pekerja']
                                                            ['bintang'] !=
                                                        null
                                                ? data['pengerjaan']['ulasan']
                                                            ['ulasan_pekerja']
                                                        ['bintang']
                                                    .toString()
                                                    .toString()
                                                : '0.0'),
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
                              ' ' +
                                  (data['pengerjaan'].containsKey('ulasan') &&
                                          data['pengerjaan']['ulasan']
                                              .containsKey('ulasan_pekerja') &&
                                          data['pengerjaan']['ulasan']
                                                      ['ulasan_pekerja']
                                                  ['deskripsi'] !=
                                              null
                                      ? data['pengerjaan']['ulasan']
                                              ['ulasan_pekerja']['deskripsi']
                                          .toString()
                                          .toString()
                                      : belumReview),
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
                        komenOwner(context);
                      }),
                    ],
                  ),
                ],
              )),
          data['pengerjaan'].containsKey('ulasan') &&
                  data['pengerjaan']['ulasan'].containsKey('ulasan_klien') &&
                  data['pengerjaan']['ulasan']['ulasan_klien']['bintang'] !=
                      null
              ? Container(
                  margin: EdgeInsets.only(left: marginLeftKomen),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'ULASAN PEKERJA',
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
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: data['pengerjaan'].containsKey('ulasan') &&
                                    data['pengerjaan']['ulasan']
                                        .containsKey('ulasan_klien')
                                ? imageLoad(
                                    data['pengerjaan']['ulasan']['ulasan_klien']
                                        ['foto'],
                                    true,
                                    photoWidth,
                                    photoWidth)
                                : Image.asset(
                                    'assets/general/user.png',
                                    width: photoWidth,
                                    fit: BoxFit.fitWidth,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            ' ' +
                                                (data['pengerjaan'].containsKey(
                                                            'ulasan') &&
                                                        data['pengerjaan']
                                                                ['ulasan']
                                                            .containsKey(
                                                                'ulasan_klien') &&
                                                        data['pengerjaan']
                                                                        [
                                                                        'ulasan']
                                                                    [
                                                                    'ulasan_klien']
                                                                ['nama'] !=
                                                            null
                                                    ? data['pengerjaan']
                                                                    ['ulasan']
                                                                ['ulasan_klien']
                                                            ['nama']
                                                        .toString()
                                                    : tanpaNama),
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
                                            ' ' +
                                                (data['pengerjaan'].containsKey(
                                                            'ulasan') &&
                                                        data['pengerjaan']
                                                                ['ulasan']
                                                            .containsKey(
                                                                'ulasan_klien') &&
                                                        data['pengerjaan']
                                                                        [
                                                                        'ulasan']
                                                                    [
                                                                    'ulasan_klien']
                                                                ['bintang'] !=
                                                            null
                                                    ? data['pengerjaan']
                                                                    ['ulasan']
                                                                ['ulasan_klien']
                                                            ['bintang']
                                                        .toString()
                                                        .toString()
                                                    : '0.0'),
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
                                  ' ' +
                                      (data['pengerjaan']
                                                  .containsKey('ulasan') &&
                                              data['pengerjaan']['ulasan']
                                                  .containsKey(
                                                      'ulasan_klien') &&
                                              data['pengerjaan']['ulasan']
                                                          ['ulasan_klien']
                                                      ['deskripsi'] !=
                                                  null
                                          ? data['pengerjaan']['ulasan']
                                                  ['ulasan_klien']['deskripsi']
                                              .toString()
                                          : belumReview),
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
                    ],
                  ))
              : Container(),
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
