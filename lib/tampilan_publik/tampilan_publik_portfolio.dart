import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';

class TampilanPublikPortfolio extends StatefulWidget {
  @override
  _TampilanPublikPortfolioState createState() => _TampilanPublikPortfolioState();

  const TampilanPublikPortfolio({
    Key key,
    this.id = 0,
  }) : super(key: key);

  final int id;
}

class _TampilanPublikPortfolioState extends State<TampilanPublikPortfolio> {
  String urlPhoto;
  String summary;
  String nameUser;
  Map jumlah = {};
  List dataPort = [];
  bool itsMe = true;
  bool loading = true;

  setDataPublik(Map data) {
    // print(data);
    setState(() {
      urlPhoto = data.containsKey('user') ? data['user']['foto'] : null;
      summary = data.containsKey('user') ? data['user']['summary'] : null;
      nameUser = data.containsKey('user') ? data['user']['nama'] : null;
      dataPort = data['portfolio'] ?? [];
      itsMe = data['its_me'] ?? false;
    });

    print(dataPort);
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.portfolio(widget.id==0?'':widget.id.toString()).then((v) {
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
                child:  dataPort.length > 0?ListView.builder(
                  itemCount: dataPort.length,
                  // itemExtent: 100.0,
                  itemBuilder: (c, i) =>
                       cardProyek(i, dataPort)
                   )   : Container(
                     alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            bottom: 50,
                          ),
                         
                          child: Text(
                            'Data Portfolio Kosong...',
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
                                      FontAwesomeIcons.solidStickyNote,
                                      color: AppTheme.geySolidCustom,
                                      size: 18,
                                    ),
                                    Text(
                                      ' Portfolio ' +
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

 Widget cardProyek(int i,data) {
   Map value=data[i];
    final sizeu = MediaQuery.of(context).size;

    return Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
          // border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.bgBlueSoft,
        ),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //gambar portfolio
                Container(
                  width: (sizeu.width - 70) / 2.5,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      value.containsKey('foto') && value['foto'] != null
                          ? CachedNetworkImage(
                              imageUrl: domainChange(value['foto']),
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) => SizedBox(
                                  width: 80,
                                  child: new CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            )
                          : Image.asset('assets/general/photo_holder.png'),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 25,
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        decoration: BoxDecoration(
                          color: AppTheme.bgChatBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          value['tahun'],
                          style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  // margin: EdgeInsets.only(top: 15),
                  width: (sizeu.width - 70) - (sizeu.width - 70) / 2.5,
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(value['judul'],
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppTheme.textBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(value['tautan'],
                              maxLines: 2,
                              style: TextStyle(
                                  color: AppTheme.geySolidCustom,
                                  fontSize: 12)),
                        ),
                        Text(value['deskripsi'],
                            textAlign: TextAlign.justify,
                            maxLines: 4,
                            style: TextStyle(
                                color: AppTheme.textBlue, fontSize: 12)),
                      ]),
                )
              ],
            ),
          ),
          //other option
 ]),
      );
      }

}
