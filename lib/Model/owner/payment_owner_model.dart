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
String pathUrl='klien/proyek/payment';

class PaymentOwnerModel {
  bool error;
  Map<String, dynamic> data;

  PaymentOwnerModel({
    this.error,
    this.data,
  });

  factory PaymentOwnerModel.loopJson(Map<String, dynamic> object) {
    return PaymentOwnerModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<PaymentOwnerModel> get(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + pathUrl+"?proyek_id=$id";
   print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('get proyek payment status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PaymentOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PaymentOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PaymentOwnerModel(
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
      return PaymentOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

   static Future<PaymentOwnerModel> viaDompet(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + pathUrl+"/dompet";
   print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    },body: res);

    print('bayar proyek via dompet status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PaymentOwnerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PaymentOwnerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PaymentOwnerModel(
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
      return PaymentOwnerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

}
