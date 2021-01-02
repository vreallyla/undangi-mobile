import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/frelencer/layanan_frelencer_model.dart';
import 'package:undangi/Model/frelencer/proyek_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';

class FileHasilLayananModal extends StatefulWidget {
  @override
  _FileHasilLayananModalState createState() => _FileHasilLayananModalState();
  const FileHasilLayananModal({
    Key key,
    this.reload,
    this.proyekId,
  }) : super(key: key);

  final Function(String nominal) reload;
  final String proyekId;
}

class _FileHasilLayananModalState extends State<FileHasilLayananModal> {
  TextEditingController gambarController = new TextEditingController();
  TextEditingController tautanController = new TextEditingController();

  List<File> fileHasil = <File>[];

  //ERROR DATA INPUT
  Map error = {};

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      tautanController.text = 'https://';
    });
    super.initState();
  }

  void setErrorNotif(Map res) {
    setState(() {
      error = res;
    });
  }

  _saveApi() async {
    onLoading(context);
    Map dataSend = {
      'tautan': tautanController.text.toString(),
    };

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      LayananFrelencerModel.fileHasil(dataSend, fileHasil, widget.proyekId)
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
          print('asd');
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

  void tambahlampiranSet() async {
    List<File> lampiran = [];
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
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

      setState(() {
        fileHasil = selectionLamp;
      });
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
    } else {
      setThumb(fileHasil.length.toString());
    }
  }

  setThumb(String numb) {
    setState(() {
      gambarController.text = numb + ' File Hasil';
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
                height: 260,
                child: ListView(
                  children: [
                    //GAMBAR
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                      child: Text('File Hasil', style: TextStyle(fontSize: 14)),
                    ),
                    InkWell(
                      onTap: () {
                        tambahlampiranSet();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                        child: IgnorePointer(
                          child: TextField(
                            controller: gambarController,
                            // keyboardType: TextInputType.number,
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
                                hintText: "Tekan Untuk Pilih File",
                                fillColor: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: noticeText('file_hasil', error),
                    ),

                    //NEW PIN
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: Text('Tautan', style: TextStyle(fontSize: 14)),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                        child: TextField(
                          maxLines: 1,
                          controller: tautanController,
                          // keyboardType: TextInputType.number,
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
                              hintText: "Masukkan Tautan",
                              fillColor: Colors.white70),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 15),
                      child: noticeText('tautan', error),
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
