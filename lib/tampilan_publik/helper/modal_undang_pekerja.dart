import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/html_read.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/Constant/choose_select.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:undangi/tab_menu/owner/proyek/sub/payment_proyek_screen.dart';

class ModalUdangPekerja extends StatefulWidget {
  @override
  _ModalUdangPekerjaState createState() => _ModalUdangPekerjaState();

  const ModalUdangPekerja(
      {Key key, this.userId, this.loadAgain, this.bottom, this.other})
      : super(key: key);

  final String userId;
  final Function loadAgain;
  final double bottom;
  final Map other;
}

class _ModalUdangPekerjaState extends State<ModalUdangPekerja> {
  Map idProyek;
  String namaProyek;

  final picker = ImagePicker();
  String imgBase64;
  File _image;
  List<File> lampiran = <File>[];

  TextEditingController kategoriController = new TextEditingController();
  TextEditingController judulController = new TextEditingController();
  TextEditingController deskripsiController = new TextEditingController();
  TextEditingController waktuController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController thumbController = new TextEditingController();
  TextEditingController lampiranController = new TextEditingController();
  Map kategoriSelect = {
    "id": '',
    "nama": '',
  };

  setLampiran(List<File> v) {
    setState(() {
      lampiran = v;
    });
  }

  setLampiranText(String v) {
    setState(() {
      lampiranController.text = v;
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
      setLampiran(<File>[]);

      result.paths.map((path) => File(path)).toList().forEach((element) {
        if (element.lengthSync() <= 5e+6) {
          selectionLamp.add(element);
        } else {
          moreThan5Mb.add(element.path.split('/').last);
        }
      });

      setLampiran(selectionLamp);
    } else {
      // User canceled the picker
    }

    setLampiranText(selectionLamp.length > 0
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

  //ambil gambar camera
  Future getImageCamera(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

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

    _image = File(pickedFile.path);

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

  setThumb(File img) {
    setState(() {
      thumbController.text = img.path.split('/').last;
    });
  }

  _saveApi() async {
    onLoading(context);
    Map dataSend = {
      'judul': judulController.text.toString(),
      'user_id': widget.userId.toString(),
      'waktu_pengerjaan': waktuController.text.toString(),
      'harga': hargaController.text.toString(),
      'deskripsi': deskripsiController.text.toString(),
      'kategori': kategoriSelect['id'].toString(),
    };

    // print(dataSend);

    GeneralModel.checCk(
        //connect
        () async {
      setError({});
      PublikModel.invitePrivate(dataSend, lampiran, _image).then((v) {
        Navigator.pop(context);

        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setError(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
          } else {
            errorRespon(context, v.data);
          }
        } else {
          //TODO:: AFTER SUCCESS
          Navigator.pop(context);
          openAlertSuccessBoxGoon(
              context, 'Berhasil', v.data['message'], 'OK');
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

  InputDecoration textfieldDesign(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      counterStyle: TextStyle(
        height: double.minPositive,
      ),
      counterText: "",
    );
  }

  bool setujuAnggrement = true;

  Map error = {};

  setError(Map data) {
    setState(() {
      error = data;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 8;

    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          // height: sizeu.height,
          width: sizeu.width,
          margin: EdgeInsets.only(top: 40.0),

          child: Align(
            alignment: Alignment(0, -1),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                width: sizeu.width - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: SizedBox(
                                width: 80,
                                child: Image.asset(
                                  'assets/general/logo.png',
                                  width: 80,
                                  fit: BoxFit.fitWidth,
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(right: 8),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: FaIcon(
                                      FontAwesomeIcons.times,
                                      size: 14,
                                    )),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 5.0,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(.1),
                                  width: .5))),
                    ),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          // border: Border(
                          // bottom: BorderSide(width: .5,color: Colors.grey.withOpacity(.5))
                          // ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: 3.0,
                                offset: Offset(0.0, 0.75))
                          ]),
                    ),
                    Container(
                      height: 470 -
                          bottom +
                          (bottom > 0 ? (sizeu.height - 470 - 120) : 0),
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          judulLabel('Kategori'),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseSelect(
                                      op: kategoriSelect,
                                      grup: true,
                                      judul: 'Kategori Proyek',
                                      url: 'grup_kategori?id=',
                                      setValue: (Map v) {
                                        setState(() {
                                          kategoriSelect = v;
                                          kategoriController.text = v['nama'];
                                        });
                                      }),
                                )),
                            child: IgnorePointer(
                              child: Stack(
                                children: [
                                  inputHug(
                                    'Pilih Kategori',
                                    FaIcon(
                                      FontAwesomeIcons.tag,
                                      size: 16,
                                    ),
                                    kategoriController,
                                  ),
                                  Container(
                                      alignment: Alignment.topRight,
                                      height: 30,
                                      padding:
                                          EdgeInsets.only(right: 10, top: 15),
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
                            judulController,
                          ),
                          noticeText('judul', error),
                          Padding(padding: EdgeInsets.only(top: gangInput)),
                          judulLabel('Deskripsi'),
                          Container(
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 16.0,
                                  height: 1,
                                  color: Colors.black),
                              controller: deskripsiController,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              maxLength: 250,
                              onChanged: (text) => {setState(() {})},
                              decoration: new InputDecoration(
                                counterText: "",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black54, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black38, width: 1),
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
                                  width: (sizeu.width - 56) / 2,
                                  margin: EdgeInsets.only(right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      judulLabel('Batas Waktu'),

                                      //batas waktu
                                      Row(children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.geyCustom
                                                    .withOpacity(.2)),
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.calendarCheck,
                                            size: 14,
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
                                          width: ((sizeu.width - 56) / 2) - 80,
                                          height: 40,
                                          child: TextField(
                                            controller: waktuController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                            maxLength: 4,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5),
                                              border: InputBorder.none,
                                              hintText: '',
                                              suffixStyle: TextStyle(
                                                  color: Colors.black),
                                              counterStyle: TextStyle(
                                                height: double.minPositive,
                                              ),
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.geyCustom
                                                    .withOpacity(.2)),
                                          ),
                                          child: Text(
                                            'Hari',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ]),
                                      noticeText('waktu_pengerjaan', error),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(top: gangInput)),
                                      judulLabel('Thumbnail'),

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
                                          width: (sizeu.width - 56) / 2 - 40,
                                          height: 40,
                                          child: InkWell(
                                            onTap: () => _showPicker(context),
                                            child: IgnorePointer(
                                              child: TextField(
                                                controller: thumbController,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 5),
                                                  border: InputBorder.none,
                                                  hintText: '',
                                                  suffixStyle: TextStyle(
                                                      color: Colors.black),
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
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppTheme.geyCustom
                                                      .withOpacity(.2)),
                                            ),
                                            child: Icon(
                                              Icons.file_upload,
                                              size: 16,
                                            )),
                                      ]),
                                      noticeText('thumbnail', error),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (sizeu.width - 56) / 2,
                                  margin: EdgeInsets.only(right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      judulLabel('Harga Layanan'),

                                      //batas waktu
                                      Row(children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.geyCustom
                                                    .withOpacity(.2)),
                                          ),
                                          child: Text(
                                            'Rp',
                                            style: TextStyle(fontSize: 14),
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
                                          width: (sizeu.width - 56) / 2 - 80,
                                          height: 40,
                                          child: TextField(
                                            controller: hargaController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                            maxLength: 9,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5),
                                              border: InputBorder.none,
                                              hintText: '',
                                              suffixStyle: TextStyle(
                                                  color: Colors.black),
                                              counterStyle: TextStyle(
                                                height: double.minPositive,
                                              ),
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppTheme.geyCustom
                                                      .withOpacity(.2)),
                                            ),
                                            child: Icon(
                                              Icons.attach_money,
                                              size: 16,
                                            )),
                                      ]),
                                      noticeText('harga', error),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(top: gangInput)),

                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            judulLabel('Lampiran'),
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
                                                      (sizeu.width - 56) / 2 -
                                                          40,
                                                  height: 40,
                                                  child: IgnorePointer(
                                                    child: TextField(
                                                      controller:
                                                          lampiranController,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ),
                                                      maxLength: 4,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10,
                                                                bottom: 5),
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
                                                    width: 40,
                                                    height: 40,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppTheme
                                                              .geyCustom
                                                              .withOpacity(.2)),
                                                    ),
                                                    child: Icon(
                                                      Icons.insert_drive_file,
                                                      size: 16,
                                                    )),
                                              ]),
                                            ),
                                            noticeText('lampiran', error),
                                          ])
                                    ],
                                  ),
                                ),
                              ]),

                          // Padding(
                          //   padding:
                          //       const EdgeInsets.only(left: 10, top: 0, bottom: 0),
                          //   child: Row(
                          //     children: [
                          //       SizedBox(
                          //         width: 20,
                          //         child: Checkbox(
                          //           value: setujuAnggrement,
                          //           onChanged: (bool value) {
                          //             setState(() {
                          //               setujuAnggrement = value;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //       InkWell(
                          //           onTap: () {
                          //             setState(() {
                          //               setujuAnggrement = !setujuAnggrement;
                          //             });
                          //           },
                          //           child: Text(' Saya Setuju terkait ')),
                          //       InkWell(
                          //         onTap: () async {
                          //           String token = '';
                          //           await GeneralModel.token().then((value) {
                          //             token = value.res;
                          //           });
                          //           if(namaProyek!=null){
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (BuildContext context) => HtmlRead(
                          //                 url: globalBaseUrl +
                          //                     'aggrement_proyek?name=' +
                          //                     (namaProyek ?? 'tidak ada proyek') +
                          //                     '&token=' +
                          //                     token,
                          //               ),
                          //             ),
                          //           );
                          //             } else {
                          //             openAlertBox(context, 'Pemberitahuan!',
                          //                 'Harap Pilih Proyek dulu!', 'OK', () {
                          //               Navigator.pop(context);
                          //             });
                          //           }
                          //         },
                          //         child: Text(
                          //           'Syarat dan Ketentuan',
                          //           style: TextStyle(
                          //             color: AppTheme.bgChatBlue,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          Padding(padding: EdgeInsets.only(top: gangInput + 5)),

                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: RaisedButton(
                                    onPressed: () => Navigator.pop(context),
                                    color: AppTheme.bgChatGrey,
                                    child: Text(
                                      'KEMBALI',
                                      style: TextStyle(
                                          color: AppTheme.nearlyWhite),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: RaisedButton(
                                    onPressed: () {
                                      if (setujuAnggrement) {
                                        _saveApi();
                                      }
                                    },
                                    color: setujuAnggrement
                                        ? AppTheme.bgChatBlue
                                        : Colors.grey,
                                    child: Text(
                                      'KIRIM PRIVAT',
                                      style: TextStyle(
                                          color: AppTheme.nearlyWhite),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget judulLabel(String judul) {
    return SizedBox(
      height: 18,
      child: Text(
        judul,
        style: TextStyle(
            fontSize: 15,
            color: AppTheme.geySolidCustom,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget inputHug(String hint, FaIcon icon, TextEditingController controller) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return Container(
      height: 40,
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
              fontSize: 16.0,
            ),
            controller: controller,
            maxLength: 45,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              suffixStyle: TextStyle(color: Colors.black),
              // counterStyle: TextStyle(
              //   height: double.minPositive,
              // ),
              counterText: "",
            ),
          ),
          width: sizeu.width - 80,
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
}
