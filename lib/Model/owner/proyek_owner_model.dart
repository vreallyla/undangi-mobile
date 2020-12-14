import 'dart:convert';
import 'dart:io';
//import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:undangi/Constant/app_var.dart';

import 'package:undangi/Model/general_model.dart';

import 'package:path/path.dart' as path;
import 'package:async/async.dart';

String tokenFixed = '';
String userData = '';

class ProyekOwnerModel {
  bool error;
  Map<String, dynamic> data;

  ProyekOwnerModel({
    this.error,
    this.data,
  });

  factory ProyekOwnerModel.loopJson(Map<String, dynamic> object) {
    return ProyekOwnerModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<ProyekOwnerModel> get(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/proyek";
    String params = '';
    int z = 0;
    print(res);
    res.forEach((key, value) {
      if (value != null && value != '') {
        params = params + (z > 0 ? '&' : '?');
        params = params + key + '=' + value.toString();
        z++;
      }
    });



    apiURL = apiURL + params;
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('get klien proyek status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    // print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekOwnerModel(
            error: true,
            data: {
              'message': message,
            },
          );
        }
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProyekOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProyekOwnerModel> editProfile() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "user/edit";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('edit user data status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekOwnerModel(
            error: true,
            data: {
              'message': message,
            },
          );
        }
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProyekOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }
}