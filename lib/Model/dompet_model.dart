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

class DompetModel {
  bool error;
  Map<String, dynamic> data;

  DompetModel({
    this.error,
    this.data,
  });

  factory DompetModel.loopJson(Map<String, dynamic> object) {
    return DompetModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<DompetModel> get() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "dompet";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('dompet dashboard status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return DompetModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return DompetModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return DompetModel(
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
      return DompetModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<DompetModel> pinChange(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "dompet/pin";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, body: res, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('change pin status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return DompetModel(
          error: false,
          data: jsonObject['data'],
        );
      } else if (apiResult.statusCode == 422) {
        return DompetModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return DompetModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return DompetModel(
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
      return DompetModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<DompetModel> pinCheck(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "dompet/check";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, body: res, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('change pin status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return DompetModel(
          error: false,
          data: jsonObject['data'],
        );
      } else if (apiResult.statusCode == 422) {
        return DompetModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return DompetModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return DompetModel(
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
      return DompetModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<DompetModel> withdraw(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "dompet/withdraw";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, body: res, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('change pin status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;
        print(jsonObject);

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return DompetModel(
          error: false,
          data: jsonObject['data'],
        );
      } else if (apiResult.statusCode == 422) {
        return DompetModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return DompetModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return DompetModel(
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
      return DompetModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }
}
