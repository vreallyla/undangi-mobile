import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_widget.dart';

class GantiPasswordView extends StatefulWidget {
  @override
  _GantiPasswordViewState createState() => _GantiPasswordViewState();
}

class _GantiPasswordViewState extends State<GantiPasswordView> {
  TextEditingController passwordInput = new TextEditingController();
  TextEditingController newPassInput = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final sizeu = MediaQuery.of(context).size;
    // double _width = sizeu.width;
    // double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: appActionHead(paddingPhone, 'Password', 'Simpan', () {
        Navigator.pop(context);
      }, () {
        //event act save
        Navigator.pop(context);
      }),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                'Password Lama',
                style: TextStyle(
                  // color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            containerInput(
                TextField(
                  onChanged: (v) {
                    // widget.eventtChange(v);
                  },
                  onSubmitted: (v) {
                    // widget.eventtSubmit(v);
                  },
                  maxLength: 80,
                  controller: passwordInput,
                  // focusNode: focusCariKategori,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                45),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                'Password Baru',
                style: TextStyle(
                  // color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            containerInput(
                TextField(
                  onChanged: (v) {
                    // widget.eventtChange(v);
                  },
                  onSubmitted: (v) {
                    // widget.eventtSubmit(v);
                  },
                  maxLength: 80,
                  controller: newPassInput,
                  // focusNode: focusCariKategori,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                45),
          ],
        ),
      ),
    );
  }

  Widget containerInput(Widget chill, double heig) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        height: heig,
        child: chill);
  }
}
