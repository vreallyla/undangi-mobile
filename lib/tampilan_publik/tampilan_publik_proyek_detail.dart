import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_screen.dart';

import 'card_bidder.dart';

class TampilanPublikProyekDetail extends StatefulWidget {
  @override
  _TampilanPublikProyekDetailState createState() =>
      _TampilanPublikProyekDetailState();

  const TampilanPublikProyekDetail({
    Key key,
    this.id = 0,
    this.userId = 0,
  }) : super(key: key);

  final int id;
  final int userId;
}

class _TampilanPublikProyekDetailState
    extends State<TampilanPublikProyekDetail> {
  String urlPhoto;
  String summary;
  String nameUser;
  Map jumlah = {};
  Map dataProyek = {};
  bool itsMe = true;
  bool loading = true;

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      dataProyek = data['proyek'] ?? [];

      itsMe = data['its_me'] ?? false;
    });
    print(dataProyek);
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.proyekDetail(widget.id == 0 ? '' : widget.id.toString())
          .then((v) {
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

    double imgProyek = (sizeu.width - 50) / 5;
    double defaultWidthKonten = 218.54591836734696;
    double sizeSubKonten = 8;
    double sizeJudulKonten = 12;
    double widthKonten = sizeu.width - 60 - imgProyek - 10;

    double textSubKonten = widthKonten / defaultWidthKonten * sizeSubKonten;
    double textJudulKonten = widthKonten / defaultWidthKonten * sizeJudulKonten;

    return Scaffold(
      appBar: appBarColloring(),
      body: loading
          ? onLoading2()
          : SlidingUpPanel(
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidPaperPlane,
                          size: 16,
                        ),
                        Text(
                          ' BIDDER',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        Container(
                            height: 25,
                            width: 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              moreThan99(
                                dataProyek['total_bid'] ?? 0,
                              ),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11),
                            )),
                        !itsMe
                            ? Container()
                            : PopupMenuButton(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  width: sizeu.width - 156,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.filter,
                                        size: 16,
                                      ),
                                      Text(
                                        ' Filter',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                onSelected: (newValue) {
                                  if (newValue == 0) {
                                  } else {}
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Harga"),
                                    value: 0,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Batas Waktu"),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Task"),
                                    value: 2,
                                  ),
                                ],
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
                        75,
                    child: (dataProyek['bid'] != null
                            ? dataProyek['bid'].length > 0
                            : false)
                        ? ListView.builder(
                            itemCount: dataProyek['bid'].length,
                            // itemExtent: 100.0,
                            itemBuilder: (c, i) =>
                            cardBidder(i:i,data:dataProyek['bid'][i])
                              )
                        : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              bottom: 50,
                            ),
                            child: Text(
                              'Data Bidder Kosong...',
                              style: TextStyle(
                                  // color: Colors.grey,
                                  fontSize: 22),
                            ),
                          ),
                  ),
                ],
              ),
              body: Center(
                child: Stack(
                  children: [
                    // BG

                    Container(
                      height: sizeu.height,
                      width: sizeu.width,
                      decoration: BoxDecoration(
                        color: AppTheme.bgChatBlue,
                        image: DecorationImage(
                          image: AssetImage('assets/general/abstract_bg.png'),
                          fit: BoxFit.fill,
                        ),
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
                                    id: widget.userId,
                                  ))),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //bid
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            decoration: BoxDecoration(
                                color: AppTheme.bgGreenBlueSoft,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
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
                                            dataProyek['thumbnail'],
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
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              (dataProyek['judul'] ??
                                                  'Tidak Ada Judul'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.bgChatBlue,
                                                fontSize: textJudulKonten + 2,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: widthKonten - 80,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Rp' +
                                                          pointGroup(int.parse(
                                                              dataProyek['harga']
                                                                      .toString() ??
                                                                  '0')),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppTheme
                                                            .nearlyBlack,
                                                        fontSize:
                                                            sizeJudulKonten + 4,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      'Kategori ${(dataProyek['kategori'] != null ? (dataProyek['kategori']['nama'] ?? 'tidak ada') : 'tidak ada')}:',
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .geySolidCustom,
                                                        fontSize:
                                                            textSubKonten + 2,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      (dataProyek['subkategori'] !=
                                                              null
                                                          ? (dataProyek[
                                                                      'subkategori']
                                                                  ['nama'] ??
                                                              'tidak ada')
                                                          : 'tidak ada'),
                                                      style: TextStyle(
                                                        color: AppTheme
                                                            .primaryBlue,
                                                        fontSize:
                                                            textSubKonten + 2.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: 5,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 3, bottom: 3),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: true
                                                              ? AppTheme
                                                                  .bgChatBlue
                                                              : AppTheme
                                                                  .primaryRed),
                                                      child: Text(
                                                        dataProyek['jenis']
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                textSubKonten +
                                                                    1,
                                                            color: AppTheme
                                                                .nearlyWhite),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: 5,
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 3, bottom: 3),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .geyCustom),
                                                          color: Colors
                                                              .transparent),
                                                      child: Text(
                                                        'LAMPIRAN',
                                                        style: TextStyle(
                                                            fontSize:
                                                                textSubKonten +
                                                                    1,
                                                            color: AppTheme
                                                                .geyCustom),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: imgProyek + 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: (widthKonten) * 35 / 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Bid:',
                                              style: TextStyle(
                                                color: AppTheme.geySolidCustom,
                                                fontSize: textSubKonten + 1.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              moreThan99(
                                                      dataProyek['total_bid'] ??
                                                          0) +
                                                  ' ORANG',
                                              style: TextStyle(
                                                color: AppTheme.primaryBlue,
                                                fontSize: textSubKonten + 3,
                                                fontWeight: FontWeight.w600,
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '  Batas Waktu: ',
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.geySolidCustom,
                                                    fontSize:
                                                        textSubKonten + 1.5,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  '  ${pointGroup(int.parse(dataProyek['waktu_pengerjaan'].toString() ?? '0'))} HARI',
                                                  style: TextStyle(
                                                    color: AppTheme.primaryBlue,
                                                    fontSize: textSubKonten + 3,
                                                    fontWeight: FontWeight.w600,
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
                                itsMe?Container():Container(
                                  // margin: EdgeInsets.only(left: imgProyek + 10),
                                  padding: EdgeInsets.only(
                                    top: 5,
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: widthKonten + imgProyek + 10,
                                    height: 30,
                                    child: RaisedButton(
                                      color: AppTheme.bgChatBlue,
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'BID ',
                                            style: TextStyle(
                                              color:  AppTheme.nearlyWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.solidPaperPlane,
                                            size: 14,
                                            color: AppTheme.nearlyWhite,
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
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                color: AppTheme.bgBlueSoft,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //judul
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        width:
                                            widthKonten + imgProyek + 10 - 20,
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
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    dataProyek['deskripsi'] ??
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
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

  Widget cardProyek(int i, data) {
    int z = i + 1;
    if (z % 1 == 0) {
      z = 0;
    }
    if (i % 2 == 0) {
      z = 1;
    }
    if (i % 3 == 0) {
      z = 2;
    }
    if (i % 4 == 0) {
      z = 3;
    }

    bool lihat = true;
    final sizeu = MediaQuery.of(context).size;
    Map value = data[i];
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.renoReno[z],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    left: BorderSide(width: 5, color: AppTheme.geyCustom),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value['nama'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3.0, bottom: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      ' ' + value['bintang'].toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w100),
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
                      'Penawaran Harga : Rp' +
                          pointGroup(
                              int.parse(value['negoharga'].toString() ?? '0')),
                    ),
                    Text(
                      'Waktu Pengerjaan : ' +
                          pointGroup(
                              int.parse(value['negowaktu'].toString() ?? '0')) +
                          ' Hari',
                    )
                  ],
                ),
              ),
            ],
          ),
          lihat
              ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('asdasd'),
                        Padding(
                          padding: const EdgeInsets.only(top:15),
                          child: InkWell(
                  onTap: () {
                    
                      lihat = !lihat;
             
                      print(lihat);

                  },
                  child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'SEMBUNYIKAN PENAWARAN TASK',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: AppTheme.geyCustom,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: () {
                      lihat = !lihat;

                      print(lihat);
                    },
                    child: Text(
                      'LIHAT PENAWARAN TASK',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppTheme.geyCustom,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget lihatTask(bool lihat, String task, Function ev) {
    return lihat
        ? InkWell(onTap: () => ev, child: Text('asdasd'))
        : Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 8),
            child: InkWell(
              onTap: () => ev(),
              child: Text(
                'LIHAT PENAWARAN TASK',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppTheme.geyCustom,
                ),
              ),
            ),
          );
  }
}
