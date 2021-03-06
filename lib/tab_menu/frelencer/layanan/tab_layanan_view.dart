import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/choose_select.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/frelencer/layanan_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/proyek_owner_model.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_layanan_detail.dart';

class TabLayananView extends StatefulWidget {
  const TabLayananView(
      {Key key,
      this.paddingTop,
      this.dataReresh,
      this.dataNext,
      this.refresh,
      this.paddingBottom,
      this.loading,
      this.dataLayanan,
      this.editEvent,
      this.editId = 0,
      this.valueEdit,
      this.bottomKey = 0,
      this.toAdd,
      this.changeKategori,
      this.changeImg,
      this.changeThumb,
      this.changeLampiran,
      this.changeLampiranText,
      this.changeJenis,
      this.judulController,
      this.lampiran,
      this.reloadGetApi,
      this.thumbController,
      this.lampiranController,
      this.waktuController,
      this.hargaController,
      this.deskripsiController,
      this.kategoriSelect,
      this.image,
      this.jnsProyek,
      this.toAddFunc})
      : super(key: key);

  final List dataLayanan;
  final Function dataReresh;
  final Function dataNext;
  final RefreshController refresh;

  final double bottomKey;
  final double paddingTop;
  final double paddingBottom;
  final Function toAddFunc;
  final bool toAdd;
  final bool loading;
  final int editId;
  final Function(int id) editEvent;

  final Function(Map v) changeKategori;
  final Function(File v) changeImg;
  final Function(String v) changeThumb;

  final Function(List<File> v) changeLampiran;
  final Function(String v) changeLampiranText;
  final Function(String v) changeJenis;
  final Function() reloadGetApi;
  final Function(Map dt) valueEdit;

  final TextEditingController judulController;
  final List<File> lampiran;
  final TextEditingController thumbController;
  final TextEditingController lampiranController;
  final TextEditingController waktuController;
  final TextEditingController hargaController;
  final TextEditingController deskripsiController;
  final Map kategoriSelect;
  final File image;
  final String jnsProyek;

  @override
  _TabLayananViewState createState() => _TabLayananViewState();
}

class _TabLayananViewState extends State<TabLayananView> {
  TextEditingController inputKategori = new TextEditingController();

  final picker = ImagePicker();
  String imgBase64;

  int progress = 0;

  //for trigger lampiran add or delete
  int idProyekLampiran;
  String namaLampiran; //for delete lampiran
  List dataLampiran = [];

  Map error = {};

  setErrorNotif(Map v) {
    setState(() {
      error = v;
    });
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("Undangi");

    ///ssending the data
    sendPort.send([id, status, progress]);
  }

  //ambil gambar camera
  Future getImageCamera(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      await widget.changeImg(File(pickedFile.path));

      // File imageResized = await FlutterNativeImage.compressImage(widget.image.path,
      //     quality: 100, targetWidth: 120, targetHeight: 120);

      // List<int> imageBytes = File(pickedFile.path).readAsBytesSync();

      // imgBase64 = base64Encode(imageBytes);
      setState(() {});

      setThumb(File(pickedFile.path));

      // _showPicker(context);
    } else {
      print('No image selected.');
    }
  }

