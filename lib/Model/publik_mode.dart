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

class PublikModel {
  bool error;
  Map<String, dynamic> data;

  PublikModel({
    this.error,
    this.data,
  });

  factory PublikModel.loopJson(Map<String, dynamic> object) {
    return PublikModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<PublikModel> get(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan publik status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<PublikModel> proyek(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/proyek?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan publik proyek status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<PublikModel> layanan(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/layanan?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan publik layanan status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<PublikModel> portfolio(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/portfolio?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan publik portfolio status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<PublikModel> ulasan(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/ulasan?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan publik portfolio status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<PublikModel> proyekDetail(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/proyek/" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('tampilan proyek detail status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return PublikModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return PublikModel(
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
      return PublikModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }


}
