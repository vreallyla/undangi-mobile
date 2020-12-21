import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:undangi/Constant/app_widget.dart';


class HtmlRead extends StatefulWidget {
  @override
  _HtmlReadState createState() => _HtmlReadState();

  const HtmlRead({
    Key key,
    this.url,
  }) : super(key: key);

  final String url;
}

class _HtmlReadState extends State<HtmlRead> {
   @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: appPolosBack(paddingPhone,(){
Navigator.pop(context);
      }),
          body: WebView(
        initialUrl: widget.url,
      ),
    );
  }
}