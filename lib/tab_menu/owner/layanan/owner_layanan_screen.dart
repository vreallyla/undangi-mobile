import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/layanan_owner_model.dart';
import 'package:undangi/Model/owner/proyek_owner_model.dart';

import 'tab_layanan_pengerjaan_view.dart';
import 'tab_layanan_view.dart';

class OwnerLayananScreen extends StatefulWidget {
  @override
  _OwnerLayananScreenState createState() => _OwnerLayananScreenState();
}

class _OwnerLayananScreenState extends State<OwnerLayananScreen> {
  bool tabChange = true; //false=proyek;true=pengerjaan

  //ganti konten tab pengerjaan ke progress ketika ditekan button progress
  bool toProgress = false;

  //ganti konten tab proyek ke tambah proyek
  bool toAdd = false;

  //var load handle
  bool loadingProyek = false;
  bool loadingPengerjaan = false;
  int loadingPosisi = 1;

  //params get
  int getRowProyek = 20;
  int getRowPengerjaan = 20;
  String searchProyek;
  String searchPengerjaan;

  int plusRowPengerjaan = 20;
  int plusRowProyek = 20;

  String urlPoto;
  int idUser;
  String motto;
  List dataProyek = [];
  List dataPengerjaan = [];
  int jmlhProyek = 0;
  int jmlhPengerjaan = 0;

  //refesh controller
  // RefreshController _refreshProyekController = RefreshController();
  RefreshController _refreshPengerjaanController = RefreshController();

  TextEditingController searchController = TextEditingController();

 
  //0=proyek;1=pengerjaan;2=dua2nya
  void setLoading(int order, bool kond) {
    // order = kond ? order : loadingPosisi;

    setState(() {
      if (order == 0) {
        loadingProyek = kond;
      } else if (order == 1) {
        loadingPengerjaan = kond;
      } else {
        loadingProyek = loadingPengerjaan = kond;
      }
      loadingPosisi = order;
    });
  }

  //set data proyek & pengerjaan
  setDataProyek(Map data) {
    setState(() {
     
      dataPengerjaan = data.containsKey('pengerjaan') ? data['pengerjaan'] : [];
      jmlhPengerjaan =
          data.containsKey('count_pengerjaan') ? data['count_pengerjaan'] : 0;
      urlPoto = data['bio']!=null ? data['bio']['foto'] : null;
      motto = data['bio']!=null ? data['bio']['status'] : null;
      idUser = data['bio']!=null ? data['bio']['id'] : null;
      
    });

    print(dataPengerjaan);
  }

  void chageTab(bool kond) {
    setState(() {
      tabChange = kond;
      setLoading(!tabChange ? 0 : 1, true);
      _loadDataApi();
    });
  }

