import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';

class PengerjaanListFrelenceTab extends StatefulWidget {
  const PengerjaanListFrelenceTab({
    Key key,
    this.bottomKey = 0,
    this.reloadFunc,
    this.nextData,
    this.dataBid,
    this.loading,
    this.refresh,
  }) : super(key: key);

  final double bottomKey;
  final bool loading;
  final List dataBid;

  final RefreshController refresh;

  final Function() reloadFunc;
  final Function() nextData;
  @override
  _PengerjaanListFrelenceTabState createState() =>
      _PengerjaanListFrelenceTabState();
}

class _PengerjaanListFrelenceTabState extends State<PengerjaanListFrelenceTab> {
  TextEditingController inputKategori = new TextEditingController();
  TextEditingController inputJudul = new TextEditingController();

  String jnsProyek = 'publik';
  @override
  Widget build(BuildContext context) {
    double marginLeftRight = 10;
    double marginCard = 5;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 5;

    return proyekList((id) {});
  }

  Widget inputHug(String hint, FaIcon icon, TextEditingController controller) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 3),
      width: sizeu.width,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: icon,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.geyCustom.withOpacity(.2)),
          ),
        ),
        Container(
          child: TextField(
            style: TextStyle(
              fontSize: 13.0,
            ),
            controller: controller,
            maxLength: 45,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              suffixStyle: TextStyle(color: Colors.black),
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
            ),
          ),
          width: sizeu.width - 93,
          padding: EdgeInsets.only(left: 5, right: 5, top: 14),
          alignment: Alignment.centerLeft,
          // height: 25,
          decoration: BoxDecoration(
              color: AppTheme.geySofttCustom.withOpacity(.8),
              border: Border(
                top: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                right: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                bottom: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
              )),
        ),
      ]),
    );
  }

  Widget judulLabel(String judul) {
    return SizedBox(
      height: 18,
      child: Text(
        judul,
        style: TextStyle(
            fontSize: 14,
            color: AppTheme.geySolidCustom,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget proyekList(Function(int id) editEvent) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);
    double imgCard = widthCard / 6;
    double heightCard = 110;
    double widthBtnShort = 85;
    double widthBtnPlay = 40;
    double widthKonten = widthCard - imgCard - widthBtnShort - 2;
    return Container(
        margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
        padding: EdgeInsets.all(marginCard),
        alignment: Alignment.topLeft,
        height: sizeu.height - 360 - widget.bottomKey,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: .5,
            color: Colors.black,
          ),
        ),
        child: widget.loading
            ? onLoading2()
            : (widget.dataBid.length == 0
                ? dataKosong()
                : SmartRefresher(
                    header: ShimmerHeader(
                      text: Text(
                        "PullToRefresh",
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      baseColor: AppTheme.bgChatBlue,
                    ),
                    footer: ShimmerFooter(
                      text: Text(
                        "PullToRefresh",
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      noMore: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "AllUserLoaded",
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ),
                      ),
                      baseColor: AppTheme.bgChatBlue,
                    ),
                    controller: widget.refresh,
                    enablePullUp: true,
                    child: ListView.builder(
                        itemCount: widget.dataBid.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) {
                          return ProyekCard(
                            marginLeftRight: marginLeftRight,
                            marginCard: marginCard,
                            deleteBid: (String id) {
                              //TODO:: delete bid
                            },
                            data: widget.dataBid[i],
                            index: i,
                          );
                        }),
                    onRefresh: widget.reloadFunc,
                    onLoading: widget.nextData,
                  )));
  }
}

class ProyekCard extends StatelessWidget {
  const ProyekCard({
    Key key,
    this.marginLeftRight,
    this.marginCard,
    this.deleteBid,
    this.data,
    this.index,
  }) : super(key: key);

  final Function(String id) deleteBid;
  final Map data;
  final int index;
  final double marginLeftRight;
  final double marginCard;

