import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_screen.dart';
import 'package:undangi/tampilan_publik/helper/modal_bid.dart';

import 'helper/card_bidder.dart';

class TampilanPublikProyekDetail extends StatefulWidget {
  @override
  _TampilanPublikProyekDetailState createState() =>
      _TampilanPublikProyekDetailState();

  const TampilanPublikProyekDetail({
    Key key,
    this.id = 0,
    this.sortHarga = null,
    this.sortWaktu = null,
    this.sortTask = null,
  }) : super(key: key);

  final int id;
  final String sortHarga;
  final String sortWaktu;
  final String sortTask;
}

class _TampilanPublikProyekDetailState
    extends State<TampilanPublikProyekDetail> {
  String urlPhoto;
  String summary;
  String nameUser;
  int userId;
  Map jumlah = {};
  Map dataProyek = {};
  bool itsMe = true;
  bool loading = true;
  bool alreadBid = false;

  //DOWNLOADER
  ReceivePort _receivePort = ReceivePort();
  bool loadDownloadLampiran = false;
  int progress = 0;

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      userId = data.containsKey('user') ? data['user']['id'] : null;
      dataProyek = data['proyek'] ?? [];

      itsMe = data['its_me'] ?? false;
      alreadBid = data['already_bid'] ?? false;
    });
    // print(dataProyek['bid']);
  }

  lampiranPopup(context) {
    List dataLampiran =
        dataProyek['lampiran'] != null ? dataProyek['lampiran'] : [];

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
                      'LAMPIRAN',
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
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            height: 250,
                            child: dataLampiran.length == 0
                                ? dataKosong()
                                : ListView.builder(
                                    itemCount: dataLampiran.length,
                                    // itemExtent: 100.0,
                                    itemBuilder: (c, i) {
                                      String nama =
                                          dataLampiran[i].split('/').last;
                                      String otherExt = '';
                                      String ext = nama.split('.').last;
                                      bool imgExt = [
                                                'jpg',
                                                'jpeg',
                                                'gif',
                                                'png'
                                              ].indexOf(ext) >=
                                              0
                                          ? true
                                          : false;
                                      if (!imgExt) {
                                        if ('pdf' == ext) {
                                          otherExt = 'assets/ext/pdf.png';
                                        } else if (['ppt', 'pptx']
                                                    .indexOf(ext) >=
                                                0
                                            ? true
                                            : false) {
                                          otherExt = 'assets/ext/ppt.png';
                                        } else if (['xls', 'xlsx']
                                                    .indexOf(ext) >=
                                                0
                                            ? true
                                            : false) {
                                          otherExt = 'assets/ext/excel.png';
                                        } else if (['doc', 'docx', 'odt']
                                                    .indexOf(ext) >=
                                                0
                                            ? true
                                            : false) {
                                          otherExt = 'assets/ext/doc.png';
                                        } else {
                                          otherExt = 'assets/ext/files.png';
                                        }
                                      }
                                      // transColor();
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(bottom: 5),
                                        height: 30,
                                        child: Stack(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 40,
                                              width: double.infinity,
                                              child: InkWell(
                                                onTap: () async {
                                                  final status =
                                                      await Permission.storage
                                                          .request();

                                                  if (status.isGranted) {
                                                    final externalDir =
                                                        await getExternalStorageDirectory();

                                                    final id =
                                                        await FlutterDownloader
                                                            .enqueue(
                                                      url: dataLampiran[i],
                                                      savedDir:
                                                          externalDir.path,
                                                      fileName: "download",
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true,
                                                    );
                                                  } else {
                                                    print("Permission deined");
                                                  }
                                                },
                                                child: FaIcon(
                                                  FontAwesomeIcons.download,
                                                  color: Colors.grey[700],
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            imgExt
                                                ? SizedBox(
                                                    width: 30,
                                                    child: imageLoad(
                                                        dataLampiran[i],
                                                        false,
                                                        30,
                                                        30))
                                                : Image.asset(
                                                    otherExt,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  right: 50, left: 30),
                                              height: 40,
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                nama,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                          ),
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

  // refresh user
  void _loadDataApi() async {
    Map res = {
      'sort_harga': widget.sortHarga,
      'sort_waktu': widget.sortWaktu,
      'sort_task': widget.sortTask,
    };
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.proyekDetail(widget.id == 0 ? '' : widget.id.toString(), res)
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

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("Undangi");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('download file');
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void initState() {
    print(widget.sortHarga);
    _loadDataApi();
    // TODO: implement initState
    super.initState();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      if (!loadDownloadLampiran) {
        setState(() {
          loadDownloadLampiran = true;
        });
        onLoading(context);
      }

      if (progress >= 100) {
        if (loadDownloadLampiran) {
          Navigator.pop(context);
          openAlertSuccessBox(
              context, 'Berhasil!', 'Lampiran Berhasil didownload...', 'OK',
              () {
            setState(() {
              loadDownloadLampiran = false;
            });
            Navigator.pop(context);
          });
          _unbindBackgroundIsolate();
        }
      }

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  getJumlah(String nama) {
    return jumlah.containsKey(nama) ? (jumlah[nama] ?? 0) : 0;
  }

  redirectAgain(String name, String value) {
    String v = null;

    setState(() {
      if (value == 'asc') {
        v = 'desc';
      } else if (value == null) {
        v = 'asc';
      }
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TampilanPublikProyekDetail(
                  id: widget.id,
                  sortHarga: 'sortHarga' == name ? v : widget.sortHarga,
                  sortWaktu: 'sortWaktu' == name ? v : widget.sortWaktu,
                  sortTask: 'sortTask' == name ? v : widget.sortTask,
                )));
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
                  defaultPanelState: widget.sortTask != null ||
                          widget.sortHarga != null ||
                          widget.sortWaktu != null
                      ? PanelState.OPEN
                      : PanelState.CLOSED,
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
                                  moreThan99(dataProyek['total_bid'] != null
                                      ? int.parse(
                                          dataProyek['total_bid'].toString())
                                      : 0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                    onSelected: (newValue) async {
                                      if (newValue == 0) {
                                        redirectAgain(
                                            'sortHarga', widget.sortHarga);
                                      } else if (newValue == 1) {
                                        redirectAgain(
                                            'sortWaktu', widget.sortWaktu);
                                      } else {
                                        redirectAgain(
                                            'sortTask', widget.sortTask);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 100,
                                                    child: Text("Harga")),
                                                SizedBox(
                                                    width: 30,
                                                    child: widget.sortHarga ==
                                                            null
                                                        ? Container()
                                                        : FaIcon(widget
                                                                    .sortHarga ==
                                                                'desc'
                                                            ? FontAwesomeIcons
                                                                .sortNumericUp
                                                            : FontAwesomeIcons
                                                                .sortNumericDown))
                                              ],
                                            )),
                                        value: 0,
                                      ),
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 100,
                                                    child: Text("Batas Waktu")),
                                                SizedBox(
                                                    width: 30,
                                                    child: widget.sortWaktu ==
                                                            null
                                                        ? Container()
                                                        : FaIcon(widget
                                                                    .sortWaktu ==
                                                                'desc'
                                                            ? FontAwesomeIcons
                                                                .sortNumericUp
                                                            : FontAwesomeIcons
                                                                .sortNumericDown))
                                              ],
                                            )),
                                        value: 1,
                                      ),
                                      PopupMenuItem(
                                        child: SizedBox(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 100,
                                                    child: Text("Task")),
                                                SizedBox(
                                                    width: 30,
                                                    child: widget.sortTask ==
                                                            null
                                                        ? Container()
                                                        : FaIcon(widget
                                                                    .sortTask ==
                                                                'desc'
                                                            ? FontAwesomeIcons
                                                                .sortAlphaUp
                                                            : FontAwesomeIcons
                                                                .sortAlphaDown))
                                              ],
                                            )),
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
                                itemBuilder: (c, i) => cardBidder(
                                  loadDataApi: () => _loadDataApi(),
                                  bottom: bottom,
                                  proyekId: widget.id,
                                  other: {"nama": dataProyek['judul']},
                                  i: i,
                                  data: dataProyek['bid'][i],
                                  itsMe: itsMe,
                                ),
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
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      (dataProyek['judul'] ??
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
                                                        width: widthKonten - 80,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Rp' +
                                                                  pointGroup(dataProyek[
                                                                              'harga'] !=
                                                                          null
                                                                      ? int.parse(
                                                                          dataProyek['harga']
                                                                              .toString())
                                                                      : 0),
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
                                                              'Kategori ${(dataProyek['kategori'] != null ? (dataProyek['kategori']['nama'] ?? 'tidak ada') : 'tidak ada')}:',
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
                                                              (dataProyek['subkategori'] !=
                                                                      null
                                                                  ? (dataProyek[
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
                                                      SizedBox(
                                                        width: 80,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 5,
                                                              ),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 3,
                                                                      bottom:
                                                                          3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: true
                                                                      ? AppTheme
                                                                          .bgChatBlue
                                                                      : AppTheme
                                                                          .primaryRed),
                                                              child: Text(
                                                                (dataProyek['jenis'] ??
                                                                        '-')
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
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: 5,
                                                              ),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 3,
                                                                      bottom:
                                                                          3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: AppTheme
                                                                          .geyCustom),
                                                                  color: Colors
                                                                      .transparent),
                                                              child: InkWell(
                                                                onTap: () =>
                                                                    lampiranPopup(
                                                                        context),
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
                                                      'Total Bid:',
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
                                                      moreThan99(dataProyek[
                                                                      'total_bid'] !=
                                                                  null
                                                              ? int.parse(dataProyek[
                                                                      'total_bid']
                                                                  .toString())
                                                              : 0) +
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
                                                          '  ${dataProyek['waktu_pengerjaan'] != null ? dataProyek['waktu_pengerjaan'].toString() : '0'} HARI',
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
                                                    color: alreadBid
                                                        ? AppTheme.geyCustom
                                                        : AppTheme.bgChatBlue,
                                                    onPressed: () {
                                                      if (!alreadBid) {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ModalBid(
                                                                tawarHarga: dataProyek[
                                                                        'harga']
                                                                    .toString(),
                                                                other: {
                                                                  "nama":
                                                                      dataProyek[
                                                                          'judul']
                                                                },
                                                                tawarWaktu: dataProyek[
                                                                        'waktu_pengerjaan']
                                                                    .toString(),
                                                                tawarTask: '',
                                                                proyekId: widget
                                                                    .id
                                                                    .toString(),
                                                                loadAgain: () =>
                                                                    _loadDataApi(),
                                                                bottom: bottom,
                                                              );
                                                            });
                                                      } else {
                                                        openAlertBox(
                                                            context,
                                                            'Pemberitahuan!',
                                                            'Proyek telah di bid....',
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
                                                          (alreadBid
                                                              ? 'BID TELAH DIAJUKAN '
                                                              : "BID "),
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
    if (z % 2 == 0) {
      z = 1;
    }
    if (z % 3 == 0) {
      z = 2;
    }
    if (z % 4 == 0) {
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
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('asdasd'),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
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
