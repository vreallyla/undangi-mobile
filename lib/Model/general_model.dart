import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

_setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', token);
  tokenFixed = token;
}

_destroyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tokenFixed = prefs.getString('token');

  if (tokenFixed != null) {
    tokenFixed = '';
    await prefs.remove("token");
  }
}

String tokenFixed;

class GeneralModel {
  final res;

  GeneralModel({
    this.res,
  });

  static Future<GeneralModel> token() async {
    await _getToken();

    return GeneralModel(res: tokenFixed);
  }

  static Future<GeneralModel> checCk(Function a, Function b) async {
    bool internet = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internet = true;
        a();
      }
    } on SocketException catch (_) {
      b();
    }

    // internet = true;
    //     a();

    return GeneralModel(res: internet);
  }

  static Future<GeneralModel> setToken(String token) async {
    await _setToken(token);

    return GeneralModel(res: tokenFixed);
  }

  static Future<GeneralModel> destroyToken() async {
    await _destroyToken();

    return GeneralModel(res: 'ok');
  }
}