  transColor(i) {
    int res = 0;
    if ((i + 1) % 1 == 0) {
      res = 0;
    }
    if ((i + 1) % 2 == 0) {
      res = 1;
    }
    if ((i + 1) % 3 == 0) {
      res = 2;
    }
    if ((i + 1) % 4 == 0) {
      res = 3;
    }
    return res;
  }

  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);

    return Container(
        // height: heightCard + 20,
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        padding: EdgeInsets.all(paddingCard),
        decoration: BoxDecoration(
          color: AppTheme.renoReno[transColor(index)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headCard(context, paddingCard, widthCard, data),
            komenCard(context, paddingCard, widthCard, data),
          ],
        ));
  }

  Widget headCard(context, double paddingCard, double widthCard, Map data) {
    double imgCard = widthCard / 6;
    double heightCard = 90;
    double widthBtnShort = 100;

    double widthKonten = widthCard - imgCard - widthBtnShort - 2;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //row image
              Container(
                height: imgCard,
                width: imgCard,
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  boxShadow: [
                    //background color of box
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4, // soften the shadow
                      spreadRadius: 1, //extend the shadow
                      offset: Offset(
                        .5, // Move to right 10  horizontally
                        3, // Move to bottom 10 Vertically
                      ),
                    ),
                  ],
                ),
                child: imageLoad(
                    data['proyek'] != null ? data['proyek']['thumbnail'] : null,
                    false,
                    imgCard,
                    imgCard),
              ),
              //kontent
              Container(
                width: widthKonten,
                height: heightCard,
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 1),
                      child: Text(
                        data['proyek'] != null
                            ? data['proyek']['judul']
                            : unknown ?? empty,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppTheme.primarymenu,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Rp' +
                            decimalPointTwo(data['proyek'] != null
                                ? data['proyek']['harga'].toString()
                                : '0'),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        'KATEGORI ' +
                            (data['proyek'] != null &&
                                    data['proyek']['kategori'] != null
                                ? data['proyek']['kategori']['nama']
                                : unknown) +
                            ":",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      (data['proyek'] != null &&
                              data['proyek']['subkategori'] != null
                          ? data['proyek']['subkategori']['nama']
                          : unknown),
                      style: TextStyle(
                        color: AppTheme.primarymenu,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              //btn
              Container(
                width: widthBtnShort,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    btnTool('assets/more_icon/progress_bar.png',
                        BorderRadius.circular(30.0), widthBtnShort - 15, () {
                      //TODO::REDIRECT PENGERJAAN
                      // changeProgress();
                    }),
                    InkWell(
                      onTap: () {
                        openAlertBox(
                            context,
                            'APAKAH ANDA YAKIN?',
                            'Untuk menyelesaikan PEKERJAAN ini',
                            'KONFIRMASI', () {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primarymenu,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          data['status'] ?? 'belum diketahui',
                          style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //informasi
          Container(
            margin: EdgeInsets.only(left: imgCard + 5),
            child: Row(
              children: [
                Text(
                  'TOTAL BID: ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  moreThan99(data['proyek'] != null
                          ? (data['proyek']['jumlah_bid'] ?? 0)
                          : 0) +
                      ' ORANG  ',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primarymenu,
                  ),
                ),
                Image.asset(
                  'assets/more_icon/calender.png',
                  width: 15,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  ' Batas Waktu: ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  pointGroup(int.parse(data['proyek'] != null &&
                              data['proyek']['waktu_pengerjaan'] != null
                          ? data['proyek']['waktu_pengerjaan'].toString()
                          : 0)) +
                      ' Hari',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  komenOwner(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
                                //TODO:: SET RANTING
                                //  starEvent(rating);
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
                            style: TextStyle(fontSize: 12),
                            maxLines: 3,
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                filled: true,
                                hintStyle:
                                    new TextStyle(color: Colors.grey[800]),
                                hintText: "Ulasan",
                                fillColor: Colors.white70),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 80),
                            alignment: Alignment.topRight,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: AppTheme.bgChatBlue,
                              child: Text(
                                'Simpan',
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
          );
        });
  }

  Widget komenCard(context, double paddingCard, double widthCard, Map data) {
    final sizeu = MediaQuery.of(context).size;

    double marginLeft = widthCard / 6 / 3;
    double marginRight = 0;
    double photoWidth = 45;
    double pembatas = 4;
    double wightboder = 3;
    double btnRight = 60;
    double marginLeftKomen = 15;
    double widthSub = widthCard - marginLeft - marginLeftKomen - btnRight;
    return Container(
      margin: EdgeInsets.only(
        left: marginLeft,
        right: marginRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'PEKERJA',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //photo comment
              Container(
                alignment: Alignment.center,
                height: photoWidth,
                width: photoWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: data['pekerja'].containsKey('foto')
                    ? imageLoad(
                        data['pekerja']['foto'], true, photoWidth, photoWidth)
                    : Image.asset(
                        'assets/general/user.png',
                        width: photoWidth,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              Stack(
                children: [
                  // nama & bintang
                  Container(
                    padding: EdgeInsets.only(left: pembatas * 2 + wightboder),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/general/user_place.png',
                              width: 12,
                              fit: BoxFit.fitWidth,
                            ),
                            Text(
                              ' ' +
                                  (data['pekerja'].containsKey('nama')
                                      ? data['pekerja']['nama']
                                      : tanpaNama),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              Text(
                                ' ' +
                                    (data['pekerja'].containsKey('bintang')
                                        ? data['pekerja']['bintang']
                                        : '0'),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //komen frelencer
                  Container(
                    width: sizeu.width - photoWidth - 74,
                    padding: EdgeInsets.only(
                      left: pembatas,
                      top: 33,
                      bottom: 5,
                    ),
                    margin: EdgeInsets.only(left: pembatas),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            width: wightboder, color: AppTheme.geySolidCustom),
                      ),
                    ),
                    child: Text(
                      (data['pekerja'].containsKey('summary')
                          ? data['pekerja']['summary']
                          : empty),
                      // '',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //lampiran
              SizedBox(
                width: widthCard - marginLeft - marginRight - 1 - btnRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        'LAMPIRAN HASIL PEKERJAAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 3,
                      ),
                      child: Text(
                        data.containsKey('file_hasil') &&
                                data['file_hasil'].length > 0
                            ? data['file_hasil'].length.toString() + ' lampiran'
                            : empty,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                      child: Text(
                        'TAUTAN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 3,
                        bottom: 6,
                      ),
                      child: Text(
                        data['tautan'] != null
                            ? data['tautan'].toString()
                            : empty,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              // btn
              Container(
                width: btnRight,
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      btnTool('assets/more_icon/file_alt.png',
                          BorderRadius.circular(30.0), 50, () {
                        print('file');
                      }),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                        ),
                      ),
                      btnTool('assets/more_icon/cc.png',
                          BorderRadius.circular(30.0), 50, () {
                        //TODO:: REDIRECT OTHER
                        // waktuLoadRepeat(560);
                        // pauseLoad(true);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         PaymentProyekScreen(
                        //       proyekId: data['id'],
                        //     ),
                        //   ),
                        // );
                      }),
                    ]),
              ),
            ],
          ),

          //SUB KOMEN
          Container(
              margin: EdgeInsets.only(left: marginLeftKomen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'ULASAN KLIEN',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //photo comment
                      Container(
                        alignment: Alignment.center,
                        height: photoWidth,
                        width: photoWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: data['ulasan'].containsKey('ulasan_pekerja')
                            ? imageLoad(
                                data['ulasan']['ulasan_pekerja']['foto'],
                                true,
                                photoWidth,
                                photoWidth)
                            : Image.asset(
                                'assets/general/user.png',
                                width: photoWidth,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Stack(
                        children: [
                          // nama & bintang
                          Container(
                            width: widthSub - photoWidth,
                            padding: EdgeInsets.only(
                                left: pembatas * 2 + wightboder),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/general/user_place.png',
                                      width: 12,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    SizedBox(
                                      width: widthSub -
                                          12 -
                                          photoWidth -
                                          (pembatas * 2 + wightboder),
                                      child: Text(
                                        ' ' +
                                            (data['ulasan'].containsKey(
                                                    'ulasan_pekerja')
                                                ? data['ulasan']
                                                            ['ulasan_pekerja']
                                                        ['nama']
                                                    .toString()
                                                : tanpaNama),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      Text(
                                        ' ' +
                                            (data['ulasan'].containsKey(
                                                        'ulasan_pekerja') &&
                                                    data['ulasan'][
                                                                'ulasan_pekerja']
                                                            ['bintang'] !=
                                                        null
                                                ? data['ulasan']
                                                            ['ulasan_pekerja']
                                                        ['bintang']
                                                    .toString()
                                                    .toString()
                                                : '0.0'),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //komen frelencer
                          Container(
                            width: widthSub - btnRight,
                            padding: EdgeInsets.only(
                              left: pembatas,
                              top: 33,
                              bottom: 5,
                            ),
                            margin: EdgeInsets.only(left: pembatas),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: wightboder,
                                    color: AppTheme.geySolidCustom),
                              ),
                            ),
                            child: Text(
                              ' ' +
                                  (data['ulasan']
                                              .containsKey('ulasan_pekerja') &&
                                          data['ulasan']['ulasan_pekerja']
                                                  ['deskripsi'] !=
                                              null
                                      ? data['ulasan']['ulasan_pekerja']
                                              ['deskripsi']
                                          .toString()
                                          .toString()
                                      : belumReview),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                 
                    ],
                  ),
                ],
              )),

          Container(
              margin: EdgeInsets.only(left: marginLeftKomen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'ULASAN PEKERJA',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //photo comment
                      Container(
                        alignment: Alignment.center,
                        height: photoWidth,
                        width: photoWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: data['ulasan'].containsKey('ulasan_klien')
                            ? imageLoad(data['ulasan']['ulasan_klien']['foto'],
                                true, photoWidth, photoWidth)
                            : Image.asset(
                                'assets/general/user.png',
                                width: photoWidth,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Stack(
                        children: [
                          // nama & bintang
                          Container(
                            width: widthSub - photoWidth,
                            padding: EdgeInsets.only(
                                left: pembatas * 2 + wightboder),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/general/user_place.png',
                                      width: 12,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    SizedBox(
                                      width: widthSub -
                                          12 -
                                          photoWidth -
                                          (pembatas * 2 + wightboder),
                                      child: Text(
                                        ' ' +
                                            (data['ulasan'].containsKey(
                                                        'ulasan_klien') &&
                                                    data['ulasan']
                                                                ['ulasan_klien']
                                                            ['nama'] !=
                                                        null
                                                ? data['ulasan']['ulasan_klien']
                                                        ['nama']
                                                    .toString()
                                                : tanpaNama),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      Text(
                                        ' ' +
                                            (data['ulasan'].containsKey(
                                                        'ulasan_klien') &&
                                                    data['ulasan']
                                                                ['ulasan_klien']
                                                            ['bintang'] !=
                                                        null
                                                ? data['ulasan']['ulasan_klien']
                                                        ['bintang']
                                                    .toString()
                                                    .toString()
                                                : '0.0'),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //komen frelencer
                          Container(
                            width: widthSub - btnRight,
                            padding: EdgeInsets.only(
                              left: pembatas,
                              top: 33,
                              bottom: 5,
                            ),
                            margin: EdgeInsets.only(left: pembatas),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: wightboder,
                                    color: AppTheme.geySolidCustom),
                              ),
                            ),
                            child: Text(
                              ' ' +
                                  (data['ulasan'].containsKey('ulasan_klien') &&
                                          data['ulasan']['ulasan_klien']
                                                  ['deskripsi'] !=
                                              null
                                      ? data['ulasan']['ulasan_klien']
                                              ['deskripsi']
                                          .toString()
                                          .toString()
                                      : belumReview),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                      btnTool('assets/more_icon/edit-button.png',
                          BorderRadius.circular(30.0), 50, () {
                        komenOwner(context);
                      }),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget btnTool(String locationImg, BorderRadius radius, double width,
      Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: width,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            width: 1,
            color: AppTheme.nearlyBlack,
          ),
        ),
        child: Image.asset(
          locationImg,
          alignment: Alignment.center,
          // scale: 6,
        ),
      ),
    );
  }
}