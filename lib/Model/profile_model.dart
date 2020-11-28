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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> skillBahasaUpdate(List res, List rule) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + 'user/skills_update';
    print(apiURL);

    List notice = [];
    int i = 0;

    res.forEach((v) {
      List nama = [], tingkatan = [];

      if (v['nama'].length == 0) {
        nama.add('The name is required.');
      }
      if (v['tingkatan'].length == 0) {
        tingkatan.add('The grade is required.');
      } else if (!rule.contains(v['tingkatan'])) {
        tingkatan.add('The selected grade invalid.');
      }
      if (nama.length > 0 || tingkatan.length > 0)
        notice.add({
          "index": i,
          "nama": nama,
          "tingkatan": tingkatan,
        });
      i++;
    });

    if (notice.length > 0) {
      print('skillbahasa Update status code : 422');
      return ProfileModel(
        error: true,
        data: {
          'message': notice,
          "notValid": true,
        },
      );
    }

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    }, body: {
      "update": jsonEncode(res)
    });

    print(
        'skillbahasa Update status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    print(jsonObject.toString());

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProfileModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> portfolioNew(
      File _image, Map other, int updateId) async {
    var apiResult;
    Map jsonObject = {};
    String urll = globalBaseUrl +
        "user/portofolio" +
        (updateId != null ? '/${updateId}' : '');
    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    if (_image != null) {
      var length = await _image.length();
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));

      var uri = Uri.parse(
        urll,
      );

      var request = new http.MultipartRequest("POST", uri);

      var multipart = new http.MultipartFile("image", stream, length,
          filename: path.basename(_image.path));
      request.headers.addAll({'Authorization': tokenJWT + tokenFixed});
      request.fields.addAll({
        'judul': other['judul'],
        'tautan': other['tautan'],
        'deskripsi': other['deskripsi'],
        'tahun': other['tahun'],
      });
      request.files.add(multipart);
      apiResult = await request.send();

      await apiResult.stream.transform(utf8.decoder).listen((value) {
        jsonObject = json.decode(value);
      });
    } else {
      String apiURL = urll;
      print(apiURL);
      apiResult = await http.post(apiURL,
          headers: {
            "Accept": "application/json",
            "Authorization": tokenJWT + tokenFixed
          },
          body: other);
      jsonObject = json.decode(apiResult.body);
    }

    print('portfolio new status code : ' + apiResult.statusCode.toString());

    // listen for response

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
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProfileModel> portfolioHapus(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + 'user/portofolio/${id}';
    print(apiURL);

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.delete(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

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
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProfileModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProfileModel(
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
      return ProfileModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }
}
