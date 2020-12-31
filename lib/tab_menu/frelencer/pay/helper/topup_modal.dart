import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/dompet_model.dart';
import 'package:undangi/Model/general_model.dart';

class TopupModal extends StatefulWidget {
  @override
  _TopupModalState createState() => _TopupModalState();
  const TopupModal({
    Key key,
    this.reload,
    this.pinIsExist: false,
  }) : super(key: key);

  final Function(String nominal) reload;
  final bool pinIsExist;
}

class _TopupModalState extends State<TopupModal> {
   MoneyMaskedTextController nominalController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  //ERROR DATA INPUT
  Map error = {};

  void setErrorNotif(Map res) {
    setState(() {
      error = res;
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
                  height: 175,
                  child: ListView(
                    children: [
            
                      //NEW PIN
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Text('Nominal Transfer', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                          child: TextField(
                            controller: nominalController,
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
                                hintText: "Masukkan Nominal",
                                fillColor: Colors.white70),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 15),
                        child: noticeText('nominal', error),
                      ),

                   
                      InkWell(
                        onTap: () {
                          if (
                             nominalController.numberValue>0) {
                            widget.reload( nominalController.numberValue.toString());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: nominalController.numberValue>0
                                ? myColor
                                : Colors.grey,
                          ),
                          child: Text(
                            "TOPUP",
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
