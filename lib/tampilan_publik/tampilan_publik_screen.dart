import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/publik_mode.dart';

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
    });
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      setLoading(true);
      PublikModel.get().then((v) {
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

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
        appBar: appBarColloring(),
        body: loading
            ? onLoading2()
            : Stack(
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
                  appDashboard(
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
                      )),
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
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  ' lorem ipsum',
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
                        Container(
                          height: sizeu.height -
                              paddingPhone.top -
                              paddingPhone.bottom -
                              bottom -
                              298 +
                              5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.nearlyWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
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
                              ),
                              Container(
                                height: (sizeu.height -
                                        paddingPhone.top -
                                        paddingPhone.bottom -
                                        bottom -
                                        298 +
                                        5 -
                                        20 -
                                        55) /
                                    4,
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 10,
                                ),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: AppTheme.bgBlueSoft,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: FaIcon(
                                          FontAwesomeIcons.suitcase,
                                          color: AppTheme.geyCustom,
                                          size: 25,
                                        ),
                                      ),
                                      Container(
                                        width: sizeu.width-60-70,
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Proyek',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                '2 Layanan',
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
                                            image: AssetImage(
                                                'assets/home/circle_quatral.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: FaIcon(FontAwesomeIcons.play,color: AppTheme.textPink,size: 12,),
                                      )
                                      
                                    ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ));
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
                color: AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {},
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
            child: SizedBox(
              width: 135,
              child: RaisedButton(
                color: AppTheme.biruLaut,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {},
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
