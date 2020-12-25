import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/tampilan_publik/helper/modal_pilih_proyek.dart';
import 'package:undangi/tampilan_publik/helper/modal_undang_pekerja.dart';

class BtnOption extends StatefulWidget {
  @override
  _BtnOptionState createState() => _BtnOptionState();

  const BtnOption({
    Key key,
    this.itsMe = false,
    this.dataProyekAvail,
    this.id = 0,
    this.bottom = 0,
    this.loadAgain,
  }) : super(key: key);

  final bool itsMe;
  final List dataProyekAvail;
  final int id;
  final double bottom;
  final Function loadAgain;
}

class _BtnOptionState extends State<BtnOption> {
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: (sizeu.width - 16) / 2,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 135,
              child: RaisedButton(
                color: widget.itsMe ? Colors.grey[400] : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!widget.itsMe) {
                    //jika undang

                     return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalUdangPekerja(
                        
                            userId: widget.id.toString(),
                            bottom: widget.bottom,
                            loadAgain:(){
                              widget.loadAgain();
                            },
                          );
                        });
                  } else {
                    openAlertBox(context, 'Pemberitahuan!',
                        'Tidak bisa mengundang akun anda sendiri!', 'OK', () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'UNDANG SAYA  ',
                      style:
                          TextStyle(color: AppTheme.nearlyWhite, fontSize: 12),
                    ),
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: AppTheme.nearlyWhite,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: (sizeu.width - 16) / 2,
            alignment: Alignment.centerRight,
            // padding: EdgeInsets.only(right:10),
            child: SizedBox(
              width: 135,
              child: RaisedButton(
                color: widget.itsMe || widget.dataProyekAvail.length == 0
                    ? Colors.grey[400]
                    : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!widget.itsMe && widget.dataProyekAvail.length > 0) {
                    //jika undang
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModalPilihProyek(
                            dataProyek: widget.dataProyekAvail,
                            userId: widget.id.toString(),
                            bottom: widget.bottom,
                            loadAgain:(){
                              widget.loadAgain();
                            },
                          );
                        });
                  } else {
                    openAlertBox(
                        context,
                        'Pemberitahuan!',
                        widget.itsMe
                            ? 'Tidak bisa memilih akun anda sendiri!'
                            : 'Tidak ada Proyek Tersedia untuk pekerja ini!',
                        'OK', () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '   PILIH SAYA     ',
                      style:
                          TextStyle(color: AppTheme.nearlyWhite, fontSize: 12),
                    ),
                    FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: AppTheme.nearlyWhite,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
