import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/helper/btn_option.dart';

import 'package:undangi/tampilan_publik/tampilan_publik_proyek_detail.dart';

class TampilanPublikProyek extends StatefulWidget {
  @override
  _TampilanPublikProyekState createState() => _TampilanPublikProyekState();

  const TampilanPublikProyek({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikProyekState extends State<TampilanPublikProyek> {
  String urlPhoto;
  String summary;
  String nameUser;
  Map jumlah = {};
  List dataProyek = [];
  bool itsMe = true;
  bool loading = true;
  List dataProyekAvail = [];

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      dataProyek = data['proyek'] ?? [];

      itsMe = data['its_me'] ?? false;
      dataProyekAvail = data['proyek_tersedia'] ?? [];
    });
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.proyek(widget.id == 0 ? '' : widget.id.toString()).then((v) {
        setLoading(false);
        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataPublik(v.data);
        }
      });
    },
        //disconect
        () {
      setLoading(false);
      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  @override
  void initState() {
    _loadDataApi();
    // TODO: implement initState
    super.initState();
  }

  getJumlah(String nama) {
    return jumlah.containsKey(nama) ? (jumlah[nama] ?? 0) : 0;
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: appBarColloring(),
      body: loading
          ? onLoading2()
          : SlidingUpPanel(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(60),
                topLeft: Radius.circular(60),
              ),
              minHeight: 40,
              maxHeight: sizeu.height -
                  paddingPhone.top -
                  paddingPhone.bottom -
                  bottom -
                  298 +
                  5,
              defaultPanelState: PanelState.OPEN,
              header: Container(width: sizeu.width, child: slideSign()),
              panel: Container(
                height: sizeu.height -
                    paddingPhone.top -
                    paddingPhone.bottom -
                    bottom -
                    298 +
                    5,
                margin: EdgeInsets.only(
                  top: 40,
                ),
                child: dataProyek.length > 0
                    ? ListView.builder(
                        itemCount: dataProyek.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) => cardProyek(i, dataProyek))
                    : Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          bottom: 50,
                        ),
                        child: Text(
                          'Data Proyek Kosong...',
                          style: TextStyle(
                              // color: Colors.grey,
                              fontSize: 22),
                        ),
                      ),
              ),
              body: Center(
                child: Stack(
                  children: [
                    // BG
                    Container(
                      height: sizeu.height,
                      width: sizeu.width,
                      decoration: BoxDecoration(
                        color: AppTheme.bgChatBlue,
                        image: DecorationImage(
                          image: AssetImage('assets/general/abstract_bg.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    appDashboardLinkPhoto(
                      context,
                      urlPhoto,
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
                      ),
                      () => Navigator.pushNamed(context, '/publik_profil'),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: sizeu.height - 30),
                      color: AppTheme.nearlyWhite,
                      width: double.infinity,
                      height: 40,
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              BtnOption(
                            bottom:bottom,
                            dataProyekAvail: dataProyekAvail,
                            id:widget.id,
                            itsMe: itsMe,
                            loadAgain:(){
                              _loadDataApi();
                            }
                          ),

                          //summary
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            height: 120,
                            decoration: BoxDecoration(
                                color: AppTheme.bgGreenBlueSoft,
                                borderRadius: BorderRadius.circular(10)),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.suitcase,
                                      color: AppTheme.geySolidCustom,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: sizeu.width-74,
                                      child: Text(
                                      ' Proyek ' +
                                          (nameUser != null ? nameUser : ''),
                                      style: TextStyle(
                                          color: AppTheme.geySolidCustom,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    summary ?? 'masih belum diisi...',
                                    maxLines: 4,
                                    style: TextStyle(
                                        color: AppTheme.geySolidCustom,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
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
              ),
            ),
    );
  }

  Widget slideSign() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 17),
        width: 120,
        height: 8,
        decoration: BoxDecoration(
          color: AppTheme.geySofttCustom,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget cardProyek(int i, data) {
    final sizeu = MediaQuery.of(context).size;
    double paddingWidthCard = 15;
    double marginWidthCard = 30;

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

    int z = i + 1;
    if (z % 1 == 0) {
      z = 0;
    }
    if (i % 2 == 0) {
      z = 1;
    }
    if (i % 3 == 0) {
      z = 2;
    }
    if (i % 4 == 0) {
      z = 3;
    }

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
        color: AppTheme.renoReno[z],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TampilanPublikProyekDetail(
              id: data[i]['id'],
            ),
          ),
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
                                  moreThan99(parseInt(data[i]['total_bid'])) + ' ORANG',
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
                        'Kategori ${(data[i]['kategori'] != null ? data[i]['kategori']['nama'] : '-')}:',
                        style: TextStyle(
                          color: AppTheme.geySolidCustom,
                          fontSize: textSubKonten + 2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // sub kategori detail

                      Text(
                        data[i]['subkategori'] != null
                            ? data[i]['subkategori']['nama']
                            : '-',
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
      ),
    );
  }
}
