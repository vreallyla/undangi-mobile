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

class LayananOwnerModel {
  bool error;
  Map<String, dynamic> data;

  LayananOwnerModel({
    this.error,
    this.data,
  });

  factory LayananOwnerModel.loopJson(Map<String, dynamic> object) {
    return LayananOwnerModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<LayananOwnerModel> get(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/layanan";
    String params = '';
    int z = 0;

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

    print('get klien layanan status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return LayananOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return LayananOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return LayananOwnerModel(
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
      return LayananOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  
  static Future<LayananOwnerModel> hapusLayanan(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/layanan/" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.delete(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('hapus proyek status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return LayananOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return LayananOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return LayananOwnerModel(
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
      return LayananOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

 }
