import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/html_read.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tab_menu/owner/proyek/sub/payment_proyek_screen.dart';

class ModalAcceptBid extends StatefulWidget {
  @override
  _ModalAcceptBidState createState() => _ModalAcceptBidState();

  const ModalAcceptBid(
      {Key key,
      this.proyekId,
      this.userId,
      this.loadAgain,
      this.bottom,
      this.other})
      : super(key: key);

  final String proyekId;
  final String userId;
  final Function loadAgain;
  final double bottom;
  final Map other;
}

class _ModalAcceptBidState extends State<ModalAcceptBid> {
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
        'proyek_id': widget.proyekId,
        'user_id': widget.userId,
        'aggrement': setujuAnggrement ? '1' : '0',
      };
      PublikModel.terimaBid(res).then((v) async {
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
            Color myColor = AppTheme.primarymenu;

            return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color(0xfff7f7f7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0))),
                    contentPadding: EdgeInsets.only(top: 10.0),
                    content: Container(
                      width: 400.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.only(right: 20),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.times,
                                    color: AppTheme.geyCustom,
                                    size: 16,
                                  ))),
                          Container(
                            width: 80,
                            height: 83,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (AssetImage(
                                    'assets/general/check_cicle.png')),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "Berhasil",
                            style: TextStyle(
                                fontSize: 20, color: AppTheme.geySolidCustom),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            v.data['message'],
                            style: TextStyle(
                                fontSize: 14, color: AppTheme.geyCustom),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: RaisedButton(
                              color: myColor,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PaymentProyekScreen(
                                              proyekId:
                                                  int.parse(widget.proyekId),
                                            )));
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: AppTheme.nearlyWhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
                height: 150 - bottom + (bottom > 0 ? 100 : 0),
                child: ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
                          InkWell(
                              onTap: () {
                                setState(() {
                                  setujuAnggrement = !setujuAnggrement;
                                });
                              },
                              child: Text(' Saya Setuju terkait ')),
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
                                                widget.other['nama']
                                                    .toString() +
                                                '&token=' +
                                                token,
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
                                  openAlertBoxTwo(
                                      context,
                                      'Peringatan!',
                                      'Apakah Anda yakin akan membuat ${widget.other['bidder']} menjadi pekerja untuk tugas/proyek "tidak ada"? Anda tidak dapat mengembalikannya!',
                                      'TIDAK',
                                      'YA',
                                      () => Navigator.pop(context), () {
                                    Navigator.pop(context);

                                    _loadDataApi();
                                  });
                                }
                              },
                              color: setujuAnggrement
                                  ? AppTheme.bgChatBlue
                                  : Colors.grey,
                              child: Text(
                                'TERIMA BID',
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
