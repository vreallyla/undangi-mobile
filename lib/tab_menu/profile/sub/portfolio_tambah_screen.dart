import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undangi/Constant/app_var.dart';
// import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';

class PortfolioTambahScreen extends StatefulWidget {
  const PortfolioTambahScreen({
    Key key,
    this.dataEdit,
  }) : super(key: key);

  final Map<String, dynamic> dataEdit;

  @override
  _PortfolioTambahScreenState createState() => _PortfolioTambahScreenState();
}

class _PortfolioTambahScreenState extends State<PortfolioTambahScreen> {
  TextEditingController judulInput = new TextEditingController();
  TextEditingController tautanInput = new TextEditingController();
  TextEditingController tahunInput = new TextEditingController();
  TextEditingController deskripsiInput = new TextEditingController();

  File _image;
  final picker = ImagePicker();
  String imgBase64 = '';

  Map error = {};
  setErrorNotif(Map v) {
    setState(() {
      error = v;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.dataEdit);
    if (widget.dataEdit.containsKey('judul')) {
      setState(() {
        judulInput.text = widget.dataEdit['judul'];
        tautanInput.text = widget.dataEdit['tautan'];
        deskripsiInput.text = widget.dataEdit['deskripsi'];
        tahunInput.text = widget.dataEdit['tahun'];
      });
    }
  }

  _saveApi() async {
    onLoading(context);

    Map dataSend = {
      'judul': judulInput.text.toString(),
      'tautan': tautanInput.text.toString(),
      'deskripsi': deskripsiInput.text.toString(),
      'tahun': tahunInput.text.toString(),
    };
    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      ProfileModel.portfolioNew(
              _image,
              dataSend,
              (widget.dataEdit.containsKey('id')
                  ? widget.dataEdit['id']
                  : null))
          .then((v) {
        Navigator.pop(context);
        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setErrorNotif(v.data['message']);
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context, true);
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

  //ambil gambar camera
  Future getImageCamera(context) async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // File imageResized = await FlutterNativeImage.compressImage(_image.path,
      //     quality: 100, targetWidth: 120, targetHeight: 120);

      List<int> imageBytes = _image.readAsBytesSync();

      imgBase64 = base64Encode(imageBytes);
      setState(() {});

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

    List<int> imageBytes = _image.readAsBytesSync();

    imgBase64 = base64Encode(imageBytes);

    setState(() {
      if (pickedFile != null) {
        // _showPicker(context);
      } else {
        print('No image selected.');
      }
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

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: appActionHead(paddingPhone, 'Portfolio',
              widget.dataEdit.containsKey('judul') ? 'Simpan' : 'Tambah', () {
            Navigator.pop(context);
          }, () {
            //event act save
            _saveApi();
          }),
          body: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: ListView(
              children: [
                containerInput(
                    TextField(
                      onChanged: (v) {
                        // widget.eventtChange(v);
                      },
                      onSubmitted: (v) {
                        // widget.eventtSubmit(v);
                      },
                      maxLength: 80,
                      controller: judulInput,
                      // focusNode: focusCariKategori,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Judul Portfolio",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    45),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: noticeText('judul', error)),
                containerInput(
                    TextField(
                      onChanged: (v) {
                        // widget.eventtChange(v);
                      },
                      onSubmitted: (v) {
                        // widget.eventtSubmit(v);
                      },
                      maxLength: 80,
                      controller: tautanInput,
                      // focusNode: focusCariKategori,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Tautan Portfolio",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    45),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: noticeText('tautan', error)),
                containerInput(
                    TextField(
                      onChanged: (v) {
                        // widget.eventtChange(v);
                      },
                      onSubmitted: (v) {
                        // widget.eventtSubmit(v);
                      },
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      controller: tahunInput,
                      // focusNode: focusCariKategori,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Tahun",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    45),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: noticeText('tahun', error)),
                containerInput(
                    TextField(
                      onChanged: (v) {
                        // widget.eventtChange(v);
                      },
                      onSubmitted: (v) {
                        // widget.eventtSubmit(v);
                      },
                      maxLines: 3,
                      maxLength: 240,
                      controller: deskripsiInput,
                      // focusNode: focusCariKategori,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Deskripsi",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    90),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: noticeText('deskripsi', error)),
                containerInput(
                  InkWell(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: SizedBox(
                      width: sizeu.width - 40,
                      child: !widget.dataEdit.containsKey('foto') ||
                              _image != null
                          ? _image != null
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fitHeight,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: (AssetImage(
                                              'assets/more_icon/photo.png')),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Text('Unggah Gambar')
                                  ],
                                )
                          : CachedNetworkImage(
                              imageUrl: domainChange(widget.dataEdit['foto']),
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) => SizedBox(
                                  width: 80,
                                  child: new CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                    ),
                  ),
                  widget.dataEdit.containsKey('foto') || _image != null
                      ? 200
                      : 80,
                ),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: noticeText('image', error)),
              ],
            ),
          )),
    );
  }

  Widget containerInput(Widget chill, double heig) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: heig,
        child: chill);
  }
}
