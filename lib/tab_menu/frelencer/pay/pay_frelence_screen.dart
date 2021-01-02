import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/tab_menu/frelencer/pay/helper/withdraw_modal.dart';
import 'package:undangi/tab_menu/frelencer/pay/helper/set_pin_modal.dart';
import 'package:undangi/tab_menu/frelencer/pay/helper/topup_modal.dart';
import 'package:undangi/tab_menu/frelencer/pay/helper/topup_midtrans_modal.dart';

class PayFrelenceScreen extends StatefulWidget {
  @override
  _PayFrelenceScreenState createState() => _PayFrelenceScreenState();
}

class _PayFrelenceScreenState extends State<PayFrelenceScreen> {
  //DATA
  List histori = [];
  Map dataUser = {};
  bool pinIsExist = true;
  String saldo = '0';

  //LOADING MANUFER
  bool loading = true;

  //REAPET LOAD API
  bool stopLoad = false;
  bool loadNow = false;

  setStopRepeat(bool kond) {
    setState(() {
      stopLoad = kond;
    });
    if (loadNow) {
      _loadDataApi();
    }
  }

  setloadNow(bool kond) {
    setState(() {
      loadNow = kond;
    });
  }

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  setData(Map res) {
    setState(() {
      histori = res['history'] ?? [];
      dataUser = res['user'] ?? {};
      pinIsExist = res['set_pin'] == 1;
      saldo = res['saldo'] != null ? res['saldo'].toString() : '0';
    });

    if (!pinIsExist) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return SetPinModal(
              reload: (String msg) {
                openAlertSuccessBoxGoon(
                  context,
                  'Berhasil',
                  msg,
                  'OK',
                );

                setLoading(true);
                setState(() {
                  pinIsExist = true;
                });
                _loadDataApi();
              },
              pinIsExist: false,
            );
          });
    }
  }

  // refresh user
  void _loadDataApi() async {
    if (!stopLoad) {
      setStopRepeat(true);

      GeneralModel.checCk(
          //connect
          () async {
        DompetModel.get().then((v) {
          setStopRepeat(false);

          setLoading(false);

          if (v.error) {
            errorRespon(context, v.data);
          } else {
            setData(v.data);
            //disconect
          }
        });
      }, () {
        setStopRepeat(false);
        setLoading(false);

        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          Navigator.pop(context, false);
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadDataApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    double _height = sizeu.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: appBarColloring(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBackWithPhoto(context, dataUser['foto'],
              () => Navigator.pushNamed(context, '/publik')),
          //tag name
          loading
              ? onLoading2()
              : Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: _width,
                  child: Text(
                    'UNDAGI PAY',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.geyCustom,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

          //card saldo
          Container(
            width: _width,
            padding: EdgeInsets.all(10),
            color: AppTheme.bgChatBlue,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/more_icon/cc_white.png',
                          width: 20,
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          ' UNDAGI PAY',
                          style: TextStyle(
                              color: AppTheme.nearlyWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        )
                      ],
                    ),
                    Container(
                      width: (_width - 20) / 2,
                      child: Text(
                        'SALDO ANDA :',
                        style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      width: (_width - 20) / 2,
                      child: Text(
                        'Rp${decimalPointTwo(saldo.toString())}',
                        style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: (_width - 20) / 2,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 130,
                        height: 20,
                        child: RaisedButton(
                          color: AppTheme.nearlyWhite,
                          onPressed: () async {
                            onLoading(context);
                            await GeneralModel.token().then((v) {
                              Navigator.pop(context);

                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TopupModal(
                                      pinIsExist: pinIsExist,
                                      reload: (String nominal) {
                                        Navigator.pop(context);
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return TopupMidtransModal(
                                                other: {
                                                  'jumlah': double.parse(nominal.toString()).round().toString(),
                                                  'token': v.res,
                                                },
                                                loadAgain: () {
                                                  _loadDataApi();
                                                },
                                              );
                                            });
                                      },
                                    );
                                  });
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                child: Icon(
                                  Icons.control_point_duplicate,
                                  color: AppTheme.bgChatBlue,
                                  size: 18,
                                ),
                              ),
                              Text(
                                '     TOPUP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.bgChatBlue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (_width - 20) / 2,
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 130,
                        height: 20,
                        child: RaisedButton(
                          color: AppTheme.nearlyWhite,
                          onPressed: () {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return WithdrawModal(
                                    saldo: double.parse(saldo),
                                    submit: (String msg) {
                                      _loadDataApi();
                                      openAlertSuccessBoxGoon(
                                          context, 'Berhasil', msg, 'OK');
                                    },
                                  );
                                });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                child: Icon(
                                  Icons.credit_card,
                                  color: AppTheme.bgChatBlue,
                                  size: 18,
                                ),
                              ),
                              Text(
                                ' WITHDRAW',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.bgChatBlue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (_width - 20) / 2,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 130,
                        height: 20,
                        child: RaisedButton(
                          color: AppTheme.nearlyWhite,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SetPinModal(
                                    reload: (String msg) {
                                      openAlertSuccessBox(
                                          context,
                                          'Berhasil',
                                          msg,
                                          'OK',
                                          () => Navigator.pop(context));

                                      //TODO::CHECK PIN
                                      setLoading(true);
                                      _loadDataApi();
                                    },
                                    pinIsExist: true,
                                  );
                                });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18,
                                child: Icon(
                                  Icons.edit,
                                  color: AppTheme.bgChatBlue,
                                  size: 18,
                                ),
                              ),
                              Text(
                                '  GANTI PIN',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.bgChatBlue,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          //list view data

          Container(
            height:
                _height - 340 - bottom - paddingPhone.top - paddingPhone.bottom,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              border: Border.all(width: .5, color: AppTheme.geyCustom),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
                itemCount: histori.length,
                // itemExtent: 100.0,
                itemBuilder: (c, i) {
                  return Container(
                    width: double.infinity,
                    color: AppTheme.bgBlue2Soft,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          color: AppTheme.bgChatBlue,
                          child: Image.asset('assets/more_icon/cc_white.png',
                              width: 30),
                        ),
                        Container(
                          width: _width - 117,
                          padding: EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${histori[i]['status'] ?? unknown} Berhasil!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              RichText(
                                text: TextSpan(
                                  text:
                                      '${histori[i]['status'] ?? unknown} untuk transaksi ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppTheme.nearlyBlack,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${histori[i]['id'] ?? unknown} ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'menggunakan Undagi Pay telah berhasil dan dana sebesar ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Rp${decimalPointTwo(histori[i]['jumlah'] != null ? histori[i]['jumlah'].toString() : '0')} ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'telah ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${histori[i]['isTopup'] == 1 ? 'DITAMBAHKAN' : 'DITARIK'} ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'dari Undagi Pay-mu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.nearlyBlack,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Text(
                                histori[i]['created_at'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
