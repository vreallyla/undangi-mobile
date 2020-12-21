import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalBid extends StatefulWidget {
  @override
  _ModalBidState createState() => _ModalBidState();

  const ModalBid({
    Key key,
    this.tawarHarga,
    this.tawarWaktu,
    this.tawarTask,
  }) : super(key: key);

  final String tawarHarga;
  final String tawarWaktu;
  final String tawarTask;
}

class _ModalBidState extends State<ModalBid> {
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

  TextEditingController tawarHarga = new TextEditingController();
  TextEditingController tawarWaktu = new TextEditingController();
  TextEditingController tawarTask = new TextEditingController();
  bool setujuAnggrement = false;

  @override
  void initState() {
    setState(() {
      tawarHarga.text = widget.tawarHarga;
      tawarWaktu.text = widget.tawarWaktu;
      tawarTask.text = widget.tawarTask;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
      // contentPadding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        width: 350.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                    child: Text('Tawar Harga'),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppTheme.geySolidCustom),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: tawarHarga,
                      keyboardType: TextInputType.number,
                      decoration: textfieldDesign('Masukkan Harga'),
                      maxLength: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Text('Waktu Pengerjaan'),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppTheme.geySolidCustom),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: tawarWaktu,
                      keyboardType: TextInputType.number,
                      decoration:
                          textfieldDesign('Masukkan Waktu (Dihitung Hari)'),
                      maxLength: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Text('Ajukan Lingkup Task Pengerjaan'),
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      // bottom: ,
                    ),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: AppTheme.geySolidCustom),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: tawarTask,
                      maxLines: 4,
                      maxLength: 250,
                      decoration: textfieldDesign('Masukkan Usulan Task'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          child: Checkbox(
                            value: setujuAnggrement,
                            onChanged: (bool value) {
                              setState(() {
                                setujuAnggrement = value;
                              });
                            },
                          ),
                        ),
                        Text(' Saya Setuju '),
                        Text(
                          'Syarat dan Ketentuan',
                          style: TextStyle(
                            color: AppTheme.bgChatBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: RaisedButton(
                            onPressed: () => Navigator.pop(context),
                            color: AppTheme.bgChatGrey,
                            child: Text(
                              'KEMBALI',
                              style: TextStyle(color: AppTheme.nearlyWhite),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: RaisedButton(
                            onPressed: () {},
                            color: AppTheme.bgChatBlue,
                            child: Text(
                              'KIRIM',
                              style: TextStyle(color: AppTheme.nearlyWhite),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
