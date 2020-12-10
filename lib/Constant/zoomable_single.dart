import 'package:flutter/material.dart';
import 'package:undangi/Constant/app_theme.dart';
import 'package:undangi/Constant/app_widget.dart';


class ZoomableSingle extends StatelessWidget {
  const ZoomableSingle({Key key, this.child, this.min, this.max})
      : super(key: key);

  final Widget child;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
     final sizeu = MediaQuery.of(context).size;
    final paddingPhone = MediaQuery.of(context).padding;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: appPolosBack(paddingPhone, () {
        Navigator.pop(context);
      }),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: InteractiveViewer(
            boundaryMargin: EdgeInsets.all(20.0),
            minScale: min,
            maxScale: max,
            child: child),
      ),
    );
  }
}
