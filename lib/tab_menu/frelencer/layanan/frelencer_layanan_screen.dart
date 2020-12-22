import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Model/frelencer/layanan_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/owner/proyek_owner_model.dart';

import 'tab_layanan_pengerjaan_view.dart';
import 'tab_layanan_view.dart';

class FrelencerLayananScreen extends StatefulWidget {
  @override
  _FrelencerLayananScreenState createState() => _FrelencerLayananScreenState();
}

class _FrelencerLayananScreenState extends State<FrelencerLayananScreen> {
  bool tabChange = false; //false=proyek;true=pengerjaan

  //ganti konten tab pengerjaan ke progress ketika ditekan button progress
  bool toProgress = false;

  //ganti konten tab proyek ke tambah proyek
  bool toAdd = false;

  //var load handle
  bool loadingProyek = false;
  bool loadingPengerjaan = false;
  int loadingPosisi = 2;

  //params get
  int getRowProyek = 20;
  int getRowPengerjaan = 20;
  String searchProyek;
  String searchPengerjaan;

  int plusRowPengerjaan = 20;
  int plusRowProyek = 20;

  //EDIT ID TRIGGER
  int editId = 0;

  String urlPoto;
  String motto;
  Map dataBio = {};
  List dataLayanan = [];
  List dataPengerjaan = [];
  int jmlhLayanan = 0;
  int jmlhPengerjaan = 0;

  //refesh controller
  RefreshController _refreshProyekController = RefreshController();
  RefreshController _refreshPengerjaanController = RefreshController();

  TextEditingController searchController = TextEditingController();

  TextEditingController judulController = new TextEditingController();
  List<File> lampiran = <File>[];

  TextEditingController thumbController = new TextEditingController();
  TextEditingController lampiranController = new TextEditingController();

  TextEditingController waktuController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();

  TextEditingController deskripsiController = new TextEditingController();

  Map kategoriSelect = {
    "id": '',
    "nama": '',
  };

  File _image;
  String jnsProyek = 'publik';

