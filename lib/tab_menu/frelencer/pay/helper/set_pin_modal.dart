import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/general_model.dart';

class SetPinModal extends StatefulWidget {
  @override
  _SetPinModalState createState() => _SetPinModalState();
  const SetPinModal({
    Key key,
    this.reload,
    this.pinIsExist: false,
  }) : super(key: key);

  final Function(String msg) reload;
  final bool pinIsExist;
}

class _SetPinModalState extends State<SetPinModal> {
  TextEditingController konfirmasiController = new TextEditingController();
  TextEditingController newPinController = new TextEditingController();
  TextEditingController repeatPinController = new TextEditingController();

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
      'konfirmasi': konfirmasiController.text,
      'pin': newPinController.text,
      'pin_repeat': repeatPinController.text,
    };

    GeneralModel.checCk(
        //connect
        () async {
      setErrorNotif({});
      DompetModel.pinChange(dataSend).then((v) {
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
          // widget.editEvent(0);
          // widget.toAddFunc();
          // widget.reloadGetApi();
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

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final paddingPhone = MediaQuery.of(context).padding;

    Color myColor = AppTheme.bgChatBlue;

    return WillPopScope(
      onWillPop: () {
        if(!widget.pinIsExist){
          Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/home');
        }else{
          Navigator.pop(context);
        }
      },
      child: new GestureDetector(
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
                            child: widget.pinIsExist
                                ? InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: FaIcon(
                                      FontAwesomeIcons.times,
                                      size: 14,
                                    ))
                                : Container(),
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
                  height: 330 -
                      bottom -
                      paddingPhone.top -
                      paddingPhone.bottom +
                      (bottom > 0 ? 100 : 0),
                  child: ListView(
                    children: [
                      //KONFIRMASI INPUT
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Text(
                          widget.pinIsExist ? 'PIN Lama' : 'Password',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                          child: TextField(
                            keyboardType: widget.pinIsExist
                                ? TextInputType.number
                                : TextInputType.text,
                            controller: konfirmasiController,
                            obscureText: true,
                            maxLength: 6,
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
                                hintText:
                                    "Masukkan ${widget.pinIsExist ? 'PIN Lama' : 'Password'}",
                                fillColor: Colors.white70),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: noticeText('konfirmasi', error),
                      ),

                      //NEW PIN
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Text('Set PIN', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                          child: TextField(
                            controller: newPinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 6,
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
                                hintText: "Masukkan PIN",
                                fillColor: Colors.white70),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: noticeText('pin', error),
                      ),

                      //REPEAT PIN
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                        child: Text('Ulangi PIN', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8),
                          child: TextField(
                            controller: repeatPinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 6,
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
                                hintText: "Masukkan PIN",
                                fillColor: Colors.white70),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: noticeText('pin_repeat', error),
                      ),

                      InkWell(
                        onTap: () {
                          if (
                              //CHECK KONFIRM
                              (widget.pinIsExist
                                      ? (konfirmasiController.text.length == 6)
                                      : konfirmasiController.text.length > 4) &&
                                  //CHECK PIN
                                  newPinController.text.length == 6 &&
                                  newPinController.text ==
                                      repeatPinController.text) {
                            _saveApi();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: konfirmasiController.text.length == 6
                                ? myColor
                                : Colors.grey,
                          ),
                          child: Text(
                            "SIMPAN",
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
      ),
    );
  }
}
