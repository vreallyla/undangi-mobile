import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/payment_owner_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:undangi/tab_menu/owner/proyek/sub/helper/midtrans_modal.dart';

class PaymentProyekScreen extends StatefulWidget {
  @override
  _PaymentProyekScreenState createState() => _PaymentProyekScreenState();

  const PaymentProyekScreen({
    Key key,
    this.proyekId = 0,
    this.pengerjaanId = 0,
  }) : super(key: key);

  final int proyekId;
  final int pengerjaanId;
}

class _PaymentProyekScreenState extends State<PaymentProyekScreen> {
  String _pilihPembayaran = 'lunas';

  TextEditingController hargaTotal = new TextEditingController();
  TextEditingController hargaTagihan = new TextEditingController();
  MoneyMaskedTextController hargaAmbil = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  FocusNode ambilFocus = new FocusNode();
  FocusNode otherFocus = new FocusNode();

  bool loading = true;

  String fotoUrl;
  double saldo = 0;
  double tagihan = 0;
  bool isDP = false;
  bool bayarChange = false;
  bool stopLoad = false;

  Timer loadMore;

  String metode;

  String pengerjaanId;

  _changePemb(String val) {
    setState(() {
      _pilihPembayaran = val;
    });
    if (!bayarChange) {
      setState(() {
        hargaAmbil.updateValue(val == 'dp' ? (tagihan * 30 / 100) : tagihan);
      });
    }
  }

