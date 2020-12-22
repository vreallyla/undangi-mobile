import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/html_read.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';

class ModalBid extends StatefulWidget {
  @override
  _ModalBidState createState() => _ModalBidState();

  const ModalBid(
      {Key key,
      this.tawarHarga,
      this.tawarWaktu,
      this.tawarTask,
      this.proyekId,
      this.loadAgain,
      this.bottom,
      this.other})
      : super(key: key);

  final String tawarHarga;
  final String tawarWaktu;
  final String tawarTask;
  final String proyekId;
  final Function loadAgain;
  final double bottom;
  final Map other;
}

class _ModalBidState extends State<ModalBid> {
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

  TextEditingController tawarHarga = new TextEditingController();
  TextEditingController tawarWaktu = new TextEditingController();
  TextEditingController tawarTask = new TextEditingController();
  bool setujuAnggrement = false;

  Map error = {};

  setError(Map data) {
    setState(() {
      error = data;
    });
  }

  // refresh user
  void _loadDataApi() async {
    setError({});
    GeneralModel.checCk(
        //connect
        () async {
      // setLoading(true);
      onLoading(context);

      Map res = {
        'negowaktu': tawarWaktu.text,
        'negoharga': tawarHarga.text,
        'task': tawarTask.text,
        'proyek_id': widget.proyekId,
        'aggrement': setujuAnggrement ? '1' : '0',
      };
      PublikModel.bidProyek(res).then((v) async {
        Navigator.pop(context);
        // print(v.data);
        if (v.error) {
          if (v.data['notValid'] != null ? v.data['notValid'] : false) {
            // print(v.data);
            setError(v.data['message']);
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context);

          await widget.loadAgain();

          Future.delayed(Duration(microseconds: 500), () {
            openAlertSuccessBoxGoon(
                context, 'Berhasil!', 'Proyek berhasil dibid', 'OK');
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

  @override
  void initState() {
    setState(() {
      tawarHarga.text = widget.tawarHarga;
      tawarWaktu.text = widget.tawarWaktu;
      tawarTask.text = widget.tawarTask;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Dialog(
        backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
        // contentPadding: EdgeInsets.only(top: 10.0),
        child: Container(
          padding: EdgeInsets.only(top: 10.0),
          width: 350.0,
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
              Container(
                height: 360 - bottom + (bottom > 0 ? 100 : 0),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                      child: Text('Tawar Harga'),
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppTheme.geySolidCustom),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        onChanged: (v) {
                          print(bottom);
                        },
                        controller: tawarHarga,
                        keyboardType: TextInputType.number,
                        decoration: textfieldDesign('Masukkan Harga'),
                        maxLength: 40,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: noticeText('negoharga', error)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Text('Waktu Pengerjaan'),
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppTheme.geySolidCustom),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: tawarWaktu,
                        keyboardType: TextInputType.number,
                        decoration:
                            textfieldDesign('Masukkan Waktu (Dihitung Hari)'),
                        maxLength: 40,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: noticeText('negowaktu', error)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Text('Ajukan Lingkup Task Pengerjaan'),
                    ),
                    Container(
                      height: 80,
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        // bottom: ,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppTheme.geySolidCustom),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: tawarTask,
                        maxLines: 4,
                        maxLength: 250,
                        decoration: textfieldDesign('Masukkan Usulan Task'),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: noticeText('task', error)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            child: Checkbox(
                              value: setujuAnggrement,
                              onChanged: (bool value) {
                                setState(() {
                                  setujuAnggrement = value;
                                });
                              },
                            ),
                          ),
                          Text(' Saya Setuju '),
                          InkWell(
                            onTap: () async {
                              String token = '';
                              await GeneralModel.token().then((value) {
                                token = value.res;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HtmlRead(
                                            url: globalBaseUrl +
                                                'aggrement_proyek?name=' +
                                                widget.other['nama']+'&token='+token,
                                          )));
                            },
                            child: Text(
                              'Syarat dan Ketentuan',
                              style: TextStyle(
                                color: AppTheme.bgChatBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            child: RaisedButton(
                              onPressed: () => Navigator.pop(context),
                              color: AppTheme.bgChatGrey,
                              child: Text(
                                'KEMBALI',
                                style: TextStyle(color: AppTheme.nearlyWhite),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: RaisedButton(
                              onPressed: () {
                                if (setujuAnggrement) {
                                  _loadDataApi();
                                }
                              },
                              color: setujuAnggrement
                                  ? AppTheme.bgChatBlue
                                  : Colors.grey,
                              child: Text(
                                'KIRIM',
                                style: TextStyle(color: AppTheme.nearlyWhite),
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
    );
  }
}
