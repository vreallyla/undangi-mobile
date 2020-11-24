import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

import 'sub/portfolio_tambah_screen.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({
    Key key,
    this.dataPort,
    this.checkData,
  }) : super(key: key);

  final List dataPort;
  final bool checkData;

  Widget dataLoad(context) {
    final sizeu = MediaQuery.of(context).size;

    List<Widget> dataWidget = <Widget>[];

    //card add portfolio
    dataWidget.add(Container(
      margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
        // border: Border.all(width: .5, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.bgRedSoft,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: (sizeu.width - 70) / 1.8,
            margin: EdgeInsets.only(right: 10, bottom: 10),
            height: (sizeu.width - 70) / 1.8 - 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (AssetImage('assets/general/hold_content.png')),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            width: (sizeu.width - 70 - (sizeu.width - 70) / 1.8) - 10,
            // height: (sizeu.width - 70) / 1.8 - 40,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  'Tambah Portfoliomu!',
                  style: TextStyle(
                    color: AppTheme.textBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PortfolioTambahScreen()));
                  },
                  color: AppTheme.primaryBlue,
                  child: Row(
                    children: [
                      SizedBox(
                        width: sizeu.width - 325,
                        child: Text(
                          'Buat',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));

    //card portfolio list
    dataPort.forEach((value) {
      dataWidget.add(Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          // border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.bgBlueSoft,
        ),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //gambar portfolio
                Container(
                  width: (sizeu.width - 70) / 2.5,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  height: 80,
                  decoration: BoxDecoration(color: AppTheme.geyCustom),
                  child: value.containsKey('foto')
                      ? CachedNetworkImage(
                          imageUrl: domainChange(value['foto']),
                          placeholder: (context, url) => SizedBox(
                              width: 80,
                              child: new CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )
                      : Text(''),
                ),
                Container(
                  width: (sizeu.width - 70) - (sizeu.width - 70) / 2.5,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(value['judul'],
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppTheme.textBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(value['tautan'],
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppTheme.geySolidCustom,
                                  fontSize: 12)),
                        ),
                        Text(value['deskripsi'],
                            textAlign: TextAlign.justify,
                            maxLines: 4,
                            style: TextStyle(
                                color: AppTheme.textBlue, fontSize: 12)),
                      ]),
                )
              ],
            ),
          ),
          //other option

          Padding(
            padding: EdgeInsets.only(left: (sizeu.width - 60) - 10 - 80),
            child: PopupMenuButton(
              child: Padding(
                padding: EdgeInsets.only(left: 80, top: 5),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.more_vert),
                ),
              ),
              onSelected: (newValue) {
                if (newValue == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              PortfolioTambahScreen()));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Edit Portfolio"),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text("Hapus Portfolio"),
                  value: 1,
                ),
              ],
            ),
          ),
        ]),
      ));
    });
    return Column(
      children: dataWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 40), child: dataLoad(context));
  }
}
