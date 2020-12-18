import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';

class TampilanPublikLayanan extends StatefulWidget {
  @override
  _TampilanPublikLayananState createState() => _TampilanPublikLayananState();

  const TampilanPublikLayanan({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikLayananState extends State<TampilanPublikLayanan> {
  String urlPhoto;
  String summary;
  String nameUser;
  Map jumlah = {};
  List dataLayanan = [];
  bool itsMe = true;
  bool loading = true;

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      dataLayanan = data['layanan'] ?? [];

      itsMe = data['its_me'] ?? false;
    });
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.layanan(widget.id==0?'':widget.id.toString()).then((v) {
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
                child: dataLayanan.length > 0
                    ? ListView.builder(
                        itemCount: dataLayanan.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) => cardProyek(i, dataLayanan))
                    : Container(
                        padding: EdgeInsets.only(
                          bottom: 50,
                        ),
                        child: Text(
                          'Data Layanan Kosong...',
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
                          btnOp(),

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
                                      FontAwesomeIcons.tools,
                                      color: AppTheme.geySolidCustom,
                                      size: 18,
                                    ),
                                    Text(
                                      ' Layanan ' +
                                          (nameUser != null ? nameUser : ''),
                                      style: TextStyle(
                                          color: AppTheme.geySolidCustom,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
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

  Widget btnOp() {
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
                color: itsMe ? Colors.grey[400] : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!itsMe) {
                    //jika undang
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
                color: itsMe ? Colors.grey[400] : AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {
                  if (!itsMe) {
                    //jika undang
                  } else {
                    openAlertBox(context, 'Pemberitahuan!',
                        'Tidak bisa memilih akun anda sendiri!', 'OK', () {
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
                                'Total Klien:',
                                style: TextStyle(
                                  color: AppTheme.geySolidCustom,
                                  fontSize: textSubKonten + 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                moreThan99(data[i]['jumlah_klien']) + ' ORANG',
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
                                    '  ${pointGroup(int.parse(data[i]['hari_pengerjaan'].toString()))} HARI',
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
                      (data[i]['subkategori'] != null
                          ? data[i]['subkategori']['nama']
                          : '-'),
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
}
