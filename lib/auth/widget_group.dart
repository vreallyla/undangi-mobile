import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';

Container headerView(String judul) {
  return Container(
    height: 90,
    alignment: Alignment.bottomLeft,
    padding: EdgeInsets.all(15),
    color: AppTheme.primaryBlue,
    width: double.infinity,
    child: Text(
      judul,
      style: AppTheme.headBar,
    ),
  );
}

Widget footerView() {
  return PreferredSize(
    preferredSize: Size.fromHeight(50.0),
    child: BottomAppBar(
      child: Container(height: 50, color: AppTheme.primaryBlue),
    ),
  );
}

InputDecoration textfieldDesign(String hint) {
  return InputDecoration(
    border: InputBorder.none,
    hintText: hint,
  );
}
