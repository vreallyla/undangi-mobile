import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_var.dart';
import 'package:undangi/Constant/app_widget.dart';
import 'package:undangi/Constant/shimmer_indicator.dart';

class TabProyekView extends StatefulWidget {
  const TabProyekView(
      {Key key,
      this.paddingTop,
      this.dataReresh,
      this.dataNext,
      this.refresh,
      this.paddingBottom,
      this.loading,
      this.dataProyek,
      this.editEvent,
      this.editId = 0,
      this.bottomKey = 0,
      this.toAdd,
      this.toAddFunc})
      : super(key: key);

  final List dataProyek;
  final Function dataReresh;
  final Function dataNext;
  final RefreshController refresh;

  final double bottomKey;
  final double paddingTop;
  final double paddingBottom;
  final Function toAddFunc;
  final bool toAdd;
  final bool loading;
  final int editId;
  final Function(int id) editEvent;
  @override
  _TabProyekViewState createState() => _TabProyekViewState();
}

class _TabProyekViewState extends State<TabProyekView> {
  TextEditingController inputKategori = new TextEditingController();
  TextEditingController inputJudul = new TextEditingController();
  RefreshController _refreshController = RefreshController();

  String jnsProyek = 'publik';
  @override
  Widget build(BuildContext context) {
    double marginLeftRight = 10;
    double marginCard = 5;
    final sizeu = MediaQuery.of(context).size;
    double gangInput = 5;

    return widget.toAdd
        ? Container(
            width: sizeu.width - marginLeftRight,
            margin: EdgeInsets.only(left: marginLeftRight),
            height: sizeu.height -
                310 -
                widget.bottomKey -
                widget.paddingBottom -
                widget.paddingTop,
            padding: EdgeInsets.all(marginCard),
            decoration: BoxDecoration(
              color: AppTheme.nearlyWhite,
              border: Border(
                top: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                bottom: BorderSide(width: .5, color: AppTheme.geySolidCustom),
                left: BorderSide(width: .5, color: AppTheme.geySolidCustom),
              ),
            ),
            child: ListView(
              children: [
                Text(
                  (widget.editId != 0 ? 'UPDATE' : 'TAMBAH') + ' PROYEK',
                  style: TextStyle(
                      color: AppTheme.textBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.geyCustom)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: judulLabel('Kategori')),
                          Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(right: 10),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    widget.toAddFunc();
                                    widget.editEvent(0);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.times,
                                    size: 13,
                                    color: AppTheme.geyCustom,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      inputHug(
                        'Kategori proyek anda',
                        FaIcon(
                          FontAwesomeIcons.tag,
                          size: 16,
                        ),
                        inputKategori,
                      ),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      judulLabel('Judul'),
                      inputHug(
                        'Judul Proyek',
                        FaIcon(
                          FontAwesomeIcons.pen,
                          size: 16,
                        ),
                        inputJudul,
                      ),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      judulLabel('Deskripsi'),
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 13.0, height: 1, color: Colors.black),
                          // controller: catatanInput,
                          textAlign: TextAlign.start,
                          maxLines: 4,
                          maxLength: 250,
                          onChanged: (text) => {setState(() {})},
                          decoration: new InputDecoration(
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1),
                            ),
                            hintText: 'Deskripsi terkait proyek anda',
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: gangInput)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: (sizeu.width - 137) / 2,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Batas Waktu Proyek',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                //batas waktu
                                Row(children: [
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.calendarCheck,
                                      size: 9,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: ((sizeu.width - 137) / 2) - 60,
                                    height: 25,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: Text(
                                      'Hari',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ]),
                                Padding(padding: EdgeInsets.only(top: 3)),
                                Text(
                                  'Thumbnail',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                Row(children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        left: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: (sizeu.width - 137) / 2 - 30,
                                    height: 25,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.geyCustom
                                                .withOpacity(.2)),
                                      ),
                                      child: Icon(
                                        Icons.file_upload,
                                        size: 12,
                                      )),
                                ]),
                              ],
                            ),
                          ),
                          Container(
                            width: (sizeu.width - 137) / 2,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga Layanan',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                //batas waktu
                                Row(children: [
                                  Container(
                                    width: 30,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.2)),
                                    ),
                                    child: Text(
                                      'Rp',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: (sizeu.width - 137) / 2 - 60,
                                    height: 25,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.geyCustom
                                                .withOpacity(.2)),
                                      ),
                                      child: Icon(
                                        Icons.attach_money,
                                        size: 12,
                                      )),
                                ]),
                                Padding(padding: EdgeInsets.only(top: 3)),
                                Text(
                                  'Pilih File',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.geySolidCustom,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(padding: EdgeInsets.only(top: 3)),

                                Row(children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: AppTheme.geySofttCustom
                                          .withOpacity(.8),
                                      border: Border(
                                        top: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        bottom: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                        left: BorderSide(
                                          color: AppTheme.geyCustom
                                              .withOpacity(.4),
                                        ),
                                      ),
                                    ),
                                    width: (sizeu.width - 137) / 2 - 30,
                                    height: 25,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 11.0,
                                      ),
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 5),
                                        border: InputBorder.none,
                                        hintText: '',
                                        suffixStyle:
                                            TextStyle(color: Colors.black),
                                        counterStyle: TextStyle(
                                          height: double.minPositive,
                                        ),
                                        counterText: "",
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 30,
                                      height: 25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppTheme.geyCustom
                                                .withOpacity(.2)),
                                      ),
                                      child: Icon(
                                        Icons.insert_drive_file,
                                        size: 12,
                                      )),
                                ]),
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            margin: EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      jnsProyek = 'publik';
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width: sizeu.width - 250,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: jnsProyek == 'publik'
                                          ? AppTheme.primarymenu
                                          : AppTheme.nearlyWhite,
                                      border: Border.all(
                                          color: jnsProyek == 'publik'
                                              ? Colors.transparent
                                              : AppTheme.geyCustom,
                                          width: 1),
                                    ),
                                    child: Text(
                                      'Publik',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: jnsProyek == 'publik'
                                              ? AppTheme.nearlyWhite
                                              : AppTheme.primarymenu),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      jnsProyek = 'privat';
                                    });
                                    print(jnsProyek);
                                  },
                                  child: Container(
                                    height: 25,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: jnsProyek == 'privat'
                                          ? AppTheme.primaryRed
                                          : AppTheme.nearlyWhite,
                                      border: Border.all(
                                          color: jnsProyek == 'privat'
                                              ? Colors.transparent
                                              : AppTheme.geyCustom,
                                          width: 1),
                                    ),
                                    child: Text(
                                      'Privat',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: jnsProyek == 'privat'
                                              ? AppTheme.nearlyWhite
                                              : AppTheme.primarymenu),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10, top: 5),
                        height: 25,
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 80,
                          child: RaisedButton(
                            onPressed: () {
                              widget.editEvent(0);
                              widget.toAddFunc();
                            },
                            color: AppTheme.primaryBlue,
                            child: Text(
                                widget.editId != 0 ? 'Update' : 'Simpan',
                                style: TextStyle(
                                    color: AppTheme.white, fontSize: 14)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : proyekList();
  }

  Widget inputHug(String hint, FaIcon icon, TextEditingController controller) {
    final sizeu = MediaQuery.of(context).size;

    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 3),
      width: sizeu.width,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: icon,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.geyCustom.withOpacity(.2)),
          ),
        ),
        Container(
          child: TextField(
            style: TextStyle(
              fontSize: 13.0,
            ),
            controller: controller,
            maxLength: 45,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              suffixStyle: TextStyle(color: Colors.black),
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
            ),
          ),
          width: sizeu.width - 93,
          padding: EdgeInsets.only(left: 5, right: 5, top: 14),
          alignment: Alignment.centerLeft,
          // height: 25,
          decoration: BoxDecoration(
              color: AppTheme.geySofttCustom.withOpacity(.8),
              border: Border(
                top: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                right: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
                bottom: BorderSide(color: AppTheme.geyCustom.withOpacity(.3)),
              )),
        ),
      ]),
    );
  }

  Widget judulLabel(String judul) {
    return SizedBox(
      height: 18,
      child: Text(
        judul,
        style: TextStyle(
            fontSize: 14,
            color: AppTheme.geySolidCustom,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget proyekList() {
    final sizeu = MediaQuery.of(context).size;
    double marginLeftRight = 10;
    double marginCard = 5;
    return Container(
      margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
      padding: EdgeInsets.all(marginCard),
      alignment: Alignment.topLeft,
      height: sizeu.height -
          310 -
          widget.bottomKey -
          widget.paddingBottom -
          widget.paddingTop,
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
          : (widget.dataProyek.length == 0
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
                      itemCount: widget.dataProyek.length,
                      // itemExtent: 100.0,
                      itemBuilder: (c, i) =>
                          cardProyek(widget.dataProyek[i], i)),
                  onRefresh: widget.dataReresh,
                  onLoading: widget.dataNext,
                )),
    );
  }

  Widget cardProyek(Map data, int i) {
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
    double widthKonten = widthCard - imgCard - widthBtnShort - widthBtnPlay - 2;

    return Container(
        // height: heightCard + 55,
        margin: EdgeInsets.only(
          bottom: 5,
        ),
        padding: EdgeInsets.all(paddingCard),
        decoration: BoxDecoration(
          color: AppTheme.bgRedSoft,
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
                  width: widthKonten + widthBtnPlay,
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    data['judul'],
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
                      width: widthKonten + widthBtnPlay,
                      // height: heightCard,
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rp' + decimalPointTwo(data['harga'].toString()),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'KATEGORI ' +
                                  (data.containsKey('kategori')
                                      ? data['kategori']['nama']
                                      : unknown) +
                                  ":",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            data.containsKey('subkategori')
                                ? data['subkategori']['nama']
                                : 'sub ' + unknown,
                            style: TextStyle(
                              color: AppTheme.primarymenu,
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              data['deskripsi'] ?? empty,
                              style: TextStyle(
                                // color: AppTheme.primarymenu,
                                fontSize: 12,
                              ),
                              maxLines: 3,
                            ),
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
                                print('info');
                              }),
                              btnTool(
                                  'assets/more_icon/file_alt.png',
                                  BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ), () {
                                print('info');
                              }),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              btnTool(
                                  'assets/more_icon/edit-button.png',
                                  BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ), () {
                                widget.editEvent(1);

                                widget.toAddFunc();
                              }),
                              btnTool(
                                  'assets/more_icon/remove-file.png',
                                  BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ), () {
                                openAlertBoxTwo(
                                    context,
                                    'KONFIRMASI HAPUS PROYEK',
                                    'Apa anda yakin hapus proyek ini? Proyek akan hilang!',
                                    'TIDAK',
                                    'HAPUS', () {
                                  Navigator.pop(context);
                                }, () {
                                  Navigator.pop(context);
                                });
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //BUTTON PLAY
                    // Container(
                    //   height: heightCard,
                    //   width: widthBtnPlay,
                    //   alignment: Alignment.centerRight,
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         width: 40,
                    //         height: 40,
                    //         decoration: BoxDecoration(
                    //           image: DecorationImage(
                    //             image: AssetImage(
                    //                 'assets/home/circle_quatral.png'),
                    //             fit: BoxFit.fitHeight,
                    //           ),
                    //           // borderRadius:
                    //           //     BorderRadius.all(Radius.circular(20)),
                    //         ),
                    //         child: Icon(
                    //           Icons.play_arrow,
                    //           color: AppTheme.textPink,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                      moreThan99((data['total_bid'] ?? 0)) + ' ORANG  ',
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
                      pointGroup(
                              int.parse(data['waktu_pengerjaan'].toString()) ??
                                  0) +
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
        ));
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
