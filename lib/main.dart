import 'dart:io';
import 'package:undangi/Constant/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:undangi/Splash_screen.dart';
import 'package:undangi/auth/login_screen.dart';
import 'package:undangi/auth/register_screen.dart';
import 'package:undangi/tab_menu/frelencer/pay/pay_frelence_screen.dart';
import 'package:undangi/tab_menu/frelencer/proyek/proyek_frelence_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/chat/chat_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/proyek_list/proyek_list_screen.dart';
import 'package:undangi/tab_menu/home/sub_menu/user_list/user_list_screen.dart';
import 'package:undangi/tab_menu/owner/layanan/owner_layanan_screen.dart';
import 'package:undangi/tab_menu/owner/proyek/owner_proyek_screen.dart';
import 'package:undangi/tab_menu/owner/proyek/sub/payment_proyek_screen.dart';
import 'package:undangi/tab_menu/profile/sub/ganti_password_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_edit_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_skill_delete_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_skill_view.dart';
import 'package:undangi/tab_menu/profile/sub/profil_summary_view.dart';
import 'package:undangi/tab_menu/tab_screen.dart';

import 'tab_menu/home/sub_menu/layanan_list/layanan_list_screen.dart';
import 'tab_menu/search/search_tab_screen.dart';

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
      initialRoute: '/',
      home: SplashScreen(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => TabScreen(),
        '/search_kategori': (context) => SearchTabScreen(),

        '/user_list': (context) => UserListScreen(),
        '/proyek_list': (context) => ProyekListScreen(),
        '/layanan_list': (context) => LayananListScreen(),
        '/chat': (context) => ChatScreen(),
        // '/profil_summary': (context) => ProfilSummaryScreen(),
        '/profil_skill': (context) => ProfilSkillView(),
        '/profil_edit': (context) => ProfilEditView(),

        '/profil_skill_delete': (context) => ProfilSkillDeleteView(),
        '/ganti_password': (context) => GantiPasswordView(),

        //owner tab
        '/owner_layanan': (context) => OwnerLayananScreen(),
        '/owner_proyek': (context) => OwnerProyekScreen(),
        '/owner_proyek_payment': (context) => PaymentProyekScreen(),

        //frelencer tab
        '/udagi_pay': (context) => PayFrelenceScreen(),
        '/proyek_frelence': (context) => ProyekFrenlenceScreen(),
      },
      title: 'Undagi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
