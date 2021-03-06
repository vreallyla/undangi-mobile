import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';
import 'package:undangi/Model/frelencer/proyek_frelencer_model.dart';
import 'package:undangi/Model/general_model.dart';
import 'package:undangi/tampilan_publik/tampilan_publik_proyek_detail.dart';

class ProyekListFrelenceTab extends StatefulWidget {
  const ProyekListFrelenceTab({
    Key key,
    this.bottomKey = 0,
    this.reloadFunc,
    this.nextData,
    this.dataBid,
    this.loading,
    this.refresh,
    this.refreshFunc,
  }) : super(key: key);

  final double bottomKey;
  final bool loading;
  final List dataBid;

  final RefreshController refresh;

  final Function() refreshFunc;
  final Function() reloadFunc;
  final Function() nextData;
  @override
  _ProyekListFrelenceTabState createState() => _ProyekListFrelenceTabState();
}

class _ProyekListFrelenceTabState extends State<ProyekListFrelenceTab> {
  TextEditingController inputKategori = new TextEditingController();
  TextEditingController inputJudul = new TextEditingController();

   _deleteBid(String id) async {

   

    GeneralModel.checCk(
        //connect
        () async {
          onLoading(context);
    
      ProyekFrelencerModel.deleteBid(id)
          .then((v) {
        Navigator.pop(context);

        if (v.error) {
        
            errorRespon(context, v.data);
          
        } else {
           widget.refreshFunc();
        }
      });
    },
        //disconect
        () {
      Navigator.pop(context);

      openAlertBox(context, noticeTitle, notice, konfirm1, () {
        Navigator.pop(context, false);
      });
    });
  
  }


  String jnsProyek = 'publik';
  @override
  Widget build(BuildContext context) {
    double marginLeftRight = 10;
    double marginCard = 5;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 5;

    return proyekList((id) {});
  }

  Widget proyekList(Function(int id) editEvent) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);
    double imgCard = widthCard / 6;
    double heightCard = 110;
    double widthBtnShort = 85;
    double widthBtnPlay = 40;
    double widthKonten = widthCard - imgCard - widthBtnShort - 2;
    return Container(
        margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
        padding: EdgeInsets.all(marginCard),
        alignment: Alignment.topLeft,
        height: sizeu.height - 360 - widget.bottomKey,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: .5,
            color: Colors.black,
          ),
        ),
        child: widget.loading
            ? onLoading2()
            : (widget.dataBid.length == 0
                ? dataKosong()
                : SmartRefresher(
                    header: ShimmerHeader(
                      text: Text(
                        "PullToRefresh",
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      baseColor: AppTheme.bgChatBlue,
                    ),
                    footer: ShimmerFooter(
                      text: Text(
                        "PullToRefresh",
                        style: TextStyle(color: Colors.grey, fontSize: 22),
                      ),
                      noMore: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "AllUserLoaded",
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ),
                      ),
                      baseColor: AppTheme.bgChatBlue,
                    ),
                    controller: widget.refresh,
                    enablePullUp: true,
                    child: ListView.builder(
                        itemCount: widget.dataBid.length,
                        // itemExtent: 100.0,
                        itemBuilder: (c, i) {
                          return ProyekCard(
                            deleteBid: (String id, bool canDelete) {
                              if (canDelete) {
                                openAlertBoxTwo(context, 'Yakin Hapus Bid?', 'Data bid yang dipilih akan hilang!', 'TIDAK', 'YA', ()=>Navigator.pop(context), (){Navigator.pop(context);_deleteBid(id);});
                              } else {
                                openAlertBox(
                                    context,
                                    'Peringatan!',
                                    'Proyek yang telah diterima tidak bisa dihapus!',
                                    'OK',
                                    () => Navigator.pop(context));
                              }
                            },
                            data: widget.dataBid[i],
                            index: i,
                          );
                        }),
                    onRefresh: widget.reloadFunc,
                    onLoading: widget.nextData,
                  )));
  }
}

