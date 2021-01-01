import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/frelencer/proyek_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';

class ProgressModal extends StatefulWidget {
  @override
  _ProgressModalState createState() => _ProgressModalState();
  const ProgressModal({
    Key key,
    this.reload,
    this.proyekId,
  }) : super(key: key);

  final Function(String nominal) reload;
  final String proyekId;
}

class _ProgressModalState extends State<ProgressModal> {
  TextEditingController gambarController = new TextEditingController();
  TextEditingController deskripsiController = new TextEditingController();

  File gambar;
  final picker = ImagePicker();
  String imgBase64;

  //ERROR DATA INPUT
  Map error = {};

  void setErrorNotif(Map res) {
    setState(() {
      error = res;
    });
  }

  _saveApi() async {
    onLoading(context);
    Map dataSend = {
      'deskripsi': deskripsiController.text.toString(),
      
    };

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      ProyekFrelencerModel.saveProgress(widget.proyekId,dataSend,gambar)
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
          //TODO::RELOAD PROGRESS
          Navigator.pop(context);
          widget.reload(v.data['message']);
        
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
    setState(() {
          gambar=File(pickedFile.path);
        });

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

      setState(() {
          gambar=File(pickedFile.path);
        });

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

  setThumb(File img){
    setState(() {
          gambarController.text=img.path.split('/').last;
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final paddingPhone = MediaQuery.of(context).padding;

    Color myColor = AppTheme.bgChatBlue;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: AlertDialog(
        backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          width: 320.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // logo
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
                            color: Colors.grey.withOpacity(.1), width: .5))),
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

              SizedBox(
                height: 285,
                child: ListView(
                  children: [
                    //GAMBAR
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                      child:
                          Text('Bukti Gambar', style: TextStyle(fontSize: 14)),
                    ),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                        child: IgnorePointer(
                          child: TextField(
                            controller: gambarController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14, height: 1),
                            decoration: new InputDecoration(
                                counter: Offstage(),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle:
                                    new TextStyle(color: Colors.grey[800]),
                                hintText: "Pilih Gambar",
                                fillColor: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: noticeText('bukti_gambar', error),
                    ),

                    //NEW PIN
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: Text('Deskripsi', style: TextStyle(fontSize: 14)),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                        child: TextField(
                          maxLines: 3,
                          controller: deskripsiController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 14, height: 1),
                          decoration: new InputDecoration(
                              counter: Offstage(),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              hintText: "Masukkan Deskripsi",
                              fillColor: Colors.white70),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 15),
                      child: noticeText('deskripsi', error),
                    ),

                    InkWell(
                      onTap: () {
                        _saveApi();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: true ? myColor : Colors.grey,
                        ),
                        child: Text(
                          "KIRIM",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
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
}