  // refresh user
  viaDompet() async {
    GeneralModel.checCk(
        //connect
        () async {
      // setLoading(true);
      onLoading(context);

      Map res = {
        'proyek_id': widget.proyekId.toString(),
        'bayar': hargaAmbil.numberValue.toString(),
      };
      PaymentOwnerModel.viaDompet(res).then((v) async {
        Navigator.pop(context);
        // print(v.data);
        if (v.error) {
          setState(() {
            stopLoad = true;
          });
          errorRespon(context, v.data);
        } else {
          Navigator.pop(context);

          _loadDataApi();

          Future.delayed(Duration(microseconds: 500), () {
            openAlertSuccessBoxGoon(
                context, 'Berhasil', v.data['message'], 'OK');
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

  _setData(Map res) {
    print(res);
    setState(() {
      hargaTotal.text = decimalPointTwo(
          res['gross_bill'] != null ? res['gross_bill'].toString() : '0');
      hargaTagihan.text =
          decimalPointTwo(res['bill'] != null ? res['bill'].toString() : '0');
      hargaAmbil.text = hargaAmbil.numberValue > res['bill'] ||
              hargaAmbil.numberValue == 0
          ? decimalPointTwo(res['bill'] != null ? res['bill'].toString() : '0')
          : hargaAmbil.text;
      tagihan =
          double.parse(res['bill'] != null ? res['bill'].toString() : '0');
      saldo =
          double.parse(res['saldo'] != null ? res['saldo'].toString() : '0');
      fotoUrl = res['user'] != null ? res['user']['foto'] : null;
      isDP = res['is_dp'];
      pengerjaanId=res['pengerjaan_id'].toString();
    });
  }

  // refresh user
  void _loadDataApi() async {
    if (!stopLoad) {
      GeneralModel.checCk(
          //connect
          () async {
        if (fotoUrl == null) {
          setLoading(true);
        }
        PaymentOwnerModel.get(widget.proyekId.toString()).then((v) {
          setLoading(false);
          if (v.error) {
            setState(() {
              stopLoad = true;
            });
            errorRespon(context, v.data);
          } else {
            _setData(v.data);
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
  }

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ambilFocus.dispose();
    loadMore?.cancel();

    super.dispose();
  }

  @override
  void initState() {
    _loadDataApi();
    // TODO: implement initState
    super.initState();
    ambilFocus.addListener(_onFocusChange);
    loadMore =
        Timer.periodic(Duration(seconds: 5), (Timer t) => _loadDataApi());
  }

  void _onFocusChange() {
    // debugPrint("Focus: "+ambilFocus.hasFocus.toString());
    setState(() {
      stopLoad = ambilFocus.hasFocus;
    });
    setState(() {
      if (!ambilFocus.hasFocus && hargaAmbil.numberValue > tagihan) {
        print(hargaAmbil.numberValue);
        hargaAmbil.updateValue(tagihan);
      } else if (!ambilFocus.hasFocus &&
          hargaAmbil.numberValue < (tagihan * 30 / 100)) {
        hargaAmbil.updateValue(tagihan * 30 / 100);
      }
      bayarChange = true;
      if (hargaAmbil.numberValue == tagihan) {
        _pilihPembayaran = 'lunas';
      } else {
        _pilihPembayaran = 'dp';
      }
      bayarChange = false;

      if (saldo < hargaAmbil.numberValue) {
        metode = metode == 'dompet' ? null : metode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    double marginHarga = 15;
    double paddingHarga = 10;
    double sisiBorderHarga = 30;
    double widthInputHarga =
        _width - marginHarga * 2 - paddingHarga * 2 - sisiBorderHarga * 2;

    return Scaffold(
      appBar: appBarColloring(),
      body: loading
          ? onLoading2()
          : new GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appDashboard(
                      context,
                      fotoUrl,
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
                  //judul
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      'Pembayaran',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //SELECT BUTTON PEMBAYARAN
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: _width,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: .5, color: AppTheme.geySolidCustom),
                        bottom: BorderSide(
                            width: .5, color: AppTheme.geySolidCustom),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pembayaran: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Radio(
                            activeColor: AppTheme.nearlyBlack,
                            value: 'dp',
                            groupValue: _pilihPembayaran,
                            onChanged: (v) => _changePemb(v),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!isDP) {
                              _changePemb('dp');
                            } else {
                              openAlertBox(
                                  context,
                                  'Pemberitahuan!',
                                  'Untuk Pembayaran selanjutnya dihitung lunas...',
                                  'OK',
                                  () => Navigator.pop(context));
                            }
                          },
                          child: Text(
                            ' DP (Minimal 30%)  ',
                            style: TextStyle(
                                fontSize: 14, color: AppTheme.geyCustom),
                          ),
                        ),
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Radio(
                            activeColor: AppTheme.nearlyBlack,
                            value: 'lunas',
                            groupValue: _pilihPembayaran,
                            onChanged: (v) => _changePemb(v),
                          ),
                        ),
                        InkWell(
                          onTap: () => _changePemb('lunas'),
                          child: Text(
                            ' LUNAS',
                            style: TextStyle(
                                fontSize: 14, color: AppTheme.geyCustom),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //INPUT HARGA
                  Container(
                      margin:
                          EdgeInsets.fromLTRB(marginHarga, 15, marginHarga, 0),
                      padding: EdgeInsets.all(paddingHarga),
                      width: _width - (marginHarga * 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.bgBlueSoft,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IgnorePointer(
                            child: hargaInput('Harga Proyek', sisiBorderHarga,
                                widthInputHarga, hargaTotal, otherFocus),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          IgnorePointer(
                            child: hargaInput('Tagihan', sisiBorderHarga,
                                widthInputHarga, hargaTagihan, otherFocus),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          hargaInput('Bayar', sisiBorderHarga, widthInputHarga,
                              hargaAmbil, ambilFocus),
                        ],
                      )),

                  //INFO & BUTTON
                  Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(marginHarga, 0, marginHarga, 0),
                        padding: EdgeInsets.fromLTRB(
                            paddingHarga, 5, paddingHarga, 5),
                        height: _height -
                            paddingPhone.top -
                            paddingPhone.bottom -
                            20 -
                            bottom -
                            424,
                        width: _width - (marginHarga * 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: .5,
                            color: AppTheme.geySolidCustom,
                          ),
                          color: AppTheme.nearlyWhite,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.bgBlue2Soft,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 20, 15, 10),
                          child: ListView(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: saldo < hargaAmbil.numberValue
                                            ? Colors.grey[300]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: metode == 'dompet' ||
                                                    saldo <
                                                        hargaAmbil.numberValue
                                                ? 2
                                                : 0,
                                            color:
                                                saldo < hargaAmbil.numberValue
                                                    ? Colors.grey
                                                    : AppTheme.bgChatBlue)),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (saldo <
                                                hargaAmbil.numberValue) {
                                              openAlertBox(
                                                  context,
                                                  'Pemberitahuan!',
                                                  'Saldo tidak cukup silakan topup untuk melanjutkan transaksi...',
                                                  'OK',
                                                  () => Navigator.pop(context));
                                            } else {
                                              setState(() {
                                                metode = 'dompet';
                                              });
                                            }
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: widthInputHarga / 4,
                                                height: widthInputHarga / 4,
                                                padding: EdgeInsets.all(15),
                                                child: Image.asset(
                                                    'assets/more_icon/cc_white.png'),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.primarymenu,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 7),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'UNDAGI PAY',
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppTheme.bgChatBlue,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Saldo : ' +
                                                              decimalPointTwo(saldo
                                                                  .toString()),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppTheme
                                                                .nearlyBlack,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                      top: 5,
                                                    )),
                                                    SizedBox(
                                                      width: widthInputHarga -
                                                          (widthInputHarga /
                                                              4) +
                                                          sisiBorderHarga * 2 -
                                                          33 -
                                                          20 -
                                                          (metode == 'dompet' ||
                                                                  saldo <
                                                                      hargaAmbil
                                                                          .numberValue
                                                              ? 4
                                                              : 0),
                                                      child: Text(
                                                        'Permudah Transaksimu dengan Undagi Pay, cukup topup dan gunakan sesuai saldo!',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                        maxLines: 11,
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // width: 220,
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: RaisedButton(
                                            color: AppTheme.bgChatBlue,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/udagi_pay');
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'TOPUP SEKARANG ',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppTheme.nearlyWhite,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                FaIcon(
                                                  FontAwesomeIcons
                                                      .angleDoubleRight,
                                                  color: AppTheme.nearlyWhite,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  metode != 'dompet'
                                      ? Container()
                                      : Container(
                                          width: 30,
                                          alignment: Alignment.center,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: AppTheme.bgChatBlue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              left: sizeu.width - 120, top: 10),
                                          child: FaIcon(
                                            FontAwesomeIcons.check,
                                            color: AppTheme.nearlyWhite,
                                            size: 14,
                                          )),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    metode = 'transfer';
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 30),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width:
                                                  metode == 'transfer' ? 2 : 0,
                                              color: AppTheme.bgChatBlue)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: widthInputHarga / 4,
                                            height: widthInputHarga / 4,
                                            padding: EdgeInsets.all(15),
                                            child: Image.asset(
                                                'assets/more_icon/cc_white.png'),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primarymenu,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(left: 7),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'BANK TRANSFER',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppTheme.bgChatBlue,
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                  top: 10,
                                                )),
                                                SizedBox(
                                                  width: widthInputHarga -
                                                      (widthInputHarga / 4) +
                                                      sisiBorderHarga * 2 -
                                                      33 -
                                                      20 -
                                                      (metode == 'transfer'
                                                          ? 4
                                                          : 0),
                                                  child: Text(
                                                    'Langsung bayar tagihanmu lewat Bank Transfer dengan dukungan Midtrans!',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    maxLines: 11,
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    metode != 'transfer'
                                        ? Container()
                                        : Container(
                                            width: 30,
                                            alignment: Alignment.center,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: AppTheme.bgChatBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: EdgeInsets.only(
                                                left: sizeu.width - 120,
                                                top: 20),
                                            child: FaIcon(
                                              FontAwesomeIcons.check,
                                              color: AppTheme.nearlyWhite,
                                              size: 14,
                                            )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //BUTTON BATAL
                      Container(
                        width: 95,
                        height: 25,
                        margin: EdgeInsets.only(
                            top: _height -
                                paddingPhone.top -
                                paddingPhone.bottom -
                                bottom -
                                20 -
                                424 -
                                25,
                            left: 20),
                        child: RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          color: AppTheme.geySoftCustom,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: AppTheme.geyCustom)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 15,
                                child: FaIcon(
                                  FontAwesomeIcons.undo,
                                  size: 11,
                                ),
                              ),
                              Text(
                                'BATAL',
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ),
                        ),
                      ),

                      //BTN BAYAR SEKARANG
                      Container(
                        width: 145,
                        height: 25,
                        margin: EdgeInsets.only(
                            top: _height -
                                paddingPhone.top -
                                paddingPhone.bottom -
                                20 -
                                bottom -
                                424 -
                                25,
                            left: _width - 165),
                        child: RaisedButton(
                          onPressed: () async {
                            if (metode == 'dompet') {
                              viaDompet();
                            } else {
                                      

                              onLoading(context);
                              await GeneralModel.token().then((v) {
                                
                                setState(() {
                                                                  stopLoad=true;
                                                                });
                                Navigator.pop(context);
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      
                                      return MidtransModal(
                                        other: {
                                          'jumlah_pembayaran':
                                              hargaAmbil.numberValue.round().toString(),
                                          'token': v.res,
                                          'proyek_id':pengerjaanId,
                                          'dp':!(_pilihPembayaran=='lunas')?1:0,
                                        },
                                        loadAgain: () {
                                            setState(() {
                                                                  stopLoad=false;
                                                                });
                                          Navigator.pop(context);
                                        },
                                      );
                                
                                    });
                             
                              });
                            }
                          },
                          color: metode == null
                              ? AppTheme.geyCustom
                              : AppTheme.primarymenu,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            // side: BorderSide(color: AppTheme.geyCustom)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 15,
                                child: Image.asset(
                                    'assets/more_icon/cc_white.png'),
                              ),
                              Text(
                                ' Bayar Sekarang',
                                style: TextStyle(
                                    fontSize: 13, color: AppTheme.nearlyWhite),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )),
            ),
    );
  }

  TextStyle styleTextGreyKecil() {
    return TextStyle(
      color: AppTheme.geySolidCustom,
      fontSize: 14,
    );
  }

  Container hargaInput(
      String label,
      double sisiBorderHarga,
      double widthInputHarga,
      TextEditingController textInput,
      FocusNode focus) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: styleTextGreyKecil(),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: sisiBorderHarga,
                  height: sisiBorderHarga,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.geySoftCustom,
                    border: Border.all(
                      width: 1,
                      color: AppTheme.geySolidCustom,
                    ),
                  ),
                  child: Text(
                    'Rp',
                    style: styleTextGreyKecil(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 13, 5, 0),
                  width: widthInputHarga,
                  height: sisiBorderHarga,
                  decoration: BoxDecoration(
                    color: label == 'Bayar'
                        ? Colors.white
                        : AppTheme.geySofttCustom,
                    border: Border(
                      top:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                      bottom:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                    ),
                  ),
                  child: TextField(
                    readOnly: isDP,
                    focusNode: focus,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
//  inputFormatters: [CustomTextInputFormatter()],
                    onChanged: (v) {
                      // widget.eventtChange(v);
                      // print(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    // onEditingComplete: (){
                    //   print(hargaAmbil.text);
                    // },

                    maxLength: 80,
                    controller: textInput,

                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: sisiBorderHarga,
                  height: sisiBorderHarga,
                  padding: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.geySoftCustom,
                    border: Border.all(
                      width: 1,
                      color: AppTheme.geySolidCustom,
                    ),
                  ),
                  child: Image.asset('assets/more_icon/dolar.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = newValue.text.replaceAll(' ', '').split('');
      String newString = '';
      for (int i = 0; i < chars.length; i++) {
        if (i % 3 == 0 && i != 0) newString += ' ';
        newString += chars[i];
      }

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}
