import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/starReview.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tab_menu/profile/skill_n_bahasa_view.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TampilanPublikProfil extends StatefulWidget {
  @override
  _TampilanPublikProfilState createState() => _TampilanPublikProfilState();

  const TampilanPublikProfil({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikProfilState extends State<TampilanPublikProfil> {
  String urlPhoto;
  String summary;
  Map dataUser = {};
  Map jumlah = {};
  bool itsMe = true;
  bool loading = true;

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      jumlah = {
        'proyek': data['jumlah_proyek'],
        'layanan': data['jumlah_layanan'],
        'portfolio': data['jumlah_portfolio'],
        'ulasan': data['jumlah_ulasan'],
      };
      itsMe = data['its_me'] ?? false;
      dataUser = data.containsKey('user') ? data['user'] : {};
    });
    print(dataUser['skill']);
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.get(widget.id==0?'':widget.id.toString()).then((v) {
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

  checkVar(String array1) {
    return dataUser[array1] != null ? dataUser[array1] : ' -';
  }

  setRekening() {
    String rekening = dataUser['rekening'];
    int countRekening =
        dataUser['rekening'] != null ? dataUser['rekening'].length : 0;

    if (countRekening > 4) {
      return rekening.substring(0, 3) +
          rekening
              .substring(3, countRekening - 2)
              .replaceAll(RegExp(r"."), "*") +
          rekening.substring(countRekening - 2);
    }
    return rekening == null ? '' : rekening;
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: appBarColloring(),
      body: loading
          ? onLoading2()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      // BG
                      appDashboard(
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
                          )),
                      Container(
                        margin: EdgeInsets.only(top: sizeu.height - 30),
                        color: AppTheme.nearlyWhite,
                        width: double.infinity,
                        height: 40,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            btnOp(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: sizeu.height -
                      bottom -
                      paddingPhone.top -
                      paddingPhone.bottom -
                      150,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(width: .5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          // color: AppTheme.primaryWhite,
                        ),
                        child: Column(
                          children: [
                            contentProfile('Nama', checkVar('nama')),
                            contentProfile(
                                'Tanggal Lahir', checkVar('tgl_lahir')),
                            contentProfile(
                                'Jenis Kelamin', checkVar('jenis_kelamin')),
                            contentProfile(
                                'Kewarganegaraan', checkVar('kewarganegaraan')),
                            contentProfile('Telp', checkVar('telp')),
                            contentProfile('Email', checkVar('email')),
                            contentProfile('Alamat', checkVar('alamat')),
                            contentProfile('Kota', checkVar('kota')),
                            contentProfile(
                              'Nomor Rekening',
                              setRekening() + ' (' + (checkVar('bank') + ')'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.tools,
                                    color: AppTheme.geyCustom,
                                    size: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      '${pointGroup(jumlah['layanan'])} LAYANAN',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.geyCustom),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    color: AppTheme.geyCustom,
                                    size: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: starJadi(
                                        dataUser['bintang'] != null
                                            ? double.parse(dataUser['bintang'].toString())
                                            : 0.0,
                                        jumlah['ulasan'] != null
                                            ? pointGroup(jumlah['ulasan'])
                                            : '0',
                                        20,
                                        20),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendar,
                                    color: AppTheme.geyCustom,
                                    size: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Bergabung sejak : ${DateFormat('d MMMM yyyy').add_jm().format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(dataUser["created_at"]))}',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.geyCustom),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.clock,
                                  color: AppTheme.geyCustom,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Update terakhir : ${DateFormat('d MMMM yyyy').add_jm().format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(dataUser["updated_at"]))}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.geyCustom),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      //summary
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        decoration: BoxDecoration(
                            color: AppTheme.bgGreenBlueSoft,
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.fileAlt,
                                  color: AppTheme.geySolidCustom,
                                  size: 18,
                                ),
                                Text(
                                  ' Summary',
                                  style: TextStyle(
                                      color: AppTheme.geySolidCustom,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                summary??'masih belum diisi...',
                                maxLines: 4,
                                style: TextStyle(
                                    color: AppTheme.geySolidCustom,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // skill
                      //skill bahasa
                      Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                            // border: Border.all(width: .5, color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.primaryBluePekat,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: (AssetImage(
                                            'assets/more_icon/construction.png')),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  SizedBox(
                                    width: sizeu.width - 70 - 10 - 10,
                                    child: Text(
                                      'Skill dan Bahasa',
                                      style: TextStyle(
                                        color: AppTheme.primaryWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //content summary
                              SkillNBahasaView(
                                dataSkill: dataUser['skill'] != null
                                    ? dataUser['skill']
                                    : [],
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget contentProfile(String index, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //nama
        Expanded(
            flex: 1,
            child: Text(index,
                style: TextStyle(fontSize: 12, color: Colors.black))),
        Expanded(
            flex: 1,
            child: Text(value,
                style: TextStyle(fontSize: 12, color: Colors.black))),
      ]),
    );
  }

  Widget cardPublic(
    bottom,
    int indexWarna,
    int jmlh,
    String judul,
    FaIcon icon,
  ) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    return Container(
      height: (sizeu.height -
              paddingPhone.top -
              paddingPhone.bottom -
              bottom -
              298 +
              5 -
              20 -
              55) /
          4,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppTheme.renoReno[indexWarna],
          borderRadius: BorderRadius.circular(15)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          width: 30,
          child: icon,
        ),
        Container(
          width: sizeu.width - 60 - 70,
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                judul,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  pointGroup(jmlh) + ' Layanan',
                  style: TextStyle(
                    color: AppTheme.textPink,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home/circle_quatral.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: FaIcon(
            FontAwesomeIcons.play,
            color: AppTheme.textPink,
            size: 12,
          ),
        )
      ]),
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

  Widget btnOp() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: (sizeu.width - 16) / 2,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 135,
              child: RaisedButton(
                color: itsMe ? Colors.grey[400] : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!itsMe) {
                    //jika undang
                  } else {
                    openAlertBox(context, 'Pemberitahuan!',
                        'Tidak bisa mengundang akun anda sendiri!', 'OK', () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'UNDANG SAYA  ',
                      style:
                          TextStyle(color: AppTheme.nearlyWhite, fontSize: 12),
                    ),
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: AppTheme.nearlyWhite,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: (sizeu.width - 16) / 2,
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 135,
              child: RaisedButton(
                color: itsMe ? Colors.grey[400] : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!itsMe) {
                    //jika undang
                  } else {
                    openAlertBox(context, 'Pemberitahuan!',
                        'Tidak bisa memilih akun anda sendiri!', 'OK', () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '   PILIH SAYA     ',
                      style:
                          TextStyle(color: AppTheme.nearlyWhite, fontSize: 12),
                    ),
                    FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: AppTheme.nearlyWhite,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
