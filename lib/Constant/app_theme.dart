import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const double sizeIconMenu = 40;

  static const Color primaryWhite = Color(0xFFffffff);
  static const Color primaryBg = Color(0xFFf9f9f9);
  static const Color primarymenu = Color(0xFF4a82df);
  static const Color primaryRed = Color(0xFFf90706);

  static const Color biruLaut = Color(0xFF29a9ff);

  static const Color primaryBlue = Color(0xFF29adfe);
  static const Color softBlue = Color(0xFFefffff);

  static const Color cardWhite = Color(0xFFf9f9f9);
  static const Color cardBlue = Color(0xFFdee6ef);

  static const Color geyCustom = Colors.black45;
  static const Color geySolidCustom = Colors.black54;
  static const Color geySoftCustom = Color(0xFFfdffff);
  static const Color geySofttCustom = Color(0xFFe9e9e9);
  

  static const bgChatBlue = Color(0xFF2979ff);
  static const bgChatGrey = Color(0xFF989292);

  static const Color textBlue = Color(0xFF3a5c67);
  static const Color textPink = Color(0xFFf38e9d);

  static const Color bgRedSoft = Color(0xFFffebfc);
  static const Color bgYellowSoft = Color(0xFFfffceb);
  static const Color bgBlueSoft = Color(0xFFf1f3fe);
  static const Color bgGreenBlueSoft = Color(0xFFc6d9dd);
  static const Color bgGreenSoft = Color(0xFF6de1b4);
  static const Color bgBlue2Soft = Color(0xFFc7d9dc);
  

  static const Color bgIcoGrey = Color(0xFFf1eff2);

  static const Color contentBrown = Color(0xFF944d4d);
  static const Color contentYellow = Color(0xFFf3d7b2);
  static const Color contentBlue = Color(0xFFb4bbdc);

  static const Color iconActive = Color(0xFF230cff);
  static const Color iconNonActive = Color(0xFFfefffe);

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle headBar = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    // fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: white,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
