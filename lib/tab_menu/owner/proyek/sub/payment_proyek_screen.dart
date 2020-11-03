import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class PaymentProyekScreen extends StatefulWidget {
  @override
  _PaymentProyekScreenState createState() => _PaymentProyekScreenState();
}

class _PaymentProyekScreenState extends State<PaymentProyekScreen> {
  String _pilihPembayaran = 'lunas';

  TextEditingController hargaTotal = new TextEditingController();
  TextEditingController hargaAmbil = new TextEditingController();

  _changePemb(String val) {
    setState(() {
      _pilihPembayaran = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double _width = sizeu.width;
    double _height = sizeu.height;

    double marginHarga = 15;
    double paddingHarga = 10;
    double sisiBorderHarga = 30;
    double widthInputHarga =
        _width - marginHarga * 2 - paddingHarga * 2 - sisiBorderHarga * 2;

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
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Pembayaran',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          //SELECT BUTTON PEMBAYARAN
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
                  onTap: () => _changePemb('dp'),
                  child: Text(
                    ' DP (Minimal 30%)  ',
                    style: TextStyle(fontSize: 14, color: AppTheme.geyCustom),
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
                    style: TextStyle(fontSize: 14, color: AppTheme.geyCustom),
                  ),
                ),
              ],
            ),
          ),

          //INPUT HARGA
          Container(
              margin: EdgeInsets.fromLTRB(marginHarga, 15, marginHarga, 0),
              padding: EdgeInsets.all(paddingHarga),
              width: _width - (marginHarga * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.bgBlueSoft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  hargaInput('Harga Layanan', sisiBorderHarga, widthInputHarga,
                      hargaTotal),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  hargaInput('Harga Layanan', sisiBorderHarga, widthInputHarga,
                      hargaAmbil),
                ],
              )),

          //INFO & BUTTON
          Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(marginHarga, 0, marginHarga, 0),
                padding: EdgeInsets.fromLTRB(paddingHarga, 5, paddingHarga, 5),
                height: _height - 402,
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
                  padding: EdgeInsets.fromLTRB(10, 35, 15, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: widthInputHarga / 4,
                        height: widthInputHarga / 4,
                        padding: EdgeInsets.all(15),
                        child: Image.asset('assets/more_icon/cc_white.png'),
                        decoration: BoxDecoration(
                          color: AppTheme.primarymenu,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UNDAGI PAY',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
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
                                  33,
                              child: Text(
                                'Udangi pay adalah aplikasi Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vitae aliquam nibh, quis fermentum sapien. Mauris porttitor consequat massa. Etiam rutrum massa at eros interdum, ut porta eros sodales. Vestibulum tincidunt, ligula quis pellentesque pellentesque, sapien eros hendrerit nisl, at porttitor neque nunc sed libero. ',
                                style: TextStyle(fontSize: 12),
                                maxLines: 11,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //BUTTON BATAL
              Container(
                width: 95,
                height: 25,
                margin: EdgeInsets.only(top: _height - 402 - 30, left: 20),
                child: RaisedButton(
                  onPressed: () {},
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
                margin: EdgeInsets.only(top: _height - 402 - 30, left: _width-165),
                child: RaisedButton(
                  onPressed: () {},
                  color: AppTheme.primarymenu,
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
                        child: Image.asset('assets/more_icon/cc_white.png'),
                      ),
                      Text(
                        ' Bayar Sekarang',
                        style: TextStyle(fontSize: 13,color: AppTheme.nearlyWhite),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }

  TextStyle styleTextGreyKecil() {
    return TextStyle(
      color: AppTheme.geySolidCustom,
      fontSize: 14,
    );
  }

  Container hargaInput(String label, double sisiBorderHarga,
      double widthInputHarga, TextEditingController textInput) {
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
                    color: AppTheme.geySofttCustom,
                    border: Border(
                      top:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                      bottom:
                          BorderSide(width: .5, color: AppTheme.geySolidCustom),
                    ),
                  ),
                  child: TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
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
