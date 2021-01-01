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

class UndanganListFrelenceTab extends StatefulWidget {
  const UndanganListFrelenceTab({
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

  final Function() reloadFunc;
  final Function() nextData;
  final Function() refreshFunc;
  @override
  _UndanganListFrelenceTabState createState() =>
      _UndanganListFrelenceTabState();
}

class _UndanganListFrelenceTabState extends State<UndanganListFrelenceTab> {
  _konfirmApi(String id, String konfirm) async {
    GeneralModel.checCk(
        //connect
        () async {
      onLoading(context);

      Map res = {
        "id": id,
        "terima": konfirm,
      };

      ProyekFrelencerModel.konfirmInvite(res).then((v) {
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
                            makeDealing: (String id, bool canApprove) {
                              if (canApprove) {
                                openAlertBoxTwo(
                                    context,
                                    'KONFIRMASI UNDANGAN',
                                    'Apakah anda yakin menerima undangan proyek ini? ketika anda menekan tombol TERIMA maka anda tidak bisa mengembalikannya',
                                    'TOLAK',
                                    'TERIMA', () {
                                  Navigator.pop(context);
                                  _konfirmApi(id.toString(), '0');
                                }, () {
                                  Navigator.pop(context);
                                  _konfirmApi(id.toString(), '1');
                                });
                              } else {
                                openAlertBox(
                                    context,
                                    'Pemberitahuan!',
                                    'Undangan yang telah disetujui tidak bisa diubah!',
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
    this.makeDealing,
    this.data,
    this.index,
  }) : super(key: key);

  final Function(String id, bool canApprove) makeDealing;
  final Map data;
  final int index;

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

    return Container(
      // height: heightCard + 55,
      margin: EdgeInsets.only(
        bottom: 5,
      ),
      padding: EdgeInsets.all(paddingCard),
      decoration: BoxDecoration(
        color: AppTheme.renoReno[transColor(index)],
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
              child: imageLoad(data['thumbnail'], false, imgCard, imgCard)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['judul'] ?? unknown,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppTheme.primarymenu,
                  ),
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
                          'KATEGORI ${data['kategori'] != null ? (data['kategori']['nama'] ?? unknown) : unknown}:',
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
                                    id: data['proyek_id'],
                                  ),
                                ),
                              );
                            }),
                            InkWell(
                              onTap: () {
                                makeDealing(data['id'].toString(),
                                    data['approveable'] == 1);
                              },
                              child: Container(
                                width: 40,
                                height: 30,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: data['approveable'] == 1
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ),
                                  border: Border.all(
                                    width: .5,
                                    color: AppTheme.nearlyBlack,
                                  ),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.handshake,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppTheme.bgChatBlue,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                    moreThan99(parseInt(data['jumlah_bid'])) + ' ORANG  ',
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
      String locationImg, BorderRadius radius, Function linkRedirect) {
    return InkWell(
      onTap: () {
        linkRedirect();
      },
      child: Container(
        width: 40,
        height: 30,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
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
