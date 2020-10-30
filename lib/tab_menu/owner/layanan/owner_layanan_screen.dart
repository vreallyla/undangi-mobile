import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_widget.dart';

class OwnerLayananScreen extends StatefulWidget {
  @override
  _OwnerLayananScreenState createState() => _OwnerLayananScreenState();
}

class _OwnerLayananScreenState extends State<OwnerLayananScreen> {
  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;
    // double _width = sizeu.width;
    // double _height = sizeu.height;
    final paddingPhone = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: appActionHead(paddingPhone, 'Layanan', 'Simpan', () {
        Navigator.pop(context);
      }, () {
        //event act save
        Navigator.pop(context);
      }),
    );
  }
}
