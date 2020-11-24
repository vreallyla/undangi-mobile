import 'dart:convert';
//import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:undangi/Constant/app_var.dart';

import 'package:undangi/Model/general_model.dart';

String tokenFixed = '';
String userData = '';

class ProfileModel {
  bool error;
  Map<String, dynamic> data;

  ProfileModel({
    this.error,
    this.data,
  });

  factory ProfileModel.loopJson(Map<String, dynamic> object) {
    return ProfileModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<ProfileModel> get() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "user";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('user data status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> editProfile() async {
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
        return ProfileModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> getOp(String url) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + url;
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('option data status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: {"daftar": jsonObject['data']},
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> updateProfile(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + 'user/update';
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed
        },
        body: res);

    print('updateProfile status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: {"daftar": jsonObject['data']},
        );
      } else if (apiResult.statusCode == 422) {
        return ProfileModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> uploadFoto(String imgBase64) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + 'user/photo';
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    }, body: {
      'photo': imgBase64
    });

    print('update pp status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> summaryUpdate(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + 'user/summary';
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed
        },
        body: res);

    print('summaryUpdate status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return ProfileModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        await GeneralModel.destroyToken().then((value) => null);
        return ProfileModel(
          error: true,
          data: {
            'message': message,
            'not_login': apiResult.statusCode == 401,
          },
        );
      }
    } catch (e) {
      print('error catch');
      print(e);
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }
}
