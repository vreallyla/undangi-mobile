import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';
import 'package:undangi/tampilan_publik/helper/btn_option.dart';


class TampilanPublikUlasan extends StatefulWidget {
  @override
  _TampilanPublikUlasanState createState() => _TampilanPublikUlasanState();

  const TampilanPublikUlasan({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikUlasanState extends State<TampilanPublikUlasan> {
  String urlPhoto;
  String summary;
  String nameUser;
  Map jumlah = {};
  List dataUlasan = [];
  bool itsMe = true;
  bool loading = true;

  List dataProyekAvail=[];


  setDataPublik(Map data) {
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      dataUlasan = data['ulasan'] ?? [];

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
      PublikModel.ulasan(widget.id == 0 ? '' : widget.id.toString()).then((v) {
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
                child: dataUlasan.length > 0
                    ? ListView.builder(
                        itemCount: dataUlasan.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) => cardProyek(i, dataUlasan))
                    : Container(
                        padding: EdgeInsets.only(
                          bottom: 50,
                        ),
                        child: Text(
                          'Data Ulasan Kosong...',
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
                                      FontAwesomeIcons.thumbsUp,
                                      color: AppTheme.geySolidCustom,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: sizeu.width-74,
                                      child:
                                    Text(
                                      ' Ulasan ' +
                                          (nameUser != null ? nameUser : ''),
                                      style: TextStyle(
                                          color: AppTheme.geySolidCustom,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
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

  Widget cardProyek(int i, data) {
    final sizeu = MediaQuery.of(context).size;
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

    Map value = data[i];
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.renoReno[z],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
           
            child: imageLoad(value['foto'], true, 60, 60),
          ),
          Container(
              width: sizeu.width - 141,
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
                        width: sizeu.width - 30 - 141-15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value['nama'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                    value['deskripsi'],
                    textAlign: TextAlign.justify,
                  )
                ],
              ))
        ],
      ),
    );
  }
}
