import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/rating_modal.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Constant/zoomable_single_with_download.dart';
import 'package:undangi/Model/frelencer/proyek_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/tab_menu/frelencer/proyek/helper/file_hasil_modal.dart';
import 'package:undangi/tab_menu/frelencer/proyek/helper/progress_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class PengerjaanListFrelenceTab extends StatefulWidget {
  const PengerjaanListFrelenceTab({
    Key key,
    this.bottomKey = 0,
    this.reloadFunc,
    this.toProgressFunc,
    this.nextData,
    this.dataBid,
    this.loading,
    this.refresh,
    this.toProgress,
    this.pauseLoad,
  }) : super(key: key);

  final double bottomKey;
  final bool loading;
  final List dataBid;

  final bool toProgress;
  final Function(bool kond) pauseLoad;
  final Function(String id) toProgressFunc;

  final RefreshController refresh;

  final Function() reloadFunc;
  final Function() nextData;
  @override
  _PengerjaanListFrelenceTabState createState() =>
      _PengerjaanListFrelenceTabState();
}

class _PengerjaanListFrelenceTabState extends State<PengerjaanListFrelenceTab> {
  bool loadingProgress = false;
  List dataProgress = [];
  String proyekId = '';
  Map dataProyek = {};

  //DOWNLOADER
  ReceivePort _receivePort = ReceivePort();
  bool loadDownloadLampiran = false;
  int progress = 0;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("Undangi");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _saveFile(String fileUrl) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url: fileUrl,
        savedDir: externalDir.path,
        fileName: fileUrl.split('/').last.indexOf('.') >= 0
            ? fileUrl.split('/').last
            : 'Surat Kontrak',
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print("Permission deined");
    }
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void initState() {
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
              context, 'Berhasil!', 'File Hasil Berhasil didownload...', 'OK',
              () {
            setState(() {
              loadDownloadLampiran = false;
            });
            Navigator.pop(context);
          });
          _unbindBackgroundIsolate();
        }
      }
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  komenOwner(context, Map data) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return RatingModal(
            nama: data['proyek']['judul'],
            isLunas: false,
            hiddenInputPuas: true,
            eventRes: (Map res) {
              _ratingApi(data['proyek_id'].toString(), res);
            },
          );
        });
  }

  _ratingApi(String id, Map res) async {
    onLoading(context);
    widget.pauseLoad(true);

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      ProyekFrelencerModel.ratingProyek(id, res).then((v) {
        widget.pauseLoad(false);

        Navigator.pop(context);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          widget.reloadFunc();
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);
      widget.pauseLoad(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  // refresh user
  void _loadDataApi() async {
    setLoadingProgress(true);
    GeneralModel.checCk(
        //connect
        () async {
      ProyekFrelencerModel.getProgress(proyekId, {'q': ''}).then((v) {
        setLoadingProgress(false);
        // widget.pauseLoad(false);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            dataProgress = v.data['proses'];
          });
          // print(dataProgress);
        }
      });
    },
        //disconect
        () {
      setLoadingProgress(false);
      // widget.pauseLoad(false);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  setLoadingProgress(bool kond) {
    setState(() {
      loadingProgress = kond;
    });
  }

  changeToProgress() {
    if (!widget.toProgress) {
      widget.pauseLoad(true);
      _loadDataApi();
    }
    widget.toProgressFunc(proyekId);
  }

  String jnsProyek = 'publik';
  @override
  Widget build(BuildContext context) {
    final paddingPhone = MediaQuery.of(context).padding;

    double marginLeftRight = 10;
    double marginCard = 5;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 5;

    return widget.toProgress
        ? (loadingProgress
            ? onLoading2()
            : (dataProgress.length == 0
                ? dataKosong()
                : Container(
                    height: sizeu.height -
                        340 -
                        widget.bottomKey -
                        paddingPhone.bottom -
                        paddingPhone.top,
                    margin: EdgeInsets.only(
                        left: marginLeftRight, right: marginLeftRight),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: .5,
                        color: Colors.black,
                      ),
                    ),
                    child: ListView.builder(
                        itemCount: dataProgress.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) {
                          Map data = dataProgress[i];
                          return progressScreen(
                              marginLeftRight, marginCard, sizeu.width, data);
                        }),
                  )))
        : proyekList((id) {});
  }

  Widget progressScreen(marginLeftRight, marginCard, _width, data) {
    return Container(
      padding: EdgeInsets.all(marginCard),
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
                  child: imageLoad(
                      dataProyek['proyek']['thumbnail'], false, 50, 50),
                ),
                Container(
                  width: _width - 201,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //judul
                      RichText(
                        text: TextSpan(
                          text: dataProyek['proyek']['judul'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppTheme.primarymenu,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  ' (${dataProyek['proyek']['waktu_pengerjaan'].toString()} HARI)',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //harga
                      RichText(
                          text: TextSpan(
                        text: 'Rp' +
                            decimalPointTwo(
                                dataProyek['proyek']['harga'] ?? '0'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
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
                            dataProyek['status'] != null
                                ? dataProyek['status']
                                : unknown,
                            style: TextStyle(
                              color: AppTheme.nearlyWhite,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      // progress
                      // progressBar(_width - 121 - 50, 30),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ZoomAbleSingleWithDownload(
                          imgUrl: data['bukti_gambar'].toString(),
                          min: 0.1,
                          max: 6,
                        ),
                      ),
                    );
                  },
                  child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Text('LAMPIRAN',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 60),
                            child: FaIcon(
                              FontAwesomeIcons.download,
                              size: 12,
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Pekerjaan #' + data['urutan'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      data['deskripsi'] ?? kontenkosong,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        data['created_at'].toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Progress Pekerjaan #' + data['urutan'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 10),
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

  Widget inputHug(String hint, FaIcon icon, TextEditingController controller) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 3),
      width: sizeu.width,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: icon,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.geyCustom.withOpacity(.2)),
          ),
        ),
        Container(
          child: TextField(
            style: TextStyle(
              fontSize: 13.0,
            ),
            controller: controller,
            maxLength: 45,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              suffixStyle: TextStyle(color: Colors.black),
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
            ),
          ),
          width: sizeu.width - 93,
          padding: EdgeInsets.only(left: 5, right: 5, top: 14),
          alignment: Alignment.centerLeft,
          // height: 25,
          decoration: BoxDecoration(
              color: AppTheme.geySofttCustom.withOpacity(.8),
              border: Border(
                top: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                right: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                bottom: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
              )),
        ),
      ]),
    );
  }

  Widget judulLabel(String judul) {
    return SizedBox(
      height: 18,
      child: Text(
        judul,
        style: TextStyle(
            fontSize: 14,
            color: AppTheme.geySolidCustom,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget proyekList(Function(int id) editEvent) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);
    double imgCard = widthCard / 6;
    double heightCard = 110;
    double widthBtnShort = 85;
    double widthBtnPlay = 40;
    double widthKonten = widthCard - imgCard - widthBtnShort - 2;
    return Container(
        margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
        padding: EdgeInsets.all(marginCard),
        alignment: Alignment.topLeft,
        height: sizeu.height - 360 - widget.bottomKey,
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
            : (widget.dataBid.length == 0
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
                        itemCount: widget.dataBid.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) {
                          return ProyekCard(
                            formRating: (Map res) {
                              komenOwner(context, res);
                            },
                            reload: () {
                              widget.reloadFunc();
                            },
                            saveFile: (url) => _saveFile(url),
                            changeProgress: (res) {
                              setState(() {
                                dataProyek = res;
                                proyekId = res['proyek_id'];
                              });
                              print(dataProyek);
                              changeToProgress();
                            },
                            marginLeftRight: marginLeftRight,
                            marginCard: marginCard,
                            deleteBid: (String id) {
                              //TODO:: delete bid
                            },
                            data: widget.dataBid[i],
                            index: i,
                          );
                        }),
                    onRefresh: widget.reloadFunc,
                    onLoading: widget.nextData,
                  )));
  }
}

