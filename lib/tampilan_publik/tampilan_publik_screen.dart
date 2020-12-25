import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/helper/btn_option.dart';
import 'package:undangi/tampilan_publik/helper/modal_pilih_proyek.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_layanan.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_portfolio.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_profil.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_proyek.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_ulasan.dart';

class TampianPublikScreen extends StatefulWidget {
  @override
  _TampianPublikScreenState createState() => _TampianPublikScreenState();

  const TampianPublikScreen({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampianPublikScreenState extends State<TampianPublikScreen> {
  String urlPhoto;
  String summary;
  Map jumlah = {};
  bool itsMe = true;
  bool loading = true;
  List dataProyekAvail=[];

  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      jumlah = {
        'proyek': data['jumlah_proyek'],
        'layanan': data['jumlah_layanan'],
        'portfolio': data['jumlah_portfolio'],
        'ulasan': data['jumlah_ulasan'],
      };
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
      PublikModel.get(widget.id==0?'':widget.id.toString()).then((v) {
        setLoading(false);
        if (v.error) {
          errorRespon(context, v.data);
        } else {
        print(v.data);

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
                margin: EdgeInsets.only(
                  top: 40,
                ),
                child: ListView(
                  children: [
                    cardPublic(
                        bottom,
                        0,
                        getJumlah('proyek'),
                        'Proyek',
                        FaIcon(
                          FontAwesomeIcons.suitcase,
                          color: AppTheme.geyCustom,
                          size: 25,
                        ), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TampilanPublikProyek(
                                    id: widget.id,
                                  )));
                    }),
                    cardPublic(
                        bottom,
                        1,
                        getJumlah('layanan'),
                        'Layanan',
                        FaIcon(
                          FontAwesomeIcons.tools,
                          color: AppTheme.geyCustom,
                          size: 25,
                        ), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TampilanPublikLayanan(
                                    id: widget.id,
                                  )));
                    }),
                    cardPublic(
                        bottom,
                        2,
                        getJumlah('portfolio'),
                        'Portfolio',
                        FaIcon(
                          FontAwesomeIcons.solidStickyNote,
                          color: AppTheme.geyCustom,
                          size: 25,
                        ), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TampilanPublikPortfolio(
                                    id: widget.id,
                                  )));
                    }),
                    cardPublic(
                        bottom,
                        3,
                        getJumlah('ulasan'),
                        'Ulasan',
                        FaIcon(
                          FontAwesomeIcons.thumbsUp,
                          color: AppTheme.geyCustom,
                          size: 25,
                        ),
                        () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TampilanPublikUlasan(
                                    id: widget.id,
                                  )));
                        }),
                  ],
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
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              TampilanPublikProfil(
                            id: widget.id,
                          ),
                        ),
                      ),
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
                                      FontAwesomeIcons.fileAlt,
                                      color: AppTheme.geySolidCustom,
                                      size: 18,
                                    ),
                                    Text(
                                      ' Summary',
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

  Widget cardPublic(bottom, int indexWarna, int jmlh, String judul, FaIcon icon,
      Function linkToRoute) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    return Container(
      height: 90,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppTheme.renoReno[indexWarna],
          borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => linkToRoute(),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: 30,
            child: icon,
          ),
          Container(
            width: sizeu.width - 60 - 70,
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    pointGroup(jmlh) + ' $judul',
                    style: TextStyle(
                      color: AppTheme.textPink,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/home/circle_quatral.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: FaIcon(
              FontAwesomeIcons.play,
              color: AppTheme.textPink,
              size: 12,
            ),
          )
        ]),
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

  
}
