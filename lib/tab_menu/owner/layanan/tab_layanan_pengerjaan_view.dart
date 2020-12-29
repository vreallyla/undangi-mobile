import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/zoomable_multi_with_download.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/rating_modal.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/layanan_owner_model.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_layanan_detail.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_screen.dart';
import 'package:undangi/tab_menu/owner/layanan/sub/payment_layanan_screen.dart';

import 'package:url_launcher/url_launcher.dart';

class TabLayananPengerjaanView extends StatefulWidget {
  const TabLayananPengerjaanView({
    Key key,
    this.paddingTop,
    this.dataReresh,
    this.dataNext,
    this.refresh,
    this.dataPengerjaan,
    this.paddingBottom,
    this.loading,
    this.bottomKey = 0,
    this.toProgress,
    this.loadAgain,
    this.toProgressFunc,
    this.setStopRepeat,
  }) : super(key: key);

  final double bottomKey;
  final RefreshController refresh;
  final List dataPengerjaan;
  final double paddingTop;
  final double paddingBottom;
  final Function toProgressFunc;
  final Function dataReresh;
  final Function dataNext;
  final Function loadAgain;
  final Function(bool kond) setStopRepeat;

  final bool toProgress;
  final bool loading;
  @override
  _TabLayananPengerjaanViewState createState() =>
      _TabLayananPengerjaanViewState();
}

class _TabLayananPengerjaanViewState extends State<TabLayananPengerjaanView> {
  changeToProgress() {
    widget.toProgressFunc();
  }

  int colorChange = 0;

  _deleteApi(String id) async {
    onLoading(context);
    widget.setStopRepeat(true);

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      LayananOwnerModel.hapusLayanan(id).then((v) {
        widget.setStopRepeat(false);

        Navigator.pop(context);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          widget.loadAgain();
        }
      });
    },
        //disconect
        () {
      widget.setStopRepeat(false);

      Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  _ratingApi(String id, Map res) async {
    onLoading(context);
    widget.setStopRepeat(true);

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      LayananOwnerModel.ratingLayanan(id, res).then((v) {
        widget.setStopRepeat(false);

        Navigator.pop(context);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          widget.loadAgain();
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);
      widget.setStopRepeat(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  komenOwner(context, Map data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return RatingModal(
            nama: data['layanan']['judul'],
            isLunas: data['isPaidOff'] == 1,
            eventRes: (Map res) {
              _ratingApi(data['id'].toString(), res);
            },
          );
        });
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
          (widget.toProgress
              ? Container(
                  height: sizeu.height -
                      310 -
                      widget.bottomKey -
                      widget.paddingBottom -
                      widget.paddingTop +
                      50,
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
          widget.paddingTop +
          50,
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
                          setStopRepeat: (kond) => widget.setStopRepeat(kond),
                          marginLeftRight: marginLeftRight,
                          marginCard: marginCard,
                          changeProgress: () {
                            changeToProgress();
                          },
                          deleteApi: (id) {
                            _deleteApi(id);
                          },
                          formRating: (Map res) {
                            komenOwner(context, res);
                          },
                          data: widget.dataPengerjaan[i],
                          index: i,
                        );
                      }),
                  onRefresh: widget.dataReresh,
                  onLoading: widget.dataNext,
                )),
    );
  }
}

int colorChange = 0;

class TabPengerjaanCard extends StatelessWidget {
  const TabPengerjaanCard({
    Key key,
    this.data,
    this.index,
    this.marginLeftRight: 0,
    this.marginCard: 0,
    this.changeProgress,
    this.formRating,
    this.deleteApi,
    this.setStopRepeat,
  }) : super(key: key);

  final double marginLeftRight;
  final double marginCard;
  final Map data;
  final int index;
  final Function() changeProgress;
  final Function(bool kond) setStopRepeat;

  final Function(String id) deleteApi;
  final Function(Map res) formRating;

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
      child: InkWell(
        onTap: () {},
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
                  child: imageLoad(
                      data['layanan'] != null &&
                              data['layanan']['thumbnail'] != null
                          ? data['layanan']['thumbnail']
                          : null,
                      false,
                      imgCard,
                      imgCard),
                ),
                //kontent
                Container(
                  width: widthKonten,
                  // height: heightCard,
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
                          data['layanan'] != null &&
                                  data['layanan']['judul'] != null
                              ? data['layanan']['judul']
                              : empty,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: AppTheme.primarymenu,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Rp' +
                              decimalPointTwo(data['layanan'] != null &&
                                      data['layanan']['kategori'] != null
                                  ? (data['layanan']['harga'] != null
                                      ? data['layanan']['harga']
                                      : 0)
                                  : 0),
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
                              (data['layanan'] != null &&
                                      data['layanan']['kategori'] != null
                                  ? data['layanan']['kategori']['nama']
                                  : unknown) +
                              ":",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        data['layanan'] != null &&
                                data['layanan']['subkategori'] != null
                            ? data['layanan']['subkategori']['nama']
                            : unknown,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          btnTool(
                              true,
                              'assets/more_icon/info.png',
                              BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              (widthBtnShort - 15) / 2, () {
                            setStopRepeat(true);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TampilanPublikLayananDetail(
                                              id: data['layanan']['id'],
                                            )))
                                .then((value) => setStopRepeat(false));
                          }),
                          btnTool(
                              data['deleteable'] == 1,
                              'assets/more_icon/remove-file.png',
                              BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              (widthBtnShort - 15) / 2, () {
                            if (data['deleteable'] == 1) {
                              openAlertBoxTwo(
                                context,
                                'KONFIRMASI HAPUS PROYEK',
                                'Apa anda yakin hapus proyek ini? Proyek akan hilang!',
                                'TIDAK',
                                'HAPUS',
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);

                                  deleteApi(data['id'].toString());
                                },
                              );
                            } else {
                              openAlertBox(
                                  context,
                                  'Layanan sedang dikerjakan!',
                                  'Layanan tidak bisa dihapus...',
                                  'OK', () {
                                Navigator.pop(context);
                              });
                            }
                          }),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          // openAlertBox(
                          //     context,
                          //     'APAKAH ANDA YAKIN?',
                          //     'Untuk menyelesaikan PEKERJAAN ini',
                          //     'KONFIRMASI', () {
                          //   Navigator.pop(context);
                          // });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.primarymenu,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            data['status'] ?? unknown,
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
                    moreThan99(data['layanan'] != null &&
                                data['layanan']['jumlah_klien'] != null
                            ? data['layanan']['jumlah_klien']
                            : 0) +
                        ' ORANG  ',
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
                    pointGroup(int.parse(data['layanan'] != null &&
                                data['layanan']['hari_pengerjaan'] != null
                            ? data['layanan']['hari_pengerjaan'].toString()
                            : '0')) +
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
      ),
    );
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
              InkWell(
                onTap: () {
                  if (data['pekerja'] != null) {
                    setStopRepeat(true);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TampianPublikScreen(id: data['pekerja']['id']),
                        )).then((value) => setStopRepeat(false));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: photoWidth,
                  width: photoWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: data['pekerja'] != null &&
                          data['pekerja']['foto'] != null
                      ? imageLoad(
                          data['pekerja']['foto'], true, photoWidth, photoWidth)
                      : Image.asset(
                          'assets/general/user.png',
                          width: photoWidth,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (data['pekerja'] != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TampianPublikScreen(id: data['pekerja']['id']),
                        ));
                  }
                },
                child: Stack(
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
                                    (data['pekerja'] != null &&
                                            data['pekerja']['nama'] != null
                                        ? data['pekerja']['nama']
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
                                      (data['pekerja'] != null &&
                                              data['pekerja']['bintang'] != null
                                          ? data['pekerja']['bintang']
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
                        // color: Colors.green,
                        border: Border(
                          left: BorderSide(
                              width: wightboder,
                              color: AppTheme.geySolidCustom),
                        ),
                      ),
                      child: Text(
                        (data['pekerja'] != null &&
                                data['pekerja']['summary'] != null
                            ? data['pekerja']['summary']
                            : empty),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
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
                        (data.containsKey('file_hasil') &&
                                data['file_hasil'].length > 0
                            ? data['file_hasil'].length.toString() +
                                ' Preview'
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
                          if (data['tautan'] != null) {
                            String url = data['tautan'];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              // throw 'Could not launch $url';
                              print(url);
                            }
                          }
                        },
                        child: Text(
                          data['tautan'] != null
                              ? data['tautan'].toString()
                              : empty,
                          style: TextStyle(
                            fontSize: 12,
                            color: data['tautan'] != null
                                ? AppTheme.bgChatBlue
                                : Colors.black,
                            decoration: data['tautan'] != null
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
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
                      btnTool(
                          data['file_hasil'].length > 0,
                          'assets/more_icon/file_alt.png',
                          BorderRadius.circular(30.0),
                          50, () {
                        if (data['file_hasil'].length > 0) {
                          setStopRepeat(true);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ZoomAbleMultiWithDownload(
                                        index: 0,
                                        imgList: data['file_hasil'],
                                        max: 6,
                                        min: 0.1,
                                      ))).then((value) => setStopRepeat(false));
                        } else {
                          openAlertBox(
                              context,
                              'hasil Kerja Masih Kosong',
                              'Hasil Pengerjaan masih kosong, silakan buka lagi jika sudah tersedia!',
                              'OK',
                              () => Navigator.pop(context));
                        }
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                        ),
                      ),
                      btnTool(data['isPaidOff'] == 0, 'assets/more_icon/cc.png',
                          BorderRadius.circular(30.0), 50, () {
                        print(data['isPaidOff']);
                        if (data['isPaidOff'] == 0) {
                          setStopRepeat(true);

                          //TODO::link to pembayran
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PaymentLayananScreen(
                                layananId: data['id'],
                              ),
                            ),
                          ).then((value) => setStopRepeat(false));
                        } else {
                          openAlertBox(
                              context,
                              'Pembayaran Sudah Lunas',
                              'Pembayaran sudah lunas, anda tidak perlu melakukan pembayaran lagi!',
                              'OK',
                              () => Navigator.pop(context));
                        }
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
                        child: data['ulasan'] != null &&
                                data['ulasan']['foto'] != null
                            ? imageLoad(data['ulasan']['foto'], true,
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
                                            (data['ulasan'] != null &&
                                                    data['ulasan']['nama'] !=
                                                        null
                                                ? data['ulasan']['nama']
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
                                            (data['ulasan'] != null &&
                                                    data['ulasan']['bintang'] !=
                                                        null
                                                ? data['ulasan']['bintang']
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
                                  (data['ulasan'] != null &&
                                          data['ulasan']['deskripsi'] != null
                                      ? data['ulasan']['deskripsi'].toString()
                                      : belumReview),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                      btnTool(
                          data['ratingable'] == 1,
                          'assets/more_icon/edit-button.png',
                          BorderRadius.circular(30.0),
                          50, () {
                        if (data['ratingable'] == 1) {
                          print(data['id']);
                          formRating(data);
                        } else {
                          openAlertBox(
                              context,
                              data['ulasan'] != null &&
                                      data['ulasan']['deskripsi'] != null
                                  ? 'Layanan Sudah Selesai'
                                  : 'Ulasan Belum Bisa di Buka',
                              data['ulasan'] != null &&
                                      data['ulasan']['deskripsi'] != null
                                  ? 'Anda sudah tidak bisa memberi ulasan lagi...'
                                  : 'Tunggu Lampiran/Tautan terisi untuk mengisi ulasan...',
                              'OK',
                              () => Navigator.pop(context));
                        }
                      }),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget btnTool(bool active, String locationImg, BorderRadius radius,
      double width, Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: width,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(.5) : Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            width: 1,
            color: AppTheme.nearlyBlack.withOpacity(active ? 1 : 0.4),
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
