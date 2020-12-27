import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/frelencer/proyek_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/tab_menu/frelencer/proyek/pengerjaan_list_frelence_tab.dart';
import 'package:undangi/tab_menu/frelencer/proyek/proyek_list_frelence_tab.dart';
import 'package:undangi/tab_menu/frelencer/proyek/undangan_list_frelence_tab.dart';

class ProyekFrenlenceScreen extends StatefulWidget {
  @override
  _ProyekFrenlenceScreenState createState() => _ProyekFrenlenceScreenState();
}

class _ProyekFrenlenceScreenState extends State<ProyekFrenlenceScreen> {
  int tabChange = 0; //0=bid;1=undangan;2=pengerjaan

  //params
  int row = 12;
  int defaultAddRow = 12;
  String search;

  //refesh controller
  RefreshController _refreshProyekController = RefreshController();
  RefreshController _refreshUndanganController = RefreshController();
  RefreshController _refreshPengerjaanController = RefreshController();

  //loading indicator
  bool loadingProyek = true;
  bool loadingUndangan = true;
  bool loadingPengerjaan = true;
  int loadingPosisi = 3;
  bool stopLoad = false;

  TextEditingController searchController = new TextEditingController();

  // setData
  List dataProyek = [];
  List dataUndangan = [];
  List dataPengerjaan = [];
  int countProyek = 0;
  int countUndangan = 0;
  int countPengerjaan = 0;
  String fotoUrl;
  String status;

  void chageTab(int kond) {
    setState(() {
      row = defaultAddRow;
      tabChange = kond;
      loadingPosisi = tabChange;
    });
    _loadDataApi();
  }

  // op= 0: proyek;1:undangan;2:pengerjaan
  void setLoading(int op, bool kond) {
    setState(() {
      switch (op) {
        case 0:
          {
            loadingProyek = kond;
          }
          break;

        case 1:
          {
            loadingUndangan = kond;
          }
          break;

        case 2:
          {
            loadingPengerjaan = kond;
          }
          break;

        default:
          {
            loadingProyek = loadingUndangan = loadingPengerjaan = kond;
          }
          break;
      }
      // if (kond) {
      setState(() {
        loadingPosisi = op;
      });
      // }
    });
  }

  void setData(Map data) {
    setState(() {
      dataProyek = data['bid'] ?? [];
      dataUndangan = data['undangan'] ?? [];
      dataPengerjaan = data['pengerjaan'] ?? [];
      countProyek = data['bid_count'] ?? 0;
      countUndangan = data['undangan_count'] ?? 0;
      countPengerjaan = data['pengerjaan_count'] ?? 0;
      fotoUrl = data['user'] != null ? (data['user']['foto'] ?? null) : null;
      status = data['user'] != null
          ? (data['user']['status'] ?? 'kosong')
          : 'kosong';
    });
    print(dataPengerjaan);
  }

  // refresh user
  void _loadDataApi() async {
    if (!stopLoad) {
      GeneralModel.checCk(
          //connect
          () async {
        ProyekFrelencerModel.get({
          'q': searchController.text,
          'limit': row.toString(),
        }).then((v) {
          // print('p' + (loadingPosisi == 2 || !tabChange ? 0 : 1).toString());
          setLoading(
              loadingPosisi == 0 || loadingPosisi == 3 ? 0 : loadingPosisi,
              false);
          // print(loadingPosisi);
          if (loadingPosisi == 0) {
            _refreshProyekController.refreshCompleted();
          } else if (loadingPosisi == 1) {
            _refreshUndanganController.refreshCompleted();
          } else if (loadingPosisi == 2) {
            _refreshPengerjaanController.refreshCompleted();
          }

          if (v.error) {
            setState(() {
              stopLoad = true;
            });
            errorRespon(context, v.data);
          } else {
            setData(v.data);
          }
        });
      },
          //disconect
          () {
        setLoading(loadingPosisi == 0 || loadingPosisi == 3 ? 0 : loadingPosisi,
            false);
        if (loadingPosisi == 0) {
          _refreshProyekController.refreshCompleted();
        } else if (loadingPosisi == 1) {
          _refreshUndanganController.refreshCompleted();
        } else if (loadingPosisi == 2) {
          _refreshPengerjaanController.refreshCompleted();
        }

        openAlertBox(context, noticeTitle, notice, konfirm1, () {
          Navigator.pop(context, false);
        });
      });
    }
  }

