import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_shadow/icon_shadow.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/zoomable_single.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_screen.dart';

class TampilanPublikLayananDetail extends StatefulWidget {
  @override
  _TampilanPublikLayananDetailState createState() =>
      _TampilanPublikLayananDetailState();

  const TampilanPublikLayananDetail({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikLayananDetailState
    extends State<TampilanPublikLayananDetail> {
  String urlPhoto;
  String summary;
  String nameUser;
  int userId;
  Map jumlah = {};
  Map dataLayanan = {};
  List ulasan = [];
  List hasilPekerjaan = [];
  bool itsMe = true;
  bool loading = true;
  bool alredyTake = false;

  //TAB false :hasil; true ulasan
  bool tabChange = false;

  //DOWNLOADER

  //SLIDDER
  PanelController _pc = new PanelController();

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      userId = data.containsKey('user') ? data['user']['id'] : null;
      ulasan = data.containsKey('layanan') && data['layanan']['ulasan'] != null
          ? data['layanan']['ulasan']
          : [];
      hasilPekerjaan =
          data.containsKey('layanan') && data['layanan']['hasil'] != null
              ? data['layanan']['hasil']
              : [];
      dataLayanan = data['layanan'] ?? {};

      itsMe = data['its_me'] ?? false;
      alredyTake = data['already_take'] ?? false;
    });
    // print(dataLayanan);
    // print(dataLayanan['bid']);
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.layananDetail(widget.id.toString()).then((v) {
        setLoading(false);
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataPublik(v.data);
        }
      });
    },
        //disconect
        () {
      setLoading(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  void _orderLayanan(String id) async {
    GeneralModel.checCk(
        //connect
        () async {
      onLoading(context);
      PublikModel.orderLayanan(id).then((v) {
        Navigator.pop(context);
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          openAlertSuccessBox(context, 'Berhasil!', v.data['message'], 'OK',
              () => Navigator.pop(context));
          _loadDataApi();
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  @override
  void initState() {
    _loadDataApi();
    // TODO: implement initState
    super.initState();
  }

  getJumlah(String nama) {
    return jumlah.containsKey(nama) ? (jumlah[nama] ?? 0) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    changeSort(String val) {
      String res;
      setState(() {
        if (val == 'asc') {
          res = 'desc';
        } else if (val == 'null') {
          res = 'asc';
        }
      });
      print(res + 'asd');

      return res;
    }

    double imgProyek = (sizeu.width - 50) / 5;
    double defaultWidthKonten = 218.54591836734696;
    double sizeSubKonten = 8;
    double sizeJudulKonten = 12;
    double widthKonten = sizeu.width - 60 - imgProyek - 10;

    double tabPanel = (sizeu.width - 177 - 152) / 3;

    double textSubKonten = widthKonten / defaultWidthKonten * sizeSubKonten;
    double textJudulKonten = widthKonten / defaultWidthKonten * sizeJudulKonten;

    return Scaffold(
        appBar: appBarColloring(),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: loading
              ? onLoading2()
              : SlidingUpPanel(
                  controller: _pc,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                  minHeight: 75,
                  maxHeight: sizeu.height -
                      paddingPhone.top -
                      paddingPhone.bottom -
                      bottom -
                      298 +
                      5 +
                      150,
                  defaultPanelState: PanelState.CLOSED,
                  header: Container(
                      width: sizeu.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          slideSign(),
                        ],
                      )),
                  panel: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 40,
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1, color: AppTheme.nearlyBlack),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                width: 2,
                                color: !tabChange
                                    ? AppTheme.nearlyBlack
                                    : Colors.transparent,
                              ))),
                              margin: EdgeInsets.only(
                                  left: tabPanel, right: tabPanel),
                              padding: EdgeInsets.only(bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  _pc.open();
                                  setState(() {
                                    tabChange = false;
                                  });
                                },
                                child: SizedBox(
                                  width: 177,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.file,
                                        size: 16,
                                      ),
                                      Text(
                                        ' HASIL PEKERJAAN',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      Container(
                                          height: 25,
                                          width: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            moreThan99(hasilPekerjaan.length),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                width: 2,
                                color: tabChange
                                    ? AppTheme.nearlyBlack
                                    : Colors.transparent,
                              ))),
                              padding: EdgeInsets.only(bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  _pc.open();
                                  setState(() {
                                    tabChange = true;
                                  });
                                },
                                child: SizedBox(
                                  width: 152,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.thumbsUp,
                                        size: 16,
                                      ),
                                      Text(
                                        ' ULASAN KLIEN',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      Container(
                                          height: 25,
                                          width: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            moreThan99(
                                              ulasan.length,
                                            ),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: sizeu.height -
                              paddingPhone.top -
                              paddingPhone.bottom -
                              bottom -
                              298 +
                              5 +
                              75 -
                              13,
                          padding: EdgeInsets.only(top: 15),
                          child: tabChange ? ulasanData() : hasilData()),
                    ],
                  ),
                  body: userId == null
                      ? dataKosong()
                      : Stack(
                          children: [
                            // BG

                            Container(
                              height: sizeu.height,
                              width: sizeu.width,
                              decoration: BoxDecoration(
                                color: AppTheme.bgChatBlue,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/general/abstract_bg.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                            Container(
                              // margin: EdgeInsets.only(top: 140),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 140,
                                  ),
                                  //bid
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                                    decoration: BoxDecoration(
                                        color: AppTheme.bgGreenBlueSoft,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.0),
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black54,
                                                      spreadRadius: .5,
                                                      blurRadius: 2,
                                                      offset: Offset(0,
                                                          2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                width: imgProyek,
                                                child: imageLoad(
                                                    dataLayanan['thumbnail'],
                                                    false,
                                                    imgProyek,
                                                    imgProyek),
                                              ),
                                            ),
                                            SizedBox(
                                              width: widthKonten,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      (dataLayanan['judul'] ??
                                                          'Tidak Ada Judul'),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppTheme.bgChatBlue,
                                                        fontSize:
                                                            textJudulKonten + 2,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: widthKonten,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Rp' 
                                                              +
                                                                  pointGroup(
                                                                    int.parse(dataLayanan['harga'] !=
                                                                            null
                                                                        ? dataLayanan['harga']
                                                                            .toString()
                                                                        : '0'),
                                                                  )
                                                                  ,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppTheme
                                                                    .nearlyBlack,
                                                                fontSize:
                                                                    sizeJudulKonten +
                                                                        4,
                                                              ),
                                                              maxLines: 2,
                                                            ),
                                                            Text(
                                                              'Kategori ${(dataLayanan['kategori'] != null ? (dataLayanan['kategori']['nama'] ?? 'tidak ada') : 'tidak ada')}:',
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .geySolidCustom,
                                                                fontSize:
                                                                    textSubKonten +
                                                                        2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              (dataLayanan[
                                                                          'subkategori'] !=
                                                                      null
                                                                  ? (dataLayanan[
                                                                              'subkategori']
                                                                          [
                                                                          'nama'] ??
                                                                      'tidak ada')
                                                                  : 'tidak ada'),
                                                              // 'hello',
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .primaryBlue,
                                                                fontSize:
                                                                    textSubKonten +
                                                                        2.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: imgProyek + 10),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: (widthKonten) * 35 / 100,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Total Klien:',
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .geySolidCustom,
                                                        fontSize:
                                                            textSubKonten + 1.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      moreThan99(parseInt(dataLayanan[
                                                                  'jumlah_klien'])) +
                                                          ' ORANG',
                                                      // 'helo',
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .primaryBlue,
                                                        fontSize:
                                                            textSubKonten + 3,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: (widthKonten) * 65 / 100,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: textSubKonten + 8,
                                                      height: textSubKonten + 8,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: (AssetImage(
                                                              'assets/more_icon/calender.png')),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '  Batas Waktu: ',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .geySolidCustom,
                                                            fontSize:
                                                                textSubKonten +
                                                                    1.5,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          '  ${pointGroup(int.parse((dataLayanan['hari_pengerjaan'] != null ? dataLayanan['hari_pengerjaan'].toString() : '0')))} HARI',
                                                          // 'asd',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .primaryBlue,
                                                            fontSize:
                                                                textSubKonten +
                                                                    3,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        itsMe
                                            ? Container()
                                            : Container(
                                                // margin: EdgeInsets.only(left: imgProyek + 10),
                                                padding: EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: SizedBox(
                                                  width: widthKonten +
                                                      imgProyek +
                                                      10,
                                                  height: 30,
                                                  child: RaisedButton(
                                                    color: alredyTake
                                                        ? AppTheme.geyCustom
                                                        : AppTheme.bgChatBlue,
                                                    onPressed: () {
                                                      if (!alredyTake) {
                                                        //TODO:: event gunakan layanan
                                                        openAlertBoxTwo(
                                                            context,
                                                            'Konfirmasi Pengajuan Layanan',
                                                            'Apakah Anda yakin akan memesan layanan "${dataLayanan['judul']}"?',
                                                            'TIDAK',
                                                            'YA',
                                                            () => Navigator.pop(
                                                                context), () {
                                                          Navigator.pop(
                                                              context);
                                                          _orderLayanan(
                                                              dataLayanan['id']
                                                                  .toString());
                                                        });
                                                      } else {
                                                        openAlertBox(
                                                            context,
                                                            'Pemberitahuan!',
                                                            'Layanan masih dalam proses....',
                                                            'OK',
                                                            () => Navigator.pop(
                                                                context));
                                                      }
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          (alredyTake
                                                              ? 'LAYANAN TELAH DIAJUKAN '
                                                              : "GUNAKAN LAYANAN "),
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .nearlyWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .solidPaperPlane,
                                                          size: 14,
                                                          color: AppTheme
                                                              .nearlyWhite,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  //deskripsi
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    decoration: BoxDecoration(
                                        color: AppTheme.bgBlueSoft,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //judul
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: (AssetImage(
                                                      'assets/more_icon/file.png')),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: widthKonten +
                                                    imgProyek +
                                                    10 -
                                                    20,
                                                child: Text(
                                                  ' Deskripsi',
                                                  style: TextStyle(
                                                    color: AppTheme.textBlue,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            dataLayanan['deskripsi'] ??
                                                'Belum ada deskripsi...',
                                            style: TextStyle(
                                              color: AppTheme.textBlue,
                                              fontSize: 14,
                                              // fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 120,
                                  ),
                                ],
                              ),
                            ),
                            appDashboardLinkPhoto(
                              context,
                              urlPhoto,
                              Text(''),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppTheme.nearlyWhite,
                                      size: AppTheme.sizeIconMenu,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TampianPublikScreen(
                                            id: userId,
                                          ))),
                            ),
                          ],
                        ),
                ),
        ));
  }

  Widget ulasanData() {
    final sizeu = MediaQuery.of(context).size;

    return (ulasan != null ? ulasan.length > 0 : false)
        ? ListView.builder(
            itemCount: ulasan.length,
            // itemExtent: 100.0,
            itemBuilder: (c, i) {
              Map value = ulasan[i];
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.renoReno[colorIndexReno(i)],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TampianPublikScreen(
                                  id: value['id'],
                                )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: imageLoad(value['foto'], true, 60, 60),
                      ),
                      Container(
                          width: sizeu.width - 141,
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 5, color: AppTheme.geyCustom),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/general/user_place.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    width: sizeu.width - 30 - 141 - 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value['nama'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 3.0, bottom: 3),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconShadowWidget(
                                                Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: Colors.yellow,
                                                ),
                                                shadowColor: AppTheme.geyCustom,
                                              ),
                                              Text(
                                                ' ' +
                                                    value['bintang'].toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                value['deskripsi'],
                                textAlign: TextAlign.justify,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              );
            },
          )
        : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              bottom: 50,
            ),
            child: Text(
              'Data Ulasan Kosong...',
              style: TextStyle(
                  // color: Colors.grey,
                  fontSize: 22),
            ),
          );
  }

  Widget hasilData() {
    final sizeu = MediaQuery.of(context).size;

    return (hasilPekerjaan != null ? hasilPekerjaan.length > 0 : false)
        ? ListView.builder(
            itemCount: hasilPekerjaan.length,
            // itemExtent: 100.0,
            itemBuilder: (c, i) {
              String value = hasilPekerjaan[i];
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.renoReno[colorIndexReno(i)],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ZoomableSingle(
                                  child: imageLoadByWidth(value, false, 320),
                                  min: 0.1,
                                  max: 6.0,
                                )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        padding: EdgeInsets.only(right: 10),
                        child: imageLoad(value, false, 60, 60),
                      ),
                      Container(
                        width: sizeu.width - 141,
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            left:
                                BorderSide(width: 5, color: AppTheme.geyCustom),
                          ),
                        ),
                        child: Text(
                            value != null ? value.split('/').last : unknown),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              bottom: 50,
            ),
            child: Text(
              'Hasil Pekerjaan Kosong...',
              style: TextStyle(
                  // color: Colors.grey,
                  fontSize: 22),
            ),
          );
  }

  Widget slideSign() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 17),
        width: 120,
        height: 8,
        decoration: BoxDecoration(
          color: AppTheme.geySofttCustom,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
