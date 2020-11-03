import 'dart:html';

import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'dart:html';

class PaymentProyekScreen extends StatefulWidget {
  @override
  _PaymentProyekScreenState createState() => _PaymentProyekScreenState();
}

class _PaymentProyekScreenState extends State<PaymentProyekScreen> {
  String pilihPembayaran = 'lunas';

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;

    return Scaffold(
      appBar: appBarColloring(),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appDashboard(
              context,
              'assets/general/changwook.jpg',
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
            padding: EdgeInsets.only(top: 15),
            child: Text(
              'Pembayaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            width: _width,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pembayaran: ',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
