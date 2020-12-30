import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/general_model.dart';

class WithdrawModal extends StatefulWidget {
  @override
  _WithdrawModalState createState() => _WithdrawModalState();
  const WithdrawModal({
    Key key,
    this.submit,
    this.saldo: 0,
  }) : super(key: key);

  final Function(String msg) submit;
  final double saldo;
}

class _WithdrawModalState extends State<WithdrawModal> {
  TextEditingController pinController = new TextEditingController();
  TextEditingController bankController = new TextEditingController();
  TextEditingController noRekController = new TextEditingController();
  TextEditingController anController = new TextEditingController();
  MoneyMaskedTextController nominalController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  //INDIKATOR PIN MATCH
  bool pinMatched = false;

  FocusNode ambilFocus = new FocusNode();

  //ERROR DATA INPUT
  Map error = {};

  void setErrorNotif(Map res) {
    setState(() {
      error = res;
    });
  }

  Map errorWithdraw = {};

  void setErrorWithdraw(Map res) {
    setState(() {
      errorWithdraw = res;
    });
  }

  _checkApi() async {
    print(pinController.text);
    onLoading(context);
    Map dataSend = {
      'pin': pinController.text,
    };

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      DompetModel.pinCheck(dataSend).then((v) {
        Navigator.pop(context);
        print(v.data);
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
          setState(() {
            nominalController.updateValue(widget.saldo ?? 0);
            bankController.text = v.data['user']['bank'] != null
                ? v.data['user']['bank']['nama']
                : kontenkosong;
            noRekController.text = v.data['user']['rekening'] ?? kontenkosong;
            anController.text = v.data['user']['an'] ?? kontenkosong;

            pinMatched = true;
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

  _assesmentApi() async {
    print(pinController.text);
    onLoading(context);
    Map dataSend = {
      'withdraw': nominalController.numberValue.toString(),
    };

    GeneralModel.checCk(
        //connect
        () async {
      setErrorWithdraw({});
      DompetModel.withdraw(dataSend).then((v) {
        Navigator.pop(context);
        print(v.data);
        if (v.error) {
          if (v.data.containsKey('notValid')) {
            setErrorWithdraw(v.data['message']);
            openAlertBox(context, noticeTitle, noticeForm, konfirm1, () {
              Navigator.pop(context);
            });
          } else {
            errorRespon(context, v.data);
          }
        } else {
          Navigator.pop(context);
          widget.submit(v.data['message']);
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
  void dispose() {
    // TODO: implement dispose
    ambilFocus.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ambilFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // debugPrint("Focus: "+ambilFocus.hasFocus.toString());

    setState(() {
      print(nominalController.text);

      if (!ambilFocus.hasFocus &&
          nominalController.numberValue > widget.saldo) {
        nominalController.updateValue(widget.saldo ?? 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = AppTheme.bgChatBlue;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final paddingPhone = MediaQuery.of(context).padding;
    final sizeu = MediaQuery.of(context).size;

    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          // height: sizeu.height,
          width: sizeu.width,
          margin: EdgeInsets.only(top: pinMatched ? 20 : 100.0),

          child: Align(
            alignment: Alignment(0, -1),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                width: sizeu.width - 50,
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

                    SizedBox(
                      width: double.infinity,
                      height: (pinMatched
                          ? (405 - bottom + (bottom > 0 ? 100 : 0))
                          : 186),
                      child: ListView(
                        children: [
                          pinMatched ? formWithdraw() : formPin(),
                          InkWell(
                            onTap: () {
                              if (pinController.text.length == 6 &&
                                  !pinMatched) {
                                _checkApi();
                              }
                              if (pinMatched &&
                                  nominalController.numberValue > 0) {
                            
                                _assesmentApi();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: (pinController.text.length == 6 &&
                                            !pinMatched) ||
                                        (pinMatched &&
                                            nominalController.numberValue > 0)
                                    ? myColor
                                    : Colors.grey,
                              ),
                              child: Text(
                                pinMatched ? 'WITHDRAW' : "CHECK",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
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

  Widget formPin() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text('PIN'),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15),
              child: TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                style: TextStyle(fontSize: 12, height: 1),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Masukkan PIN",
                    fillColor: Colors.white70),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: noticeText('pin', error),
          ),
        ],
      ),
    );
  }

  Widget formWithdraw() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NOMINAL
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text('Jumlah Withdraw'),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8),
              child: TextField(
                focusNode: ambilFocus,
                controller: nominalController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 12, height: 1),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Masukkan Nominal",
                    fillColor: Colors.white70),
              )),

          //BANK
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text('Bank Tujuan'),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8),
              child: TextField(
                controller: bankController,
                // keyboardType: TextInputType.number,
                enabled: false,
                style: TextStyle(fontSize: 12, height: 1),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Nama Bank",
                    fillColor: Colors.grey[200]),
              )),

          //NO REK
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text('Nomor Rekening'),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8),
              child: TextField(
                controller: noRekController,
                enabled: false,
                // keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 12, height: 1),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "No rekening",
                    fillColor: Colors.grey[200]),
              )),

          //AN
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text('Atas Nama'),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15),
              child: TextField(
                enabled: false,
                controller: noRekController,
                // keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 12, height: 1),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Atas Nama",
                    fillColor: Colors.grey[200]),
              )),
        ],
      ),
    );
  }
}
