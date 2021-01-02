import 'dart:io';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_var.dart';

import 'package:undangi/Constant/app_widget.dart';


import 'package:webview_flutter/webview_flutter.dart';

class MidtransLayananModal extends StatefulWidget {
  @override
  _MidtransLayananModalState createState() => _MidtransLayananModalState();

  const MidtransLayananModal({Key key, this.loadAgain, this.other})
      : super(key: key);

  final Function loadAgain;

  final Map other;
}

class _MidtransLayananModalState extends State<MidtransLayananModal> {
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

  bool setujuAnggrement = true;

  bool loading = true;

  @override
  void initState() {
    // print(widget.other);
    super.initState();
    // Enable hybrid composition.
   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  Widget build(BuildContext context) {
    
    final sizeu = MediaQuery.of(context).size;

    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          // height: sizeu.height,
          width: sizeu.width,
          margin: EdgeInsets.only(top:loading? sizeu.height/2-60:40),

          child: Align(
            alignment: Alignment(0, -1),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                width: sizeu.width - 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      
                        height: loading?40:480,
                        child: Stack(
                          children: [
                            WebView(
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl:
                                  globalBaseUrl+'klien/layanan/payment/midtrans?jumlah_pembayaran=${widget.other['jumlah_pembayaran']}&token=${widget.other['token']}&pengerjaan_layanan_id=${widget.other['pengerjaan_layanan_id']}&dp=${widget.other['dp']}',
                              // navigationDelegate: (NavigationRequest request) {
                              //   if (request.url
                              //       .startsWith('https://www.youtube.com/')) {
                              //     print('blocking navigation to $request}');
                              //     return NavigationDecision.prevent;
                              //   }
                              //   print('allowing navigation to $request');
                              //   return NavigationDecision.navigate;
                              // },
                              onPageStarted: (String url) {
                                print('Page started loading: $url');
                                 if (url.indexOf('payment/midtrans') >= 0) {
                                // onLoading(context);
                                }
                                print(url);
                                int keya=url.indexOf('?status=');
                                if(keya>=0){
                                  switch(url.substring(keya+8)){
                                    case 'gagal':
                                    Navigator.pop(context);
                                    break;
                                    case 'berhasil':
                                    Navigator.pop(context);
                                    widget.loadAgain();
                                    openAlertSuccessBoxGoon(context,'Berhasil','Transaksi berhasil! Semoga Anda dan keluarga sehat selalu :) #dirumahaja','OK');
                                    break;
                                    default:
                                    Navigator.pop(context);
                                    openAlertBox(context,'Pemeritahuan',url.substring(keya+8),'OK',()=>Navigator.pop(context));

                                    break;
                                  }
                                  print(url.substring(keya+8));
                                }
                              },
                              onPageFinished: (String url) async{
                                print('Page finished loading: $url');
                                if (url.indexOf('payment/midtrans') >= 0) {
                                 Future.delayed(Duration(seconds: 1),(){
                                   setState(() {
                                                                        loading=false;
                                                                      });
// Navigator.pop(context);
                                 });
                                }
                              },
                            ),
                            loading?Container(
                              color: Colors.white,
                              child: onLoading2(),
                            ):Container()
                         
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
