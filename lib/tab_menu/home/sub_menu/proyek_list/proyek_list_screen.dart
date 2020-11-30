import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/tab_model.dart';
import 'package:undangi/tab_menu/search/search_tab_screen.dart';

class ProyekListScreen extends StatefulWidget {
  @override
  _ProyekListScreenState createState() => _ProyekListScreenState();

  const ProyekListScreen({
    Key key,
    this.keyword,
    this.kategori,
  }) : super(key: key);

  final List kategori;
  final String keyword;
}

class _ProyekListScreenState extends State<ProyekListScreen> {
  RefreshController _refreshController = RefreshController();
  TextEditingController cariProyekInput = new TextEditingController();
  bool loading = true;
  List kategori = [];
  List kategoriName = [];
  List<Widget> widgetKat = <Widget>[];

  void addWidgetKat(List kat) {
    widgetKat = <Widget>[];
    final sizeu = MediaQuery.of(context).size;
    int countRow = (kat.length / 2).ceil();
    countRow = countRow > 2 ? 2 : countRow;
    setState(() {
      kategoriName = kat;
    });

    for (int i = 0; i < countRow; i++) {
      List<Widget> grid = <Widget>[];
      int start = i * 2;

      List.generate(2, (z) => z).forEach((z) {
        int index = start + z;

        if (index < kat.length) {
          int removeIndex = kategori[index];

          grid.add(
            Container(
              width: (sizeu.width - 30) / 2,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              height: 30,
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: .5, color: AppTheme.geyCustom)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (sizeu.width - 30) / 2 - 16 - 20,
                    child: Text(
                      kat[index],
                      style: TextStyle(color: AppTheme.geyCustom),
                      maxLines: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        kategori.removeAt(kategori.indexOf(removeIndex));
                      });
                      print(kategori);
                      setLoading(true);
                      _getProyekApi();
                    },
                    child: FaIcon(FontAwesomeIcons.timesCircle,
                        size: 18, color: AppTheme.geyCustom),
                  ),
                ],
              ),
            ),
          );
        }
      });

      widgetKat.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grid,
      ));
    }
    setState(() {});
  }

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  //get proyek
  int setRow = 12;
  int perLoad = 12;

  List data = [];

  // params kategori and keyword from widget
  void _getProyekApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      Map res = {
        "limit": setRow,
        "q": widget.keyword,
        "kat": kategori,
      };
      await TabModel.proyekData(res, true).then((v) {
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          addWidgetKat(v.data['kategori']);
          setState(() {
            data = v.data['list'];
          });
          // print(data);
        }
        if (loading) {
          setLoading(false);
        } else {
          _refreshController.refreshCompleted();

          setState(() {});
        }
      });
    },
        //disconect
        () {
      if (loading) {
        setLoading(false);
      } else {
        _refreshController.refreshCompleted();
      }

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  // params kategori and keyword from widget
  void _getProyekApiLoad() async {
    int rowBefor = data.length;

    setState(() {
      setRow = setRow + perLoad;
    });
    // _refreshController.requestLoading();

    GeneralModel.checCk(
        //connect
        () async {
      Map res = {
        "limit": setRow,
        "q": widget.keyword,
        "kat": kategori,
      };
      await TabModel.proyekData(res, true).then((v) {
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            data = v.data['list'];
          });
          // print(data);
        }
        if (rowBefor < data.length) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }

        print(data.length);

        setState(() {});
      });
    },
        //disconect
        () {
      _refreshController.loadNoData();

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  @override
  void initState() {
    setState(() {
      kategori = widget.kategori ?? [];
      cariProyekInput.text = widget.keyword;
    });
    _getProyekApi();
    super.initState();
  }

  Widget cardProyek(int i) {
    final sizeu = MediaQuery.of(context).size;
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
    // double widthIcoKonten = defaultWidthKonten / 12;

    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: marginWidthCard / 2,
        right: marginWidthCard / 2,
      ),
      padding: EdgeInsets.fromLTRB(
          paddingWidthCard / 2, 15, paddingWidthCard / 2, 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: !i.isOdd ? AppTheme.cardBlue : AppTheme.cardWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    image:
                        (AssetImage('assets/general/ilustration_desain.jpg')),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Bid:',
                                style: TextStyle(
                                  color: AppTheme.geySolidCustom,
                                  fontSize: textSubKonten + 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                moreThan99(data[i]['jumlah_bid']) + ' ORANG',
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontSize: textSubKonten + 3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //durasi
                        SizedBox(
                          width: widthKonten - (widthKonten / 2.3),
                          child: Row(
                            children: [
                              Container(
                                width: textSubKonten + 8,
                                height: textSubKonten + 8,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: (AssetImage(
                                        'assets/more_icon/calender.png')),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '  Batas Waktu: ',
                                    style: TextStyle(
                                      color: AppTheme.geySolidCustom,
                                      fontSize: textSubKonten + 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '  ${pointGroup(int.parse(data[i]['waktu_pengerjaan'].toString()))} HARI',
                                    style: TextStyle(
                                      color: AppTheme.primaryBlue,
                                      fontSize: textSubKonten + 3,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //harga
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                      child: Text(
                        'Rp' + decimalPointTwo(data[i]['harga']),
                        style: TextStyle(
                          color: AppTheme.geySolidCustom,
                          fontSize: textHargaKonten,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // sub kategori
                    Text(
                      'Kategori ${data[i]['kategori_nama']}:',
                      style: TextStyle(
                        color: AppTheme.geySolidCustom,
                        fontSize: textSubKonten + 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // sub kategori detail

                    Text(
                      data[i]['subkategori_nama'],
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: textSubKonten + 2.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              //kategori
              Container(
                width: widthKategori,
                padding: EdgeInsets.only(top: imgWidth / 5),
                // height: 40,
                child: Text(
                  data[i]['judul'].toUpperCase(),
                  style: TextStyle(
                    fontSize: textKategori,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
            ],
          ),
          //keterangan
          Container(
            margin: EdgeInsets.only(left: imgWidth + marginPemisah),
            // padding: const EdgeInsets.only(top: 15),
            height: textKeteranganKonten * 3,
            alignment: Alignment.bottomLeft,

            width: double.infinity,
            child: Text(
              data[i]['deskripsi'],
              style: TextStyle(
                color: AppTheme.geySolidCustom,
                fontSize: textKeteranganKonten,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;

    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    double marginWidthCard = 20;

    return Scaffold(
      appBar: appPolosBack(paddingPhone, () {
        Navigator.pop(context);
      }),
      body: loading
          ? onLoading2()
          : Container(
              color: AppTheme.primaryBg,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //search bar
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchTabScreen(
                              kategori: kategori,
                              keyword: widget.keyword ?? '',
                              opJenis: 'Proyek',
                            ),
                          ));
                    },
                    child: IgnorePointer(
                      child: SearcBox(
                        controll: cariProyekInput,
                        marginn: EdgeInsets.only(
                            bottom: kategoriName.length > 0 ? 2.5 : 20,
                            left: 20,
                            right: 20),
                        paddingg: EdgeInsets.only(left: 15, right: 15),
                        widthh: sizeu.width - 40 - 20,
                        heightt: 50,
                        widthText: sizeu.width - 60 - 30 - 30,
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
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    height: kategoriName.length > 0
                        ? (kategoriName.length > 2 ? 80 : 40)
                        : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widgetKat,
                    ),
                  ),
                  Container(
                      height: sizeu.height -
                          185 -
                          (kategoriName.length > 0
                              ? (kategoriName.length > 2 ? 80 : 40)
                              : 20) -
                          bottom +
                          20 -
                          paddingPhone.top -
                          paddingPhone.bottom,
                      width: double.infinity,
                      child: SmartRefresher(
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
                              "AllDataLoaded",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 22),
                            ),
                          ),
                          baseColor: AppTheme.bgChatBlue,
                        ),
                        controller: _refreshController,
                        enablePullUp: true,
                        child: ListView.builder(
                          itemCount: data.length,
                          // itemExtent: 100.0,
                          itemBuilder: (c, i) => data.length > 0
                              ? cardProyek(i)
                              : Container(
                                  padding: EdgeInsets.only(
                                    bottom: 50,
                                  ),
                                  height: 200,
                                  child: Text(
                                    'Data Kosong...',
                                    style: TextStyle(
                                        // color: Colors.grey,
                                        fontSize: 22),
                                  ),
                                ),
                        ),
                        onRefresh: _getProyekApi,
                        onLoading: _getProyekApiLoad,
                      ))
                ],
              ),
            ),
    );
  }
}