class ProyekCard extends StatelessWidget {
  const ProyekCard({
    Key key,
    this.saveFile,
    this.reload,
    this.formRating,
    this.marginLeftRight,
    this.marginCard,
    this.deleteBid,
    this.data,
    this.index,
    this.changeProgress,
  }) : super(key: key);

  final Function(String id) deleteBid;
  final Map data;
  final int index;
  final double marginLeftRight;
  final double marginCard;
  final Function(Map res) changeProgress;
  final Function(String url) saveFile;
  final Function(Map res) formRating;
  final Function() reload;

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
                child: imageLoad(
                    data['proyek'] != null ? data['proyek']['thumbnail'] : null,
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
                        data['proyek'] != null
                            ? data['proyek']['judul']
                            : unknown ?? empty,
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
                        'Rp' +
                            decimalPointTwo(data['proyek'] != null
                                ? data['proyek']['harga'].toString()
                                : '0'),
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
                            (data['proyek'] != null &&
                                    data['proyek']['kategori'] != null
                                ? data['proyek']['kategori']['nama']
                                : unknown) +
                            ":",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      (data['proyek'] != null &&
                              data['proyek']['subkategori'] != null
                          ? data['proyek']['subkategori']['nama']
                          : unknown),
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
                    btnTool(true, 'assets/more_icon/progress_bar.png',
                        BorderRadius.circular(30.0), widthBtnShort - 15, () {
                      // TODO::REDIRECT PENGERJAAN
                      changeProgress(data);
                    }),
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
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primarymenu,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          data['status'] ?? 'belum diketahui',
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
                  moreThan99(data['proyek'] != null
                          ? parseInt(data['proyek']['jumlah_bid'])
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
                  (data['proyek'] != null
                          ? pointGroup(
                              parseInt(data['proyek']['waktu_pengerjaan']))
                          : '0') +
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
    double widthBtnShort = 100;

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
          Stack(children: [
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
                  child: data['pekerja']['foto'] != null
                      ? imageLoad(
                          data['pekerja']['foto'], true, photoWidth, photoWidth)
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
                                    (data['pekerja'].containsKey('nama')
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
                                      (data['pekerja'].containsKey('bintang')
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
                        border: Border(
                          left: BorderSide(
                              width: wightboder,
                              color: AppTheme.geySolidCustom),
                        ),
                      ),
                      child: Text(
                        (data['pekerja'].containsKey('summary')
                            ? data['pekerja']['summary']
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
            InkWell(
              onTap: () {
                saveFile(
                    "https://undagi.my.id/akun/dashboard/pekerja/proyek/download/contract/${data['id'].toString()}");
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: sizeu.width - 175),
                child: Stack(children: [
                  Text(
                    'Surat Kontrak',
                    style: TextStyle(fontSize: 12),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 80),
                      child: FaIcon(FontAwesomeIcons.download, size: 11))
                ]),
                width: widthBtnShort,
                height: 25,
                color: Colors.white,
              ),
            ),
          ]),
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
                        data.containsKey('file_hasil') &&
                                data['file_hasil'].length > 0
                            ? data['file_hasil'].length.toString() + ' lampiran'
                            : empty,
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
                          data['progressable'] == 1,
                          'assets/more_icon/edit-button.png',
                          BorderRadius.circular(30.0),
                          50, () {
                        if (data['progressable'] == 1) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return FileHasilModal(
                                  reload: (msg) {
                                    openAlertSuccessBoxGoon(
                                        context, 'Berhasil', msg, 'OK');
                                    reload();
                                  },
                                  proyekId: data['proyek_id'],
                                );
                              });
                        } else {
                          openAlertBox(
                              context,
                              'Form File Hasil Belum Tersedia',
                              'Form file hasil akan tersedia setelah klien melakukan pembayaran...',
                              konfirm1, () {
                            Navigator.pop(context, false);
                          });
                        }
                        //TODO:: REDIRECT MODAL file jadi
                        // waktuLoadRepeat(560);
                        // pauseLoad(true);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         PaymentProyekScreen(
                        //       proyekId: data['id'],
                        //     ),
                        //   ),
                        // );
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                        ),
                      ),
                      btnTool(
                          data['file_hasil'].length > 0,
                          'assets/more_icon/file_alt.png',
                          BorderRadius.circular(30.0),
                          50, () {
                        if (data['file_hasil'].length > 0) {
                          lampiranPopup(context, data['file_hasil']);
                        } else {
                          openAlertBox(
                              context,
                              'File Hasil Masih Kosong',
                              'Harap isi File Hasil dengan mengisi Form File Hasil',
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
                      'ULASAN KLIEN',
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
                        child: data['ulasan']['ulasan_pekerja'] != null
                            ? imageLoad(
                                data['ulasan']['ulasan_pekerja']['foto'],
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
                                            (data['ulasan']['ulasan_pekerja'] !=
                                                    null
                                                ? data['ulasan']
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
                                            (data['ulasan']['ulasan_pekerja'] !=
                                                        null &&
                                                    data['ulasan'][
                                                                'ulasan_pekerja']
                                                            ['bintang'] !=
                                                        null
                                                ? data['ulasan']
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
                                  (data['ulasan']['ulasan_pekerja'] != null &&
                                          data['ulasan']['ulasan_pekerja']
                                                  ['deskripsi'] !=
                                              null
                                      ? data['ulasan']['ulasan_pekerja']
                                              ['deskripsi']
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
              )),

          Container(
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
                        child: data['ulasan']['ulasan_klien'] != null
                            ? imageLoad(data['ulasan']['ulasan_klien']['foto'],
                                true, photoWidth, photoWidth)
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
                                            (data['ulasan']['ulasan_klien'] !=
                                                        null &&
                                                    data['ulasan']
                                                                ['ulasan_klien']
                                                            ['nama'] !=
                                                        null
                                                ? data['ulasan']['ulasan_klien']
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
                                            (data['ulasan']['ulasan_klien'] !=
                                                        null &&
                                                    data['ulasan']
                                                                ['ulasan_klien']
                                                            ['bintang'] !=
                                                        null
                                                ? data['ulasan']['ulasan_klien']
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
                                  (data['ulasan']['ulasan_klien'] != null &&
                                          data['ulasan']['ulasan_klien']
                                                  ['deskripsi'] !=
                                              null
                                      ? data['ulasan']['ulasan_klien']
                                              ['deskripsi']
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
                      btnTool(
                          data['ratingable'].toString() == '1',
                          'assets/more_icon/edit-button.png',
                          BorderRadius.circular(30.0),
                          50, () {
                        if (data['ratingable'].toString() == '1') {
                          formRating(data);
                        } else {
                          openAlertBox(
                              context,
                              'Form Ulasan Klien Belum Tersedia',
                              'Form akan Tersedia ketika klien sudah melakukan ulasan...',
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

  lampiranPopup(context, dataLampiran) {
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
                      'FILE HASIL',
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
                                                  saveFile(dataLampiran[i]);
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
          color: active ? Colors.white : Colors.white.withOpacity(.4),
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