  // refresh user
  void _loadDataApi() async {
    GeneralModel.checCk(
        //connect
        () async {
      LayananOwnerModel.get({
        //limit remove
        // 'limit_proyek': getRowProyek,
        'q': searchController.text,
      }).then((v) {
     
        setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
        
        if (loadingPosisi == 0) {
          // _refreshProyekController.refreshCompleted();
        } else if (loadingPosisi == 1) {
          _refreshPengerjaanController.refreshCompleted();
        }

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataProyek(v.data);
        //disconect
        }
      });
    },
        () {
      setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
      if (loadingPosisi == 0) {
        // _refreshProyekController.refreshCompleted();
      } else if (loadingPosisi == 1) {
        _refreshPengerjaanController.refreshCompleted();
      }

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  // refresh user
  void _nextDataApi() async {
    setState(() {
      if (loadingPosisi == 0) {
        getRowProyek = getRowProyek + plusRowProyek;
      } else if (loadingPosisi == 1) {
        getRowPengerjaan = getRowPengerjaan + plusRowPengerjaan;
      }
    });

    GeneralModel.checCk(
        //connect
        () async {
      LayananOwnerModel.get({
        // 'limit_proyek': getRowProyek,
        // 'search_proyek': searchProyek,
        // 'limit_pengerjaan': getRowPengerjaan,
        // 'search_pengerjaan': searchPengerjaan,
         'q': searchController.text,
      }).then((v) {
        setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
        print(loadingPosisi);
        if (loadingPosisi == 0) {
          // _refreshProyekController.loadComplete();
        } else if (loadingPosisi == 1) {
          _refreshPengerjaanController.loadComplete();
        }

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataProyek(v.data);
        }
      });
    },
        //disconect
        () {
      setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
      if (loadingPosisi == 0) {
        // _refreshProyekController.loadComplete();
      } else if (loadingPosisi == 1) {
        _refreshPengerjaanController.loadComplete();
      }

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  @override
  void initState() {
    setLoading(1, true);
    _loadDataApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    // double _width = sizeu.width;
    // double _height = sizeu.height;
    // final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final paddingPhone = MediaQuery.of(context).padding;

    return new WillPopScope(
      onWillPop: () {
        backHomeOrbackStay();
      },
      child: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: appBarColloring(),
          body: Container(
              child: Column(
            children: [
              // menu & photo
              appDashboard(
                context,
                urlPoto,
                condTransform() ? Text('') : menuPublik(),
                menuLeft(),
              ),
              //motto
              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: SizedBox(
                  // width: sizeu.width - 50 - 40,
                  child: Text(
                    motto ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.geyCustom,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              // tab,
              // tabHead(),

              //tool
              Container(
                  margin: EdgeInsets.fromLTRB(
                      marginLeftRight, 5, marginLeftRight, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.bgBlueSoft,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            if (!toAdd) {
                              //TODO REDIRECT TO LAYANAN
                              Navigator.pushNamed(context, '/layanan_list');
                            }
                           
                          },
                          child: Container(
                              width: 100,
                              height: 30,
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  width: .5,
                                  color: AppTheme.nearlyBlack,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.plusCircle,
                                    size: 16,
                                    color: AppTheme.geySolidCustom,
                                  ),
                                  Text(' ' + 'TAMBAH',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.geySolidCustom,
                                      )),
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          width: sizeu.width,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Cari : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.geySolidCustom,
                                ),
                              ),
                            Container(
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(splashColor: Colors.transparent),
                              child: TextField(
                                autofocus: false,
                                style: TextStyle(fontSize: 15.0),
                                controller: searchController,
                                onSubmitted: (v) {
                                   
                                       setState(() {
                                      searchProyek = searchPengerjaan = v;
                                    });
                                    setLoading(1,true);
                                    _loadDataApi();
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: '',
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 12.0, top: 0.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                            ),
                            decoration: new BoxDecoration(
                              border:Border.all(width:1,color:AppTheme.geyCustom),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(30.0)),
                                color: Colors.transparent),
                            width: 140,
                            height: 30,
                          ),
                        
                            ],
                          ),
                        ),
                      )
                    ],
                  )),

              //tab proyek
              TabLayananPengerjaanView(
                      dataReresh: _loadDataApi,
                      dataNext: _nextDataApi,
                      refresh: _refreshPengerjaanController,
                      bottomKey: double.parse(bottom.toString()),
                      loading: loadingPengerjaan,
                      dataPengerjaan: dataPengerjaan,
                      paddingTop: paddingPhone.top,
                      paddingBottom: paddingPhone.bottom,
                      toProgress: toProgress,
                      loadAgain:(){
                        setLoading(1, true);
                        _loadDataApi();
                      },
                      toProgressFunc: () {
                        setState(() {
                          toProgress = !toProgress;
                        });
                      })
            ],
          )),
        ),
      ),
    );
  }

  Widget menuPublik() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        left: sizeu.width - 15 - 45 - 80,
      ),
      child: PopupMenuButton(
        child: Container(
          width: 45,
          height: 45,
          margin: EdgeInsets.fromLTRB(80, 15, 15, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.primarymenu,
          ),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
        onSelected: (newValue) {
          if (newValue == 0) {
            Navigator.pushNamed(context, '/publik');
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Tampilan Publik"),
            value: 0,
          ),
        ],
      ),
    );
  }

  Widget menuLeft() {
    return InkWell(
      onTap: () {
        backHomeOrbackStay();
      },
      child: Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 18,
          ),
          child: Container(
            height: 40,
            width: 40,
            child: condTransform()
                ? Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.nearlyWhite,
                    size: AppTheme.sizeIconMenu,
                  )
                : Image.asset('assets/tab_icons/tab_1s.png'),
          )),
    );
  }

  backHomeOrbackStay() {
    //pengerjaan
    if (tabChange && toProgress) {
      toProgress = !toProgress;
    }

    ///proyek
    else if (!tabChange && toAdd) {
      toAdd = !toAdd;
 
    } else {
      Navigator.pop(context);
    }
    setState(() {});
  }

  condTransform() {
    return (tabChange && toProgress) || (!tabChange && toAdd);
  }

  Widget tabHead() {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
          bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
        ),
      ),
      child: Row(
        children: [
          //tab proyek
          InkWell(
            onTap: () {
              chageTab(false);
            },
            child: Container(
              width: sizeu.width / 2,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 140,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: !tabChange ? 0.5 : 0,
                        color: !tabChange
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 22,
                    ),
                    Text(
                      'LAYANAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(moreThan99(jmlhProyek),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // tab pengerjaan
          InkWell(
            onTap: () {
              chageTab(true);
            },
            child: Container(
              width: sizeu.width / 2,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 171,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange ? 0.5 : 0,
                        color: tabChange
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.briefcase,
                      size: 18,
                    ),
                    Text(
                      'PENGERJAAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 27,
                      width: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(moreThan99(jmlhPengerjaan),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
