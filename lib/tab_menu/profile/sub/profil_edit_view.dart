import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/choose_select.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/profile_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'dart:convert';

import 'package:async/async.dart';

class ProfilEditView extends StatefulWidget {
  @override
  _ProfilEditViewState createState() => _ProfilEditViewState();
}

class _ProfilEditViewState extends State<ProfilEditView> {
  TextEditingController namaInput = new TextEditingController();
  TextEditingController mottoInput = new TextEditingController();
  TextEditingController tglLahirInput = new TextEditingController();

  TextEditingController noTelpInput = new TextEditingController();
  TextEditingController emailInput = new TextEditingController();
  TextEditingController alamatInput = new TextEditingController();

  TextEditingController noRekInput = new TextEditingController();
  TextEditingController namaPemilikInput = new TextEditingController();

  Map<String, dynamic> dataProfil = {};
  bool loading = false;
  bool loading2 = false;

  File _image;
  final picker = ImagePicker();
  String imgBase64 = '';

  String jkInput;
  Map kewarganegaraanInput = {
    "id": null,
    "nama": null,
  };
  Map kotaInput = {
    "id": null,
    "nama": null,
  };
  Map bankInput = {
    "id": null,
    "nama": null,
  };
  String foto;
  Map error = {};

  DateTime selectedDate = DateTime.now();
  final myformat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _getApi();
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

