
import 'package:flutter/material.dart';

Icon iconStar(fontSize) {
    return Icon(
      Icons.star,
      color: Colors.yellow,
      size: fontSize,
    );
  }

Icon iconStarSetengah(fontSize) {
    return Icon(
      Icons.star_half,
      color: Colors.yellow,
      size: fontSize,
    );
  }

  Icon iconStarKosong(fontSize) {
    return Icon(
      Icons.star_border,
      color: Colors.grey,
      size: fontSize,
    );
  }

  Widget starJadi(double jmlStar, String jlmVote,double width,double fontSize) {
    List dataRown = <Widget>[];

    List.generate(5, (index) {
      dataRown.add(
        Container(
          width: width,
            child: (index + 1) <= jmlStar
                ? iconStar(fontSize)
                : (index < jmlStar ? iconStarSetengah(fontSize) : iconStarKosong(fontSize))),
      );
    });

    dataRown.add(Text(' ${jmlStar.toString()} (${jlmVote!=null ? jlmVote:'0'} Ulasan)',
        style: TextStyle(fontSize: 10, color: Colors.grey)));

    return Row(children: dataRown);
  }