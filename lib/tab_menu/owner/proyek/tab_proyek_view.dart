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
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/proyek_owner_model.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TabProyekView extends StatefulWidget {
  const TabProyekView(
      {Key key,
      this.paddingTop,
      this.dataReresh,
      this.dataNext,
      this.refresh,
      this.paddingBottom,
      this.loading,
      this.dataProyek,
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

  final List dataProyek;
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
  _TabProyekViewState createState() => _TabProyekViewState();
}

class _TabProyekViewState extends State<TabProyekView> {
  TextEditingController inputKategori = new TextEditingController();

  final picker = ImagePicker();
  String imgBase64;

  int progress = 0;

  //for trigger lampiran add or delete
  int idProyekLampiran;
  String namaLampiran; //for delete lampiran
  List dataLampiran = [];

  Map error={};

  ReceivePort _receivePort = ReceivePort();

  setErrorNotif(Map v) {
    setState(() {
      error = v;
    });
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

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
    onLoading(context);
    Map dataSend = {
      'judul': widget.judulController.text.toString(),
      'jenis': widget.jnsProyek,
      'waktu_pengerjaan': widget.waktuController.text.toString(),
      'harga': widget.hargaController.text.toString(),
      'deskripsi': widget.deskripsiController.text.toString(),
      'kategori': widget.kategoriSelect['id'].toString(),
    };
    // if (widget.editId > 0) {
    //   dataSend['id'] = widget.editId.toString();
    // }

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      ProyekOwnerModel.addProyek(dataSend, widget.lampiran, widget.image,
              (widget.editId > 0 ? widget.editId.toString() : null))
          .then((v) {
        Navigator.pop(context);

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
      Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  _deleteLampiran() async {
    onLoading(context);
    Map dataSend = {
      'proyek_id': idProyekLampiran.toString(),
      'nama_lampiran': namaLampiran,
    };
    // if (widget.editId > 0) {
    //   dataSend['id'] = widget.editId.toString();
    // }

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      ProyekOwnerModel.hapusLampiran(dataSend).then((v) {
        Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            // setErrorNotif(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context);
          widget.reloadGetApi();
          openAlertSuccessBox(context, 'Berhasil!', v.data['message'], 'OK',
              () {
            Navigator.pop(context);
          });
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

  _addLampiran(lampiran) async {
    onLoading(context);
    Map dataSend = {
      'proyek_id': idProyekLampiran.toString(),
   
    };
    // if (widget.editId > 0) {
    //   dataSend['id'] = widget.editId.toString();
    // }

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      ProyekOwnerModel.addLampiran(dataSend,lampiran).then((v) {
        Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            // setErrorNotif(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context);
          widget.reloadGetApi();
          openAlertSuccessBox(context, 'Berhasil!', v.data['message'], 'OK',
              () {
            Navigator.pop(context);
          });
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


  _deleteApi(String id) async {
    onLoading(context);

    GeneralModel.checCk(
        //connect
        () async {
      // setErrorNotif({});
      ProyekOwnerModel.hapusProyek(id).then((v) {
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

  void lampiranSet() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'gif',
        'png',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'odt',
        'ppt',
        'pptx'
      ],
      allowCompression: true,
    );

    List<File> selectionLamp = <File>[];
    List<String> moreThan5Mb = [];

    if (result != null) {
      widget.changeLampiran(<File>[]);

      result.paths.map((path) => File(path)).toList().forEach((element) {
        if (element.lengthSync() <= 5e+6) {
          selectionLamp.add(element);
        } else {
          moreThan5Mb.add(element.path.split('/').last);
        }
      });

      widget.changeLampiran(selectionLamp);
    } else {
      // User canceled the picker
    }

    widget.changeLampiranText(selectionLamp.length > 0
        ? selectionLamp.length.toString() + ' file dipilih'
        : '');

    if (moreThan5Mb.length > 0) {
      openAlertBox(
          context,
          'Pemberitahuan!',
          moreThan5Mb.join(', ') + ' melebih quota 5MB/lampiran',
          'OK',
          () => Navigator.pop(context));
    }
  }

  void tambahlampiranSet() async {
    List<File> lampiran=[];
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'gif',
        'png',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'odt',
        'ppt',
        'pptx'
      ],
      allowCompression: true,
    );

    List<File> selectionLamp = <File>[];
    List<String> moreThan5Mb = [];

    if (result != null) {
     

      result.paths.map((path) => File(path)).toList().forEach((element) {
        if (element.lengthSync() <= 5e+6) {
          selectionLamp.add(element);
        } 
      });

      lampiran=selectionLamp;
    } else {
      // User canceled the picker
    }

    if (moreThan5Mb.length > 0) {
      openAlertBox(
          context,
          'Pemberitahuan!',
          moreThan5Mb.join(', ') + ' melebih quota 5MB/lampiran',
          'OK',
          () => Navigator.pop(context));
    }else{
      _addLampiran(lampiran);
    }
    
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

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
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
                  (widget.editId != 0 ? 'UPDATE' : 'TAMBAH') + ' PROYEK',
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
                                  judul: 'Kategori Proyek',
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
                                    : 'Kategori proyek anda',
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
                        'Judul Proyek',
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
                            hintText: 'Deskripsi terkait proyek anda',
                          ),
                        ),
                      ),
                    noticeText('deskripsi', error),
                      
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (sizeu.width - 137) / 2,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Batas Waktu Proyek',
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
                    noticeText('waktu_pengerjaan', error),
                                
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
                            width: (sizeu.width - 137) / 2,
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
                                    width: (sizeu.width - 137) / 2 - 60,
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
                                widget.editId == 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            Text(
                                              'Lampiran',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      AppTheme.geySolidCustom,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 3)),
                                            InkWell(
                                              onTap: () => lampiranSet(),
                                              child: Row(children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme
                                                        .geySofttCustom
                                                        .withOpacity(.8),
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: AppTheme
                                                            .geyCustom
                                                            .withOpacity(.4),
                                                      ),
                                                      bottom: BorderSide(
                                                        color: AppTheme
                                                            .geyCustom
                                                            .withOpacity(.4),
                                                      ),
                                                      left: BorderSide(
                                                        color: AppTheme
                                                            .geyCustom
                                                            .withOpacity(.4),
                                                      ),
                                                    ),
                                                  ),
                                                  width:
                                                      (sizeu.width - 137) / 2 -
                                                          30,
                                                  height: 25,
                                                  child: IgnorePointer(
                                                    child: TextField(
                                                      controller: widget
                                                          .lampiranController,
                                                      style: TextStyle(
                                                        fontSize: 11.0,
                                                      ),
                                                      maxLength: 4,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10.0,
                                                                horizontal: 5),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: '',
                                                        suffixStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        counterStyle: TextStyle(
                                                          height: double
                                                              .minPositive,
                                                        ),
                                                        counterText: "",
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
                                                          color: AppTheme
                                                              .geyCustom
                                                              .withOpacity(.2)),
                                                    ),
                                                    child: Icon(
                                                      Icons.insert_drive_file,
                                                      size: 12,
                                                    )),
                                              ]),
                                            ),
                    noticeText('lampiran', error),
                                          
                                          ])
                                    : Container()
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.changeJenis('publik');
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width: sizeu.width - 250,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.jnsProyek == 'publik'
                                          ? AppTheme.primarymenu
                                          : AppTheme.nearlyWhite,
                                      border: Border.all(
                                          color: widget.jnsProyek == 'publik'
                                              ? Colors.transparent
                                              : AppTheme.geyCustom,
                                          width: 1),
                                    ),
                                    child: Text(
                                      'Publik',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: widget.jnsProyek == 'publik'
                                              ? AppTheme.nearlyWhite
                                              : AppTheme.primarymenu),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.changeJenis('privat');
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.jnsProyek == 'privat'
                                          ? AppTheme.primaryRed
                                          : AppTheme.nearlyWhite,
                                      border: Border.all(
                                          color: widget.jnsProyek == 'privat'
                                              ? Colors.transparent
                                              : AppTheme.geyCustom,
                                          width: 1),
                                    ),
                                    child: Text(
                                      'Privat',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: widget.jnsProyek == 'privat'
                                              ? AppTheme.nearlyWhite
                                              : AppTheme.primarymenu),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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
          : (widget.dataProyek.length == 0
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
                      itemCount: widget.dataProyek.length,
                      // itemExtent: 100.0,
                      itemBuilder: (c, i) {
                        // transColor();
                        return cardProyek(widget.dataProyek[i], i);
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              btnTool(
                                  'assets/more_icon/info.png',
                                  BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ), () {
                                print('info');
                              }, true),
                              btnTool(
                                  'assets/more_icon/file_alt.png',
                                  BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ), () {
                                setState(() {
                                  dataLampiran = data['lampiran'];
                                  idProyekLampiran = data['id'];
                                });

                                lampiranPopup(context);
                              }, true),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
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
                                if (data['editable'] == 1) {
                                  widget.editEvent(data['id']);
                                  widget.toAddFunc();
                                  widget.valueEdit(data);
                                } else {
                                  openAlertBox(
                                      context,
                                      'Proyek telah dikerjakan!',
                                      'Proyek tidak bisa diubah...',
                                      'OK', () {
                                    Navigator.pop(context);
                                  });
                                }
                              }, data['editable'] == 1 ? true : false),
                              btnTool(
                                  'assets/more_icon/remove-file.png',
                                  BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ), () {
                                if (data['editable'] == 1) {
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

                                      _deleteApi(data['id'].toString());
                                    },
                                  );
                                } else {
                                  openAlertBox(
                                      context,
                                      'Proyek telah dikerjakan!',
                                      'Proyek tidak bisa dihapus...',
                                      'OK', () {
                                    Navigator.pop(context);
                                  });
                                }
                              }, data['editable'] == 1 ? true : false),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //BUTTON PLAY
                    // Container(
                    //   height: heightCard,
                    //   width: widthBtnPlay,
                    //   alignment: Alignment.centerRight,
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         width: 40,
                    //         height: 40,
                    //         decoration: BoxDecoration(
                    //           image: DecorationImage(
                    //             image: AssetImage(
                    //                 'assets/home/circle_quatral.png'),
                    //             fit: BoxFit.fitHeight,
                    //           ),
                    //           // borderRadius:
                    //           //     BorderRadius.all(Radius.circular(20)),
                    //         ),
                    //         child: Icon(
                    //           Icons.play_arrow,
                    //           color: AppTheme.textPink,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'TOTAL BID: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      moreThan99((data['total_bid'] ?? 0)) + ' ORANG  ',
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
                              int.parse(data['waktu_pengerjaan'].toString()) ??
                                  0) +
                          ' Hari',
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  lampiranPopup(context) {
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
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 40,
                                              width: double.infinity,
                                              margin:
                                                  EdgeInsets.only(right: 30),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    namaLampiran = nama;
                                                  });
                                                  openAlertBoxTwo(
                                                    context,
                                                    'KONFIRMASI HAPUS LAMPIRAN',
                                                    'Apa anda yakin hapus lampiran ini? lampiran akan hilang!',
                                                    'TIDAK',
                                                    'HAPUS',
                                                    () {
                                                      Navigator.pop(context);
                                                    },
                                                    () {
                                                      Navigator.pop(context);

                                                      _deleteLampiran();
                                                    },
                                                  );
                                                },
                                                child: FaIcon(
                                                  FontAwesomeIcons.trash,
                                                  color: Colors.grey[700],
                                                  size: 16,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                          ),
                          Container(
                            // padding: EdgeInsets.only(top: 15),
                            width: double.infinity,
                            // alignment: Alignment.topRight,
                            child: RaisedButton(
                              onPressed: () {
                               tambahlampiranSet();
                              },
                              color: AppTheme.bgChatBlue,
                              child: Text(
                                'TAMBAH',
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
