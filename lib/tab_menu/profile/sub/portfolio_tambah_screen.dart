import 'package:flutter/material.dart';
// import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';

class PortfolioTambahScreen extends StatefulWidget {
  @override
  _PortfolioTambahScreenState createState() => _PortfolioTambahScreenState();
}

class _PortfolioTambahScreenState extends State<PortfolioTambahScreen> {
  TextEditingController judulInput = new TextEditingController();
  TextEditingController tautanInput = new TextEditingController();
  TextEditingController tahunInput = new TextEditingController();
  TextEditingController deskripsiInput = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
        appBar: appActionHead(paddingPhone, 'Portfolio', 'Tambah', () {
          Navigator.pop(context);
        }, () {
          //event act save
          Navigator.pop(context);
        }),
        body: Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: ListView(
            children: [
              containerInput(
                  TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLength: 80,
                    controller: judulInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Judul Portfolio",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  45),
              containerInput(
                  TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLength: 80,
                    controller: tautanInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Tautan Portfolio",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  45),
              containerInput(
                  TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLength: 80,
                    controller: tahunInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Tahun",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  45),
              containerInput(
                  TextField(
                    onChanged: (v) {
                      // widget.eventtChange(v);
                    },
                    onSubmitted: (v) {
                      // widget.eventtSubmit(v);
                    },
                    maxLines: 3,
                    maxLength: 240,
                    controller: deskripsiInput,
                    // focusNode: focusCariKategori,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Deskripsi",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  90),
              containerInput(
                SizedBox(
                  width: sizeu.width - 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (AssetImage('assets/more_icon/photo.png')),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Text('Unggah Gambar')
                    ],
                  ),
                ),
                80,
              )
            ],
          ),
        ));
  }

  Widget containerInput(Widget chill, double heig) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: heig,
        child: chill);
  }
}
