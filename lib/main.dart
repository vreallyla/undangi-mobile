import 'dart:io';
import 'package:undangi/Constant/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:undangi/auth/login_screen.dart';
import 'package:undangi/auth/register_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/chat/chat_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/user_list/user_list_screen.dart';
import 'package:undangi/tab_menu/profile/sub/profil_skill_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_summary_view.dart';
import 'package:undangi/tab_menu/tab_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  //  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/': (context) => TabScreen(),
        '/user_list': (context) => UserListScreen(),
        '/chat': (context) => ChatScreen(),
        '/profil_summary': (context) => ProfilSummaryScreen(),
        '/profil_skill': (context) => ProfilSkillView(),
      },
      title: 'Undagi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.android,
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
