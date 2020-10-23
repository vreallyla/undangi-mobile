import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';

class ProyekListScreen extends StatefulWidget {
  @override
  _ProyekListScreenState createState() => _ProyekListScreenState();
}

class _ProyekListScreenState extends State<ProyekListScreen> {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    TextEditingController cariProyekInput = new TextEditingController();
    double paddingWidthCard = 15;
    double marginWidthCard = 20;

    double imgWidth = (sizeu.width - marginWidthCard - paddingWidthCard) / 7;
    double marginPemisah = 8;
    double widthKategori =
        (sizeu.width - marginWidthCard - paddingWidthCard) / 4;

    //kategori
    double defaultWidthKategori = 94.10714285714286;
    double sizeTextKategori = 14;
    double textKategori =
        widthKategori / defaultWidthKategori * sizeTextKategori;

    //konten
    double widthKonten = sizeu.width -
        marginWidthCard -
        paddingWidthCard -
        imgWidth -
        marginPemisah -
        widthKategori;
    double defaultWidthKonten = 218.54591836734696;
    double sizeSubKonten = 9;
    double sizeHargaKonten = 16;
    double sizeKeteranganKonten = 12;
    double textSubKonten = widthKonten / defaultWidthKonten * sizeSubKonten;
    double textHargaKonten = widthKonten / defaultWidthKonten * sizeHargaKonten;
    double textKeteranganKonten =
        widthKonten / defaultWidthKonten * sizeKeteranganKonten;
    double widthIcoKonten = defaultWidthKonten / 12;

    return Scaffold(
      appBar: appPolosBack(paddingPhone, () {
        Navigator.pop(context);
      }),
      body: Container(
        color: AppTheme.primaryBg,
        margin: EdgeInsets.fromLTRB(
            marginWidthCard / 2, 20, marginWidthCard / 2, 20),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            //search bar
            SearcBox(
              controll: cariProyekInput,
              marginn: EdgeInsets.only(bottom: 20, left: 30, right: 30),
              paddingg: EdgeInsets.only(left: 15, right: 15),
              widthh: sizeu.width - 60 - 30 - 30 - 20,
              heightt: 50,
              widthText: sizeu.width - 80 - 30 - 30,
              textL: 45,
              placeholder: "Cari Proyek yang anda inginkan",
              eventtChange: (v) {
                print(v);
                // v is value of textfield
              },
              eventtSubmit: (v) {
                // v is value of textfield
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  paddingWidthCard / 2, 15, paddingWidthCard / 2, 15),
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: .8,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                color: AppTheme.cardBlue,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //gambar
                  Container(
                    height: imgWidth,
                    width: imgWidth,
                    margin: EdgeInsets.only(right: marginPemisah),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: .5,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      image: DecorationImage(
                        image: (AssetImage(
                            'assets/general/ilustration_desain.jpg')),
                        fit: BoxFit.fitWidth,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  //konten
                  Container(
                    width: widthKonten,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //total bid
                            SizedBox(
                              width: widthKonten / 2.3,
                              child: RichText(
                                text: TextSpan(
                                  text: 'TOTAL BID: ',
                                  style: TextStyle(
                                    color: AppTheme.geySolidCustom,
                                    fontSize: textSubKonten,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '1 ORANG',
                                      style: TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontSize: textSubKonten,
                                      ),
                                      // recognizer: _longPressRecognizer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //durasi
                            SizedBox(
                              width: widthKonten - (widthKonten / 2.3),
                              child: Row(
                                children: [
                                  Container(
                                    width: textSubKonten + 4,
                                    height: textSubKonten + 4,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: (AssetImage(
                                            'assets/more_icon/calender.png')),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '  Batas Waktu: ',
                                      style: TextStyle(
                                        color: AppTheme.geySolidCustom,
                                        fontSize: textSubKonten + 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '7 Hari',
                                          style: TextStyle(
                                            color: AppTheme.geySolidCustom,
                                            fontSize: textSubKonten + 1.5,
                                          ),
                                          // recognizer: _longPressRecognizer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        //harga
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            'Rp5.000.000',
                            style: TextStyle(
                              color: AppTheme.geySolidCustom,
                              fontSize: textHargaKonten,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // sub kategori
                        Text(
                          'Kategori Bahasa, Penerjemah:',
                          style: TextStyle(
                            color: AppTheme.geySolidCustom,
                            fontSize: textSubKonten + 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // sub kategori detail

                        Text(
                          'Translator dokumen',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: textSubKonten + 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        //keterangan
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Lorem Ipsum Dolor siamet',
                            style: TextStyle(
                              color: AppTheme.geySolidCustom,
                              fontSize: textKeteranganKonten,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //kategori
                  Container(
                    width: widthKategori,
                    padding: EdgeInsets.only(top: imgWidth / 4),
                    height: 40,
                    child: Text(
                      'UI/UX Desain',
                      style: TextStyle(
                        fontSize: textKategori,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  paddingWidthCard / 2, 15, paddingWidthCard / 2, 15),
              margin: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: .8,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                color: AppTheme.cardWhite,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //gambar
                  Container(
                    height: imgWidth,
                    width: imgWidth,
                    margin: EdgeInsets.only(right: marginPemisah),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: .5,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      image: DecorationImage(
                        image: (AssetImage(
                            'assets/general/ilustration_desain.jpg')),
                        fit: BoxFit.fitWidth,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  //konten
                  Container(
                    width: widthKonten,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //total bid
                            SizedBox(
                              width: widthKonten / 2.3,
                              child: RichText(
                                text: TextSpan(
                                  text: 'TOTAL BID: ',
                                  style: TextStyle(
                                    color: AppTheme.geySolidCustom,
                                    fontSize: textSubKonten,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '1 ORANG',
                                      style: TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontSize: textSubKonten,
                                      ),
                                      // recognizer: _longPressRecognizer,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //durasi
                            SizedBox(
                              width: widthKonten - (widthKonten / 2.3),
                              child: Row(
                                children: [
                                  Container(
                                    width: textSubKonten + 4,
                                    height: textSubKonten + 4,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: (AssetImage(
                                            'assets/more_icon/calender.png')),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '  Batas Waktu: ',
                                      style: TextStyle(
                                        color: AppTheme.geySolidCustom,
                                        fontSize: textSubKonten + 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '7 Hari',
                                          style: TextStyle(
                                            color: AppTheme.geySolidCustom,
                                            fontSize: textSubKonten + 1.5,
                                          ),
                                          // recognizer: _longPressRecognizer,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        //harga
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            'Rp5.000.000',
                            style: TextStyle(
                              color: AppTheme.geySolidCustom,
                              fontSize: textHargaKonten,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // sub kategori
                        Text(
                          'Kategori Bahasa, Penerjemah:',
                          style: TextStyle(
                            color: AppTheme.geySolidCustom,
                            fontSize: textSubKonten + 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // sub kategori detail

                        Text(
                          'Translator dokumen',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontSize: textSubKonten + 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        //keterangan
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Lorem Ipsum Dolor siamet',
                            style: TextStyle(
                              color: AppTheme.geySolidCustom,
                              fontSize: textKeteranganKonten,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //kategori
                  Container(
                    width: widthKategori,
                    padding: EdgeInsets.only(top: imgWidth / 4),
                    height: 40,
                    child: Text(
                      'UI/UX Desain',
                      style: TextStyle(
                        fontSize: textKategori,
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