class ProyekCard extends StatelessWidget {
  const ProyekCard({
    Key key,
    this.deleteBid,
    this.data,
    this.index,
  }) : super(key: key);

  final Function(String id, bool candelete) deleteBid;
  final Map data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    double paddingCard = 8;
    double widthCard =
        (sizeu.width - marginLeftRight * 2 - marginCard * 2 - paddingCard * 2);
    double imgCard = widthCard / 6;
    double heightCard = 110;
    double widthBtnShort = 85;

    double widthKonten = widthCard - imgCard - widthBtnShort - 2;

    transColor(i) {
      int res = 0;
      if ((i + 1) % 1 == 0) {
        res = 0;
      }
      if ((i + 1) % 2 == 0) {
        res = 1;
      }
      if ((i + 1) % 3 == 0) {
        res = 2;
      }
      if ((i + 1) % 4 == 0) {
        res = 3;
      }
      return res;
    }

    return Container(
      // height: heightCard + 55,
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      padding: EdgeInsets.all(paddingCard),
      decoration: BoxDecoration(
        color: AppTheme.renoReno[transColor(index + 1)],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //row image
          Container(
            height: imgCard,
            width: imgCard,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              boxShadow: [
                //background color of box
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4, // soften the shadow
                  spreadRadius: 1, //extend the shadow
                  offset: Offset(
                    .5, // Move to right 10  horizontally
                    3, // Move to bottom 10 Vertically
                  ),
                ),
              ],
            ),
            child: imageLoad(data['thumbnail'], false, imgCard, imgCard),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widthKonten - 10,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['judul'] ?? tanpaNama,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppTheme.primarymenu,
                  ),
                  maxLines: 2,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //konten
                  Container(
                    width: widthKonten,
                    // height: heightCard,
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp' +
                              decimalPointTwo(data['harga'] != null
                                  ? data['harga'].toString()
                                  : '0'),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "KATEGORI ${data['kategori'] != null ? (data['kategori']['nama'] ?? unknown) : unknown}:",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          data['subkategori'] != null
                              ? (data['subkategori']['nama'] ?? unknown)
                              : unknown,
                          style: TextStyle(
                            color: AppTheme.primarymenu,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          data['deskripsi'] ?? kontenkosong,
                          style: TextStyle(
                            // color: AppTheme.primarymenu,
                            fontSize: 12,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  // row shorcut
                  Container(
                    height: heightCard,
                    width: widthBtnShort,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            btnTool(
                                true,
                                'assets/more_icon/info.png',
                                BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  bottomLeft: Radius.circular(30.0),
                                ), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TampilanPublikProyekDetail(
                                    id: parseInt(data['proyek_id']),
                                  ),
                                ),
                              );
                            }),
                            btnTool(
                                data['deleteable'].toString() == '1' ? true : false,
                                'assets/more_icon/remove-file.png',
                                BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0),
                                ),
                                () => deleteBid(
                                    data['id'].toString(), (data['deleteable'].toString() == '1'))),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppTheme.bgChatBlue,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Text(
                            data['status'] ?? unknown,
                            style: TextStyle(
                                color: AppTheme.nearlyWhite, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'TOTAL BID: ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    moreThan99(parseInt(data['jumlah_bid']) ) + ' ORANG  ',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primarymenu,
                    ),
                  ),
                  Image.asset(
                    'assets/more_icon/calender.png',
                    width: 15,
                    fit: BoxFit.fitWidth,
                  ),
                  Text(
                    ' Batas Waktu: ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    pointGroup(data['waktu_pengerjaan'] != null
                            ? int.parse(data['waktu_pengerjaan'].toString())
                            : 0) +
                        ' Hari',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget btnTool(
      bool bg, String locationImg, BorderRadius radius, Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: 40,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: bg ? Colors.white : Colors.white.withOpacity(.4),
          borderRadius: radius,
          border: Border.all(
            width: .5,
            color: AppTheme.nearlyBlack,
          ),
        ),
        child: Image.asset(
          locationImg,
          alignment: Alignment.center,
          // scale: 6,
        ),
      ),
    );
  }
}
