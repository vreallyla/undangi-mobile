import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/search_box.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/Model/tab_model.dart';
import 'package:undangi/tab_menu/home/sub_menu/layanan_list/layanan_list_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/proyek_list/proyek_list_screen.dart';
// import 'package:flutter/scheduler.dart';

// import 'package:undangi/Constant/app_theme.dart';

class SearchTabScreen extends StatefulWidget {
  @override
  _SearchTabScreenState createState() => _SearchTabScreenState();
  const SearchTabScreen({
    Key key,
    this.opJenis,
    this.keyword,
    this.kategori,
  }) : super(key: key);

  final List kategori;
  final String opJenis;
  final String keyword;
}

class _SearchTabScreenState extends State<SearchTabScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController cariKategoriInput = new TextEditingController();
  String jenisOp;
  bool loading = false;
  List dataKategori = [];
  List chooseKategori = [];
  List<Widget> widgetKategori = <Widget>[];

  setLoading(bool kond) {
    setState(() {
      loading = kond;
    });
  }

  // params q for searh
  _kategoryAPi(String q) async {
    setLoading(true);

    GeneralModel.checCk(
        //connect
        () async {
      await TabModel.kategorySearch(q).then((v) {
        setLoading(false);

        if (v.error) {
          errorRespon(context, v.data);
        } else {
          setState(() {
            dataKategori = v.data['list'];
          });
          addAllData();
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

  void addAllData() {
    final sizeu = MediaQuery.of(context).size;
    double marginWidthCard = 20;

    //card
    double pembatasCard = 7;
    double widthCard = (sizeu.width - marginWidthCard - pembatasCard) / 2;

    widgetKategori = <Widget>[];
    int countRow = (dataKategori.length / 2).ceil();

    for (int i = 0; i < countRow; i++) {
      List<Widget> grid = <Widget>[];
      int start = i * 2;

      List.generate(2, (z) => z).forEach((z) {
        int index = start + z;
        int indexChoose = chooseKategori.indexOf(dataKategori[index]['id']);
        bool selOp = indexChoose >= 0;

        if (index < dataKategori.length) {
          grid.add(InkWell(
            onTap: () {
              if (selOp) {
                chooseKategori.removeAt(indexChoose);
              } else {
                if (chooseKategori.length < 4) {
                  chooseKategori.add(dataKategori[index]['id']);
                } else {
                  openAlertBox(context, 'Peringatan!',
                      "Maksimal pilihan 4 kategori...", 'OK', () {
                    Navigator.pop(context);
                  });
                }
              }
              setState(() {
                addAllData();
              });
            },
            child: Container(
              width: widthCard,
              margin: EdgeInsets.only(right: z == 0 ? pembatasCard : 0),
              padding: EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selOp ? AppTheme.bgChatBlue : AppTheme.geySolidCustom,
                  width: selOp ? 2 : 1,
                ),
                color: selOp ? Colors.grey.withOpacity(.1) : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: widthCard / 1.6,
                      height: widthCard / 1.6,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(dataKategori[index]['img']),
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                  Text(
                    dataKategori[index]['nama'],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ));
        }
      });
      widgetKategori.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child:
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: grid
                  //  [
                  //   //animasi
                  //  //bisnis

                  // ],
                  ),
        ),
      );
    }
    setState(() {});
  }

  void searhNow() {
    if (jenisOp == null) {
      openAlertBox(context, 'Harap pilih Proyek/Layanan',
          'Untuk melanjutkan pencarian...', konfirm1, () {
        Navigator.pop(context);
      });
    } else {
      print('redirect ' + jenisOp);
      if (jenisOp == 'Proyek') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProyekListScreen(
                kategori: chooseKategori,
                keyword: cariKategoriInput.text,
              ),
            ));
      } else {
        if (jenisOp == 'Layanan') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LayananListScreen(
                  kategori: chooseKategori,
                  keyword: cariKategoriInput.text,
                ),
              ));
        }
      }
    }
  }

  @override
  void initState() {
    setState(() {
      cariKategoriInput.text = widget.keyword ?? '';
      jenisOp = widget.opJenis ?? null;
      chooseKategori = widget.kategori ?? [];
    });
    _kategoryAPi(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    double defaultWidth = 411.42857142857144;
    double fontSearch = sizeu.width / defaultWidth * 12;

    double paddingWidthCard = 15;
    double marginWidthCard = 20;
    double pembatasSearch = 0;

    //search
    double widthSearhInput =
        (sizeu.width - marginWidthCard - paddingWidthCard) / 1.6;
    double widthKategoriSelect = sizeu.width -
        marginWidthCard -
        paddingWidthCard -
        widthSearhInput -
        pembatasSearch;

    //card

    return new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: appPolosBack(paddingPhone, () {
          Navigator.pop(context);
        }),
        body: loading
            ? onLoading2()
            : Stack(
                children: [
                  Container(
                    color: AppTheme.primaryBg,
                    margin: EdgeInsets.fromLTRB(
                        marginWidthCard / 2, 20, marginWidthCard / 2, 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        //search bar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearcBox(
                              iconWidth: 10,
                              fontSize: fontSearch,
                              controll: cariKategoriInput,
                              marginn: EdgeInsets.only(
                                  bottom: 20,
                                  left: paddingWidthCard / 2,
                                  right: paddingWidthCard / 2),
                              paddingg: EdgeInsets.only(left: 10, right: 10),
                              widthh: widthSearhInput,
                              heightt: 50,
                              widthText: widthSearhInput - 50,
                              textL: 45,
                              radiusBorder: 30,
                              placeholder: "Cari yang anda inginkan",
                              eventtChange: (v) {
                                print(v);
                                // v is value of textfield
                              },
                              eventtSubmit: (v) {
                                // v is value of textfield
                              },
                            ),
                            Container(
                              width: widthKategoriSelect,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              height: 50,
                              margin: EdgeInsets.only(left: pembatasSearch),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: jenisOp,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      jenisOp = newValue;
                                    });
                                  },
                                  hint: Text('Proyek/Layanan',
                                      style: TextStyle(
                                          color: AppTheme.textBlue,
                                          fontSize: fontSearch)),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  items: <String>[
                                    'Proyek',
                                    'Layanan',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              color: AppTheme.textBlue,
                                              fontSize: fontSearch)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: sizeu.height -
                              40 -
                              150 -
                              paddingPhone.top -
                              paddingPhone.bottom -
                              bottom,
                          width: double.infinity,
                          child: ListView(
                            children: widgetKategori,
                          ),
                        )
                      ],
                    ),
                  ),
                  chooseKategori.length > 0 ||
                          jenisOp != null ||
                          cariKategoriInput.text.length > 0
                      ? Container(
                          margin: EdgeInsets.only(
                              top: sizeu.height -
                                  150 -
                                  paddingPhone.top -
                                  paddingPhone.bottom -
                                  bottom,
                              left: sizeu.width - 80),
                          child: InkWell(
                            onTap: () {
                              searhNow();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppTheme.bgChatBlue,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              height: 60,
                              width: 60,
                              child: Icon(
                                Icons.search,
                                color: AppTheme.nearlyWhite,
                                size: 30,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        )
                ],
              ),
      ),
    );
  }
}