//image from galery
  Future getImageGalerry(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    await widget.changeImg(File(pickedFile.path));

    // List<int> imageBytes = widget.image.readAsBytesSync();

    // imgBase64 = base64Encode(imageBytes);

    setState(() {
      if (pickedFile != null) {
        // _showPicker(context);
      } else {
        print('No image selected.');
      }
    });
    setThumb(File(pickedFile.path));
  }

  setThumb(File img) => widget.changeThumb(img.path.split('/').last);

  //op imgae picker
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Wrap(
                    children: [
                      new ListTile(
                          leading: new Icon(Icons.photo_library),
                          title: new Text('Ambil dari galleri'),
                          onTap: () {
                            getImageGalerry(context);
                            Navigator.of(context).pop();
                          }),
                      new ListTile(
                        leading: new Icon(Icons.photo_camera),
                        title: new Text('Ambil dari kamera'),
                        onTap: () {
                          getImageCamera(context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _saveApi() async {
    // onLoading(context);
    Map dataSend = {
      'judul': widget.judulController.text.toString(),
      'jenis': widget.jnsProyek,
      'pengerjaan': widget.waktuController.text.toString(),
      'harga': widget.hargaController.text.toString(),
      'deskripsi': widget.deskripsiController.text.toString(),
      'kategori': widget.kategoriSelect['id'].toString(),
    };
    if (widget.editId > 0) {
      dataSend['id'] = widget.editId.toString();
    }

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      LayananFrelencerModel.addLayanan(dataSend, widget.lampiran, widget.image,
              (widget.editId > 0 ? widget.editId.toString() : null))
          .then((v) {
        // Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setErrorNotif(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
          } else {
            errorRespon(context, v.data);
          }
        } else {
          widget.editEvent(0);
          widget.toAddFunc();
          widget.reloadGetApi();
        }
      });
    },
        //disconect
        () {
      // Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  _deleteApi(String id) async {
    onLoading(context);

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      LayananFrelencerModel.hapusLayanan(id).then((v) {
        Navigator.pop(context);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          widget.reloadGetApi();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double marginLeftRight = 10;
    double marginCard = 5;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 5;

    return widget.toAdd
        ? Container(
            width: sizeu.width - marginLeftRight,
            margin: EdgeInsets.only(left: marginLeftRight),
            height: sizeu.height -
                310 -
                widget.bottomKey -
                widget.paddingBottom -
                widget.paddingTop,
            padding: EdgeInsets.all(marginCard),
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                left: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  (widget.editId != 0 ? 'UPDATE' : 'TAMBAH') + ' LAYANAN',
                  style: TextStyle(
                      color: AppTheme.textBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.geyCustom)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: judulLabel('Kategori')),
                          Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    widget.toAddFunc();
                                    widget.editEvent(0);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.times,
                                    size: 13,
                                    color: AppTheme.geyCustom,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseSelect(
                                  op: widget.kategoriSelect,
                                  grup: true,
                                  judul: 'Kategori Layanan',
                                  url: 'grup_kategori' +
                                      (widget.kategoriSelect['id'] == null
                                          ? ''
                                          : '?id=' +
                                              widget.kategoriSelect['id']
                                                  .toString()),
                                  setValue: (Map v) =>
                                      widget.changeKategori(v)),
                            )),
                        child: IgnorePointer(
                          child: Stack(
                            children: [
                              inputHug(
                                widget.kategoriSelect['nama'] != ''
                                    ? widget.kategoriSelect['nama'].toString()
                                    : 'Kategori Layanan anda',
                                FaIcon(
                                  FontAwesomeIcons.tag,
                                  size: 16,
                                ),
                                inputKategori,
                              ),
                              Container(
                                  alignment: Alignment.topRight,
                                  height: 30,
                                  padding: EdgeInsets.only(right: 20, top: 10),
                                  child: FaIcon(
                                    FontAwesomeIcons.chevronDown,
                                    color: AppTheme.geyCustom,
                                    size: 14,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      noticeText('kategori', error),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      judulLabel('Judul'),
                      inputHug(
                        'Judul Layanan',
                        FaIcon(
                          FontAwesomeIcons.pen,
                          size: 16,
                        ),
                        widget.judulController,
                      ),
                      noticeText('judul', error),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      judulLabel('Deskripsi'),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 13.0, height: 1, color: Colors.black),
                          controller: widget.deskripsiController,
                          textAlign: TextAlign.start,
                          maxLines: 4,
                          maxLength: 250,
                          onChanged: (text) => {setState(() {})},
                          decoration: new InputDecoration(
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1),
                            ),
                            hintText: 'Deskripsi terkait Layanan anda',
                          ),
                        ),
                      ),
                      noticeText('deskripsi', error),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (sizeu.width - 137 + 35) / 2,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Batas Waktu Layanan',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),

                                Padding(padding: EdgeInsets.only(top: 3)),

                                //batas waktu
                                Row(children: [
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.calendarCheck,
                                      size: 9,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: ((sizeu.width - 137) / 2) - 60,
                                    height: 25,
                                    child: TextField(
                                      controller: widget.waktuController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: Text(
                                      'Hari',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ]),
                                noticeText('pengerjaan', error),

                                Padding(padding: EdgeInsets.only(top: 3)),
                                Text(
                                  'Thumbnail',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                Row(children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        left: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: (sizeu.width - 137) / 2 - 30,
                                    height: 25,
                                    child: InkWell(
                                      onTap: () => _showPicker(context),
                                      child: IgnorePointer(
                                        child: TextField(
                                          controller: widget.thumbController,
                                          style: TextStyle(
                                            fontSize: 11.0,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    bottom: 13,
                                                    left: 5,
                                                    right: 5),
                                            border: InputBorder.none,
                                            hintText: '',
                                            suffixStyle:
                                                TextStyle(color: Colors.black),
                                            counterStyle: TextStyle(
                                              height: double.minPositive,
                                            ),
                                            counterText: "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.geyCustom
                                                .withOpacity(.2)),
                                      ),
                                      child: Icon(
                                        Icons.file_upload,
                                        size: 12,
                                      )),
                                ]),
                                noticeText('thumbnail', error),
                              ],
                            ),
                          ),
                          Container(
                            width: (sizeu.width - 137 + 35) / 2,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga Layanan',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                //batas waktu
                                Row(children: [
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: Text(
                                      'Rp',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: (sizeu.width - 137 + 35) / 2 - 60,
                                    height: 25,
                                    child: TextField(
                                      controller: widget.hargaController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 9,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.geyCustom
                                                .withOpacity(.2)),
                                      ),
                                      child: Icon(
                                        Icons.attach_money,
                                        size: 12,
                                      )),
                                ]),
                                noticeText('harga', error),

                                Padding(padding: EdgeInsets.only(top: 3)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, top: 5),
                        height: 25,
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 80,
                          child: RaisedButton(
                            onPressed: () {
                              _saveApi();
                              // print(widget.lampiran);
                            },
                            color: AppTheme.primaryBlue,
                            child: Text(
                                widget.editId != 0 ? 'Update' : 'Simpan',
                                style: TextStyle(
                                    color: AppTheme.white, fontSize: 14)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : proyekList();
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

  Widget proyekList() {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    return Container(
      margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
      padding: EdgeInsets.all(marginCard),
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
          : (widget.dataLayanan.length == 0
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
                      itemCount: widget.dataLayanan.length,
                      // itemExtent: 100.0,
                      itemBuilder: (c, i) {
                        // transColor();
                        return cardProyek(widget.dataLayanan[i], i);
                      }),
                  onRefresh: widget.dataReresh,
                  onLoading: widget.dataNext,
                )),
    );
  }

  int colorChange = 0;

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

  Widget cardProyek(Map data, int i) {
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
    double widthKonten = widthCard - imgCard - widthBtnShort - widthBtnPlay - 2;

    return Container(
        // height: heightCard + 55,
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        padding: EdgeInsets.all(paddingCard),
        decoration: BoxDecoration(
          color: AppTheme.renoReno[transColor(i)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widthKonten + widthBtnPlay,
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    data['judul'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppTheme.primarymenu,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //konten
                    Container(
                      width: widthKonten + widthBtnPlay,
                      // height: heightCard,
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rp' + decimalPointTwo(data['harga'].toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              data['deskripsi'] ?? empty,
                              style: TextStyle(
                                // color: AppTheme.primarymenu,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
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
                                  pointGroup(int.parse(data['hari_pengerjaan']
                                              .toString()) ??
                                          0) +
                                      ' Hari',
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // row shorcut
                    Container(
                      height: heightCard,
                      width: widthBtnShort,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TampilanPublikLayananDetail(
                                              id: data['id'])));
                            },
                            child: Container(
                              width: 80,
                              height: 30,
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.fromLTRB(5, 7, 5, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    width: .5,
                                    color: AppTheme.nearlyBlack,
                                  ),
                                  color: (true
                                      ? Colors.white
                                      : AppTheme.geySoftCustom
                                          .withOpacity(.3))),
                              child: Image.asset(
                                'assets/more_icon/info.png',
                                alignment: Alignment.center,
                                // scale: 6,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              btnTool(
                                  'assets/more_icon/edit-button.png',
                                  BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ), () {
                                if (data['can_delete'] == '1') {
                                  widget.editEvent(data['id']);
                                  widget.toAddFunc();
                                  widget.valueEdit(data);
                                } else {
                                  openAlertBox(
                                      context,
                                      'Layanan Tidak Bisa Diubah',
                                      'Masih ada layanan yang masih dikerjakan',
                                      'OK', () {
                                    Navigator.pop(context);
                                  });
                                }
                              }, data['can_delete'] == '1' ? true : false),
                              btnTool(
                                  'assets/more_icon/remove-file.png',
                                  BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ), () {
                                if (data['can_delete'] == '1') {
                                  openAlertBoxTwo(
                                    context,
                                    'Konfirmasi Hapus Layanan',
                                    'Apa anda yakin hapus Layanan ini? Layanan akan hilang!',
                                    'TIDAK',
                                    'HAPUS',
                                    () {
                                      Navigator.pop(context);
                                    },
                                    () {
                                      Navigator.pop(context);

                                      _deleteApi(data['id'].toString());
                                    },
                                  );
                                } else {
                                  openAlertBox(
                                      context,
                                      'Layanan Tidak Bisa Dihapus',
                                      'Masih ada layanan yang masih dikerjakan',
                                      'OK', () {
                                    Navigator.pop(context);
                                  });
                                }
                              }, data['can_delete'] == '1' ? true : false),
                            ],
                          ),
                          Container(
                            height: 25,
                            width: 80,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: AppTheme.bgChatBlue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              moreThan99(parseInt(data['jumlah_klien']) ?? 0) + ' KLIEN',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: AppTheme.nearlyWhite,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget btnTool(String locationImg, BorderRadius radius, Function linkRedirect,
      bool active) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: 40,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              width: .5,
              color: AppTheme.nearlyBlack,
            ),
            color: (active
                ? Colors.white
                : AppTheme.geySoftCustom.withOpacity(.3))),
        child: Image.asset(
          locationImg,
          alignment: Alignment.center,
          // scale: 6,
        ),
      ),
    );
  }
}