      _showPicker(context);
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
        _showPicker(context);
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
                  _image != null
                      ? Wrap(
                          children: [
                            Center(
                                child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )),
                            new ListTile(
                                leading: new Icon(Icons.file_upload),
                                title: new Text('Upload gambar'),
                                onTap: () {
                                  uploadAva();
                                  Navigator.of(context).pop();
                                }),
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
                        )
                      : Wrap(
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

  uploadAva() async {
    loadingSet2(true);
    loadingSet(true);
    GeneralModel.checCk(() {
      ProfileModel.uploadFoto(imgBase64).then((v) {
        loadingSet2(false);

        setState(() {
          _image = null;
        });
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          Navigator.pop(context, true);
        }
      });
    }, () {
      loadingSet2(false);

      setState(() {
        _image = null;
      });
      loadingSet(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context);
      });
    });
  }

  loadingSet(bool v) {
    setState(() {
      // dataProfil = {};
      loading = v;
    });
  }

  loadingSet2(bool v) {
    setState(() {
      loading2 = v;
    });
  }

  _getApi() async {
    loadingSet(true);
    await GeneralModel.checCk(
        //conect
        () async {
      await ProfileModel.editProfile().then((v) {
        loadingSet(false);
        var kene = v.data['kewarganegaraan'];
        bool boolKene = kene == null ? false : kene.containsKey('id');

        var kota = v.data['kota_provinsi'];
        bool boolKota = kota == null ? false : kota.containsKey('id');

        var bank = v.data['bank'];
        bool boolBank = bank == null ? false : bank.containsKey('id');

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            dataProfil = (v.data);
            namaInput.text = v.data['name'];
            mottoInput.text = v.data['status'];
            tglLahirInput.text = v.data['tgl_lahir'];
            noTelpInput.text = v.data['hp'];
            emailInput.text = v.data['email'];
            alamatInput.text = v.data['alamat'];
            noRekInput.text = v.data['rekening'];
            namaPemilikInput.text = v.data['an'];
            jkInput = v.data['jenis_kelamin'];
            if (boolKene) {
              kewarganegaraanInput = {
                "id": kene['id'],
                "nama": kene['nama'],
              };
            }

            if (boolKota) {
              kotaInput = {
                "id": kota['id'],
                "nama": kota['nama'],
              };
            }
            if (boolBank) {
              bankInput = {
                "id": bank['id'],
                "nama": bank['nama'],
              };
            }
          });
        }
      });
    },
        //disconect
        () {
      loadingSet(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context);
      });
    });
  }

  _saveApi() async {
    onLoading(context);

    loadingSet2(true);

    Map dataSend = {
      "name": namaInput.text,
      "email": emailInput.text,
      "jenis_kelamin": jkInput,
      "tgl_lahir": tglLahirInput.text,
      "status": mottoInput.text,
      "kewarganegaraan": kewarganegaraanInput['nama'].toString(),
      "hp": noTelpInput.text,
      "alamat": alamatInput.text,
      "kota_id": kotaInput['id'].toString(),
      "bank": bankInput['id'].toString(),
      "rekening": noRekInput.text,
      "an": namaPemilikInput.text,
    };
    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      ProfileModel.updateProfile(dataSend).then((v) {
        Navigator.pop(context);

        loadingSet2(false);

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
          Navigator.pop(context, true);
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);
      loadingSet2(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  setErrorNotif(Map v) {
    setState(() {
      error = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    // double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: appActionHead(paddingPhone, 'Profil', 'Simpan', () {
          Navigator.pop(context, false);
        }, () {
          //event act save
          if (!loading) {
            _saveApi();
          }
        }),
        body: loading
            ? onLoading2()
            : Container(
                margin: EdgeInsets.only(top: 25),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //gambar photo
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        left: _width / 2 - 50,
                        bottom: 10,
                        right: _width / 2 - 50,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                          image: dataProfil.containsKey('foto')
                              ? NetworkImage(domainChange(dataProfil['foto']))
                              : AssetImage('assets/general/user.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    //tulisan ganti gambar
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: SizedBox(
                        width: _width,
                        child: Text(
                          'Ganti Foto Profil',
                          style: TextStyle(
                            color: AppTheme.textBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    //pembatas
                    Padding(padding: EdgeInsets.only(top: 15)),

                    //nama
                    inputTexfield('Nama', namaInput, false),
                    noticeText('name', error),

                    //MOTTO
                    inputTexfield('Motto', mottoInput, false),
                    noticeText('status', error),

                    //TGL LAHIR
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              'Tanggal Lahir',
                              style: TextStyle(
                                // color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: .5, color: AppTheme.geySolidCustom),
                                bottom: BorderSide(
                                    width: .5, color: AppTheme.geySolidCustom),
                              ),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                selectDate(
                                    context); // Call Function that has showDatePicker()
                              },
                              child: IgnorePointer(
                                child: SizedBox(
                                  width: sizeu.width - 30,
                                  height: 40,
                                  child: TextFormField(
                                    decoration: textfieldDesign(''),
                                    controller: tglLahirInput,
                                    // decoration:
                                    //     defaultInput('Pilih Tanggal Lahir', false),
                                    onSaved: (String val) {},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    noticeText('tgl_lahir', error),

                    //JK
                    inputSelect('Jenis Kelamin', 'Pilih Jenis Kelamin', jkInput,
                        (String v) {
                      setState(() {
                        jkInput = v;
                      });
                    }),
                    noticeText('jenis_kelamin', error),

                    //kewarganegaraan
                    selectRedirect('user/negara?id=', false, 'Kewarganegaraan',
                        'Pilih Negara', kewarganegaraanInput, (Map v) {
                      setState(() {
                        kewarganegaraanInput = v;
                      });
                    }),
                    noticeText('kewarganegaraan', error),

                    //email
                    inputTexfield('Email', emailInput, false),
                    noticeText('email', error),

                    //Telp
                    inputTexfield('No. Telp', noTelpInput, true),
                    noticeText('hp', error),

                    //alamat
                    inputTexfield('Alamat', alamatInput, false),
                    noticeText('alamat', error),

                    //kota
                    selectRedirect('user/kota?id=', true, 'Kota/Provinsi',
                        'Pilih Kota/Provinsi', kotaInput, (Map v) {
                      setState(() {
                        kotaInput = v;
                      });
                    }),
                    noticeText('kota', error),

                    // pembatas biru
                    Container(
                      height: 25,
                      color: AppTheme.primaryBlue,
                      margin: EdgeInsets.only(bottom: 10),
                    ),

                    //BANK
                    selectRedirect(
                        'user/bank?id=', false, 'Bank', 'Pilih Bank', bankInput,
                        (Map v) {
                      setState(() {
                        bankInput = v;
                      });
                    }),
                    noticeText('bank', error),

                    //NOREK
                    inputTexfield('No. Rekening', noRekInput, true),
                    noticeText('rekening', error),

                    //pemilik rek
                    inputTexfield('Nama Pemilik', namaPemilikInput, false),
                    noticeText('an', error),

                    //margin bawah
                    Padding(
                      padding: EdgeInsets.only(bottom: 25),
                    ),
                  ],
                )),
      ),
    );
  }

  Widget inputTexfield(
    String label,
    TextEditingController controller,
    bool numb,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
              color: Colors.white,
            ),
            child: TextField(
              keyboardType: numb ? TextInputType.number : TextInputType.text,
              decoration: textfieldDesign(''),
              controller: controller,
              maxLength: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget inputSelect(
    String label,
    String placeholder,
    String value,
    Function(String v) changeValue,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                onChanged: (String newValue) {
                  setState(() {
                    changeValue(newValue);
                  });
                },
                hint: Text(placeholder,
                    style: TextStyle(color: AppTheme.textBlue, fontSize: 16)),
                icon: Icon(Icons.keyboard_arrow_down),
                items: <String>['Laki-laki', 'Perempuan', 'lainnya']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            TextStyle(color: AppTheme.textBlue, fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectRedirect(
    String path,
    bool grup,
    String label,
    String placeholder,
    Map value,
    Function(Map v) changeValue,
  ) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseSelect(
                        op: value,
                        grup: grup,
                        judul: label,
                        url: path +
                            (value['id'] == null ? '' : value['id'].toString()),
                        setValue: (Map v) {
                          setState(() {
                            changeValue(v);
                          });
                        }),
                  ));
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                  bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      (value['nama'] == null ? placeholder : value['nama']),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 24,
                          color: Colors.black.withOpacity(.6),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.green,
                onPrimary: Colors.white,
                surface: Colors.green[100],
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tglLahirInput.text = myformat.format(selectedDate);
      });
  }
}
