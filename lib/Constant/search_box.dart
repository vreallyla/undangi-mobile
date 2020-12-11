import 'package:flutter/material.dart';

import 'app_theme.dart';

class SearcBox extends StatefulWidget {
  const SearcBox(
      {Key key,
      this.controll,
      this.marginn,
      this.paddingg,
      this.widthh,
      this.heightt,
      this.widthText,
      this.textL,
      this.placeholder,
      this.radiusBorder: 9,
      this.eventtChange,
      this.eventtSubmit,
      this.fontSize: 16,
      this.iconWidth: 30})
      : super(key: key);

  final TextEditingController controll;
  final EdgeInsets marginn;
  final EdgeInsets paddingg;
  final double fontSize;
  final double widthh;
  final double heightt;
  final double widthText;
  final double radiusBorder;
  final double iconWidth;
  final int textL;
  final String placeholder;
  final Function(String v) eventtChange;
  final Function(String v) eventtSubmit;
  @override
  _SearcBoxState createState() => _SearcBoxState();
}

class _SearcBoxState extends State<SearcBox> {
  @override
  Widget build(BuildContext context) {
    // final sizeu = MediaQuery.of(context).size;

    return Container(
      width: widget.widthh,
      margin: widget.marginn,
      height: widget.heightt,
      padding: widget.paddingg,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radiusBorder),
        color: Colors.white,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.widthText,
            child: TextField(
              onChanged: (v) {
                widget.eventtChange(v);
              },
              onSubmitted: (v) {
                widget.eventtSubmit(v);
              },
              maxLength: widget.textL,
              controller: widget.controll,
              style: new TextStyle(fontSize: widget.fontSize),
              // focusNode: focusCariKategori,
              decoration: InputDecoration(
                counterText: "",
                hintText: widget.placeholder,
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppTheme.textBlue),
              ),
            ),
          ),
          SizedBox(
            width: widget.iconWidth,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppTheme.geyCustom,
                size: widget.fontSize + 5,
              ),
              // color: Colors.white,
              onPressed: () =>widget.eventtSubmit(widget.controll.text),
            ),
          )
        ],
      ),
    );
  }
}
