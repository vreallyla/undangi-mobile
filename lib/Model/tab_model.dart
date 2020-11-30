import 'dart:convert';
//import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undangi/Constant/app_var.dart';

import 'package:undangi/Model/general_model.dart';

String tokenFixed = '';
String userData = '';

_setCount(Map count) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('countHome', jsonEncode(count));
}

class TabModel {
  bool error;
  Map<String, dynamic> data;

  TabModel({
    this.error,
    this.data,
  });

  factory TabModel.loopJson(Map<String, dynamic> object) {
    return TabModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<TabModel> homeCount() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "home";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('homeCount status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        _setCount(jsonObject['data']);
        return TabModel(
          error: false,
          data: jsonObject['data'],
        );
      } else if (apiResult.statusCode == 401) {
        await GeneralModel.destroyToken().then((value) => null);
        return TabModel(
          error: true,
          data: {
            'message': message,
            'not_login': true,
          },
        );
      } else {
        return TabModel(
          error: true,
          data: {
            'message': message,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return TabModel(
        error: true,
        data: {'message': e.toString()},
      );
    }
  }

  static Future<TabModel> kategorySearch(String q) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl +
        "kategori" +
        (q != null && q.length > 0 ? '?q=${q}' : '');

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('kategori status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return TabModel(
          error: false,
          data: {'list': jsonObject['data']},
        );
      } else if (apiResult.statusCode == 401) {
        await GeneralModel.destroyToken().then((value) => null);
        return TabModel(
          error: true,
          data: {
            'message': message,
            'not_login': true,
          },
        );
      } else {
        return TabModel(
          error: true,
          data: {
            'message': message,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return TabModel(
        error: true,
        data: {'message': e.toString()},
      );
    }
  }

  static Future<TabModel> proyekData(Map res, bool proyek) async {
    print(res);
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl +
        (proyek ? "proyek" : 'layanan') +
        '?limit=' +
        res['limit'].toString() +
        (res['q'] != null ? '&q=${res['q']}' : '') +
        (res['kat'] != null && res['kat'].length > 0
            ? '&kat=${res['kat']}'
            : '');

    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('kategori status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        print(jsonObject['data']['kategori']);
        return TabModel(
          error: false,
          data: jsonObject['data'],
        );
      } else if (apiResult.statusCode == 401) {
        await GeneralModel.destroyToken().then((value) => null);
        return TabModel(
          error: true,
          data: {
            'message': message,
            'not_login': true,
          },
        );
      } else {
        return TabModel(
          error: true,
          data: {
            'message': message,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return TabModel(
        error: true,
        data: {'message': e.toString()},
      );
    }
  }
}