  resetFormProyek() {
    setState(() {
      jnsProyek = 'publik';
      _image = null;
      kategoriSelect = {
        "id": '',
        "nama": '',
      };
      judulController = new TextEditingController();
      thumbController = new TextEditingController();
      lampiranController = new TextEditingController();
      waktuController = new TextEditingController();
      hargaController = new TextEditingController();
      deskripsiController = new TextEditingController();
      lampiran = <File>[];
    });
  }

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
  setDataLayanan(Map data) {
    setState(() {
      dataLayanan = data.containsKey('layanan') ? data['layanan'] : [];
      dataPengerjaan = data.containsKey('pengerjaan') ? data['pengerjaan'] : [];
      jmlhPengerjaan =
          data.containsKey('count_pengerjaan') ? data['count_pengerjaan'] : 0;
      jmlhLayanan =
          data.containsKey('count_layanan') ? data['count_layanan'] : 0;
      urlPoto = data.containsKey('bio') ? data['bio']['foto'] : null;
      motto = data.containsKey('bio') ? data['bio']['status'] : null;
      dataBio = data.containsKey('bio') ? (data['bio'] ?? {}) : {};
    // print(dataBio);
    });
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
      LayananFrelencerModel.get({
        'limit': getRowProyek,
        'q': searchProyek,
      }).then((v) {
        setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
        print(loadingPosisi);
        if (loadingPosisi == 0) {
          _refreshProyekController.refreshCompleted();
        } else if (loadingPosisi == 1) {
          _refreshPengerjaanController.refreshCompleted();
        }

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataLayanan(v.data);
          //disconect
        }
      });
    }, () {
      setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
      if (loadingPosisi == 0) {
        _refreshProyekController.refreshCompleted();
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
      LayananFrelencerModel.get({
       'limit': getRowProyek,
        'q': searchProyek,
      }).then((v) {
        setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
        print(loadingPosisi);
        if (loadingPosisi == 0) {
          _refreshProyekController.loadComplete();
        } else if (loadingPosisi == 1) {
          _refreshPengerjaanController.loadComplete();
        }

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setDataLayanan(v.data);
        }
      });
    },
        //disconect
        () {
      setLoading(loadingPosisi == 2 || !tabChange ? 0 : 1, false);
      if (loadingPosisi == 0) {
        _refreshProyekController.loadComplete();
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
    setLoading(2, true);
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
                    maxLines: 2,
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
              tabHead(),

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
                              resetFormProyek();
                            }
                            setState(() {
                              toAdd = true;
                              tabChange = false;
                            });
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
                              SizedBox(
                                height: 25,
                                width: 140,
                                child: TextField(
                                  enabled: !toAdd,
                                  controller: searchController,
                                  onSubmitted: (v) {
                                    setState(() {
                                      searchProyek = searchPengerjaan = v;
                                    });
                                    _loadDataApi();
                                  },
                                  style: TextStyle(

                                      //Font color change
                                      fontSize: 11),
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    fillColor: Colors.white,

                                    hintText: '',
                                    suffixStyle: TextStyle(color: Colors.black),
                                    isDense: true, // Added this
                                    contentPadding: EdgeInsets.only(
                                        top: 12,
                                        left: 9,
                                        right: 6), // Added this

                                    counterText: "",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),

              //tab proyek
              tabChange
                  ? TabLayananPengerjaanView(
                      dataReresh: _loadDataApi,
                      dataNext: _nextDataApi,
                      refresh: _refreshPengerjaanController,
                      bottomKey: double.parse(bottom.toString()),
                      loading: loadingPengerjaan,
                      bio:dataBio,
                      dataPengerjaan: dataPengerjaan,
                      paddingTop: paddingPhone.top,
                      paddingBottom: paddingPhone.bottom,
                      toProgress: toProgress,
                      toProgressFunc: () {
                        setState(() {
                          toProgress = !toProgress;
                        });
                      })
                  : TabLayananView(
                      judulController: judulController,
                      lampiran: lampiran,
                      thumbController: thumbController,
                      lampiranController: lampiranController,
                      waktuController: waktuController,
                      hargaController: hargaController,
                      deskripsiController: deskripsiController,
                      kategoriSelect: kategoriSelect,
                      image: _image,
                      jnsProyek: jnsProyek,
                      valueEdit: (Map dt) {
                        print(dt);
                        setState(() {
                          kategoriSelect = dt['subkategori'];
                          judulController.text = dt['judul'];
                          deskripsiController.text = dt['deskripsi'];
                          hargaController.text = dt['harga'].toString();
                          waktuController.text = dt['hari_pengerjaan'].toString();
                          // jnsProyek = dt['jenis'];
                          thumbController.text = dt['thumbnail'] != null
                              ? dt['thumbnail'].split('/').last
                              : '';
                        });
                        print(dt);
                      },

                      //change value
                      changeKategori: (Map v) {
                        setState(() {
                          kategoriSelect = v;
                        });
                      },
                      changeImg: (File v) {
                        setState(() {
                          _image = v;
                        });
                      },
                      reloadGetApi: () {
                        setLoading(0, true);
                        _loadDataApi();
                      },
                      changeThumb: (String v) {
                        setState(() {
                          thumbController.text = v;
                        });
                      },
                      changeLampiran: (List<File> v) {
                        print(v);
                        setState(() {
                          lampiran = v;
                        });
                      },
                      changeLampiranText: (String v) {
                        setState(() {
                          lampiranController.text = v;
                        });
                      },
                      changeJenis: (String v) {
                        setState(() {
                          jnsProyek = v;
                        });
                      },
                      dataReresh: _loadDataApi,
                      dataNext: _nextDataApi,
                      refresh: _refreshProyekController,
                      dataLayanan: dataLayanan,
                      loading: loadingProyek,
                      bottomKey: double.parse(bottom.toString()),
                      paddingTop: paddingPhone.top,
                      paddingBottom: paddingPhone.bottom,
                      toAdd: toAdd,
                      editId: editId,
                      editEvent: (int id) {
                        resetFormProyek();
                        editId = id;
                        setState(() {});
                      },
                      toAddFunc: () {
                        setState(() {
                          toAdd = !toAdd;
                        });
                      }),
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
      editId = 0;
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
                      child: Text(moreThan99(jmlhLayanan),
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
