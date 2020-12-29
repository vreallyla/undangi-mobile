import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rating_bar/rating_bar.dart';

class RatingModal extends StatefulWidget {
  @override
  _RatingModalState createState() => _RatingModalState();
  const RatingModal({
    Key key,
    this.eventRes,
    this.isLunas,
    this.isProyek: false,
    this.nama,
  }) : super(key: key);

  final Function(Map res) eventRes;
  final bool isLunas;
  final bool isProyek;
  final String nama;
}

class _RatingModalState extends State<RatingModal> {
  double star = 0;
  bool puas = false;
  TextEditingController deskripsiController = new TextEditingController();

  @override
  void initState() {
    setState(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
          child: AlertDialog(
        backgroundColor: Color(0xfff7f7f7),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: 400.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'ULASAN ANDA',
                  style: TextStyle(
                    color: AppTheme.textBlue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppTheme.geyCustom),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        // padding: EdgeInsets.only(right: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(
                            FontAwesomeIcons.times,
                            color: AppTheme.geyCustom,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        'Ratings',
                        style: TextStyle(
                          color: AppTheme.geyCustom,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
                        child: RatingBar(
                          maxRating: 5,
                          onRatingChanged: (rating) {
                            star = rating;
                            setState(() {});
                          },
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          halfFilledIcon: Icons.star_half,
                          isHalfAllowed: true,
                          filledColor: Colors.amber,
                          size: 36,
                        ),
                      ),
                      Text(
                        'Ulasan Anda',
                        style: TextStyle(
                          color: AppTheme.geyCustom,
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        controller: deskripsiController,
                        style: TextStyle(fontSize: 12),
                        maxLines: 3,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.grey[800]),
                            hintText: "Ulasan",
                            fillColor: Colors.white70),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {
                            if(widget.isLunas){
                              setState(() {
                              puas = !puas;
                            });
                            }else{
                              openAlertBox(
    context, 'Pembayaran Belum Lunas', 'Harap lunasi pembayaran terlebih dahulu sebelum menyelesaikan ${widget.isProyek?'Proyek':'Layanan'}', 'OK', ()=>Navigator.pop(context));
                            }
                            
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            
                            children: [
                              SizedBox(
                                width: 20,
                                height: 25,
                                child: IgnorePointer(
                                  child: Checkbox(
                                    value: puas,
                                    onChanged: (bool value) {
                                      setState(() {
                                        puas = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              SizedBox(
                                  width: sizeu.width - 20 - 135,
                                  child: Text(
                                      'Saya puas dengan ${(widget.isProyek ? "Proyek" : "Layanan")} ${widget.nama.toString()} (centang jika ${(widget.isProyek ? "Proyek" : "Layanan")} sudah selesai)',
                                      style: TextStyle(color:widget.isLunas? AppTheme.textBlue:Colors.grey[500]),),
                                      )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 80),
                        alignment: Alignment.topRight,
                        child: RaisedButton(
                          onPressed: () {
                            if (deskripsiController.text.length > 0&& star>0) {
                              Navigator.pop(context);
                              widget.eventRes({
                                'bintang': star.toString(),
                                'deskripsi': deskripsiController.text,
                                'puas': puas?'1':'0',
                              });
                            }
                          },
                          color: deskripsiController.text.length > 0
                              ? AppTheme.bgChatBlue
                              : Colors.grey,
                          child: Text(
                            'SIMPAN',
                            style: TextStyle(color: AppTheme.nearlyWhite),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