  // refresh user
  void _nextDataApi() async {
    setState(() {
      row = row + defaultAddRow;
    });

    GeneralModel.checCk(
        //connect
        () async {
      ProyekFrelencerModel.get({
        'q': searchController.text,
        'limit': row.toString(),
      }).then((v) {
        setLoading(loadingPosisi == 0 || loadingPosisi == 3 ? 0 : loadingPosisi,
            false);
        // print(loadingPosisi);
        if (loadingPosisi == 0) {
          _refreshProyekController.loadComplete();
        } else if (loadingPosisi == 1) {
          _refreshUndanganController.loadComplete();
        } else if (loadingPosisi == 2) {
          _refreshPengerjaanController.loadComplete();
        }

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setData(v.data);
        }
      });
    },
        //disconect
        () {
      setLoading(
          loadingPosisi == 0 || loadingPosisi == 3 ? 0 : loadingPosisi, false);
      if (loadingPosisi == 0) {
        _refreshProyekController.loadComplete();
      } else if (loadingPosisi == 1) {
        _refreshUndanganController.loadComplete();
      } else if (loadingPosisi == 2) {
        _refreshPengerjaanController.loadComplete();
      }

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  }

  @override
  void initState() {
    setLoading(0, true);
    _loadDataApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double _width = sizeu.width;
    double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: appBarColloring(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // menu & photo
          appDashboard(
            context,
            fotoUrl,
            menuPublik(),
            menuLeft(),
          ),
          //motto
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            width: _width,
            child: Text(
              status ?? 'memuat...',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.geyCustom,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // tab,
          tabHead(),

          //tool
          Container(
              margin:
                  EdgeInsets.fromLTRB(marginLeftRight, 5, marginLeftRight, 0),
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
                        Navigator.pushNamed(context, '/proyek_list');
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
                              Text('' + 'TAMBAH',
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
                                  setLoading(tabChange, true);
                                  _loadDataApi();
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: '',
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 12.0, top: 0.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                              ),
                            ),
                            decoration: new BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppTheme.geyCustom),
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

          tabLoad(bottom)
        ]),
      ),
    );
  }

  Widget tabLoad(bottom) {
    switch (tabChange) {
      case 0:
        {
          return ProyekListFrelenceTab(
              bottomKey: double.parse(bottom.toString()),
              dataBid: dataProyek,
              reloadFunc: _loadDataApi,
              loading: loadingProyek,
              refreshFunc: () {
                setLoading(0, true);
                _loadDataApi();
              },
              refresh: _refreshProyekController,
              nextData: _nextDataApi);
        }
        break;

      case 1:
        {
          return UndanganListFrelenceTab(
            bottomKey: double.parse(bottom.toString()),
            dataBid: dataUndangan,
            reloadFunc: _loadDataApi,
            loading: loadingUndangan,
            refreshFunc: () {
              setLoading(1, true);
              _loadDataApi();
            },
            refresh: _refreshUndanganController,
            nextData: _nextDataApi,
          );
        }
        break;

      case 2:
        {
          return PengerjaanListFrelenceTab(
              bottomKey: double.parse(bottom.toString()),
              dataBid: dataPengerjaan,
              reloadFunc: _loadDataApi,
              loading: loadingPengerjaan,
              refresh: _refreshPengerjaanController,
              nextData: _nextDataApi);
        }
        break;

      default:
        {
          return dataKosong();
        }
        break;
    }
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
            // Navigator.pushNamed(context, '/ganti_password');
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
        Navigator.pop(context);
      },
      child: Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 18,
          ),
          child: Container(
            height: 40,
            width: 40,
            child: Image.asset('assets/tab_icons/tab_1s.png'),
          )),
    );
  }

  Widget tabHead() {
    final sizeu = MediaQuery.of(context).size;
    double sisaTab = sizeu.width - 70 - 126 - 140;
    double tabsisaBagi = sisaTab / 4;

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
          //tab bid

          InkWell(
            onTap: () {
              chageTab(0);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 70,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 70,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 0 ? 0.5 : 0,
                        color: tabChange == 0
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'BID',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(moreThan99(countProyek),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //undangan
          InkWell(
            onTap: () {
              chageTab(1);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 126,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 126,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 1 ? 0.5 : 0,
                        color: tabChange == 1
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'UNDANGAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(moreThan99(countUndangan),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //PENGERJAAN
          InkWell(
            onTap: () {
              chageTab(2);
            },
            child: Container(
              margin: EdgeInsets.only(left: tabsisaBagi),
              width: 140,
              alignment: Alignment.center,
              height: 30,
              child: Container(
                padding: EdgeInsets.only(bottom: 5),
                width: 140,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: tabChange == 2 ? 0.5 : 0,
                        color: tabChange == 2
                            ? AppTheme.geySolidCustom
                            : Colors.transparent),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 20,
                    ),
                    Text(
                      'PENGERJAAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(moreThan99(countPengerjaan),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
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
