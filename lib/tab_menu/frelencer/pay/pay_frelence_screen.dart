import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class PayFrelenceScreen extends StatefulWidget {
  @override
  _PayFrelenceScreenState createState() => _PayFrelenceScreenState();
}

class _PayFrelenceScreenState extends State<PayFrelenceScreen> {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    double _height = sizeu.height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: appBarColloring(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBackWithPhoto(
            context,
            'assets/general/changwook.jpg',
          ),
          //tag name
          Container(
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
            child: Column(
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
                Row(
                  children: [
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
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 130,
                        height: 30,
                        child: RaisedButton(
                          color: AppTheme.nearlyWhite,
                          onPressed: () {
                            passwordCheck(context, () {
                              Navigator.pop(context);
                              Color myColor = AppTheme.bgChatBlue;

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
                    )
                  ],
                ),
                Container(
                  width: (_width - 20) / 2,
                  child: Text(
                    'Rp0,00',
                    style: TextStyle(
                        color: AppTheme.nearlyWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          //list view data

          Container(
            height: _height - 340 - bottom,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              border: Border.all(width: .5, color: AppTheme.geyCustom),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              children: [
                Container(
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
                              'Pembayaran Melalui Undagi Berhasil!',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Text(
                              'Pembayaran untuk transaksi 1234567890 menggunakan Undagi Pay telah berhasil dan dana sebesar Rp. 5,000,000 telah DITAMBAHKAN di Undagi Pay-mu',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                            ),
                            Text(
                              '14-10-2020 21:14',
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  
}
