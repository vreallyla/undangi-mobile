import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_screen.dart';

class cardBidder extends StatefulWidget {
  @override
  _cardBidderState createState() => _cardBidderState();
  const cardBidder({
    Key key,
    this.data,
    this.i = 0,
    this.itsMe: true,
  }) : super(key: key);

  final int i;
  final Map data;
  final bool itsMe;
}

class _cardBidderState extends State<cardBidder> {
  bool lihat = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    Map value = widget.data;
    int z = 0;
    if (widget.i % 1 == 0) {
      z = 0;
    }
    if (widget.i % 2 == 0) {
      z = 1;
    }
    if (widget.i % 3 == 0) {
      z = 2;
    }
    if (widget.i % 4 == 0) {
      z = 3;
    }
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: (widget.itsMe ? 10 : 20), bottom: 10),
          width: sizeu.width - 20 - (widget.itsMe ? 20 : 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.renoReno[z],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TampianPublikScreen(
                            id: value['id'],
                          )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: imageLoad(value['foto'], true, 60, 60),
                    ),
                    Container(
                      width: sizeu.width - 141 + 10,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 5, color: AppTheme.geyCustom),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/general/user_place.png',
                                width: 30,
                                height: 30,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                width: sizeu.width - 30 - 141 - 15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        value['nama'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, bottom: 3),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconShadowWidget(
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.yellow,
                                            ),
                                            shadowColor: AppTheme.geyCustom,
                                          ),
                                          Text(
                                            ' ' + value['bintang'].toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w100),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Penawaran Harga : Rp' +
                                pointGroup(int.parse(
                                    value['negoharga'].toString() ?? '0')),
                          ),
                          Text(
                            'Waktu Pengerjaan : ' +
                                pointGroup(int.parse(
                                    value['negowaktu'].toString() ?? '0')) +
                                ' Hari',
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                lihat
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value['task'] ?? 'Tidak ada keterangan Task'),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    lihat = !lihat;
                                  });

                                  print(lihat);
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'SEMBUNYIKAN PENAWARAN TASK',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: AppTheme.geyCustom,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              lihat = !lihat;
                            });

                            print(lihat);
                          },
                          child: Text(
                            'LIHAT PENAWARAN TASK',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppTheme.geyCustom,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        !widget.itsMe?Container(): Container(
          width: 80,
          margin: EdgeInsets.only(left: sizeu.width - 80, top: 40),
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: value['tolak'] != null
                  ? (value['tolak'] == 0 ? AppTheme.bgChatBlue : Colors.red)
                  : Colors.grey[600],
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            value['tolak']==null?'Menunggu Konfirmasi':(value['tolak']==0?'Diterima':'Ditolak'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppTheme.nearlyWhite,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
        ),
        widget.itsMe && value['tolak']==null
            ? Container(
                margin: EdgeInsets.only(
                  left: sizeu.width - 40 - 10,
                  top: 10,
                ),
                child: PopupMenuButton(
                  child: SizedBox(
                      width: 30,
                      child: FaIcon(
                        FontAwesomeIcons.ellipsisV,
                        size: 16,
                        color: Colors.grey[700],
                      )),
                  onSelected: (newValue) async {
                    if (newValue == 0) {}
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Pilih Bidder'),
                      value: 0,
                    ),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}
