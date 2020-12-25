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
    print(apiURL);

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

  static Future<PublikModel> proyekDetail(String id,Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/proyek/" + id+setParams(res);
print(apiURL);
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

  static Future<PublikModel> bidProyek(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/bid_proyek/";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed,
        },
        body: res);

    print('bid proyek detail status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: {"message": jsonObject['data']['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return PublikModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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

    static Future<PublikModel> terimaBid(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/terima_bid";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed,
        },
        body: res);

    print('terima bid status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: {"message": jsonObject['data']['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return PublikModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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

    static Future<PublikModel> inviteProyek(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "public/invite_proyek";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed,
        },
        body: res);

    print('undangan proyek  code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data: {"message": jsonObject['data']['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return PublikModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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

    static Future<PublikModel> invitePrivate(
      Map other, List<File> lampiran, File thumb) async {
    var apiResult;
    Map jsonObject = {};
    String urll =
        globalBaseUrl + "public/invite_private" ;
    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    if (thumb != null || lampiran.length > 0) {
      var multipartThumb;
      if (thumb != null) {
        var lengthThumb = await thumb.length();
        var streamThumb =
            new http.ByteStream(DelegatingStream.typed(thumb.openRead()));

        multipartThumb = new http.MultipartFile(
            "thumbnail", streamThumb, lengthThumb,
            filename: path.basename(thumb.path));
      }

      var uri = Uri.parse(
        urll,
      );


      var request = new http.MultipartRequest("POST", uri);

      request.headers.addAll({'Authorization': tokenJWT + tokenFixed});
      request.fields.addAll({
        'judul': other['judul'],
        'waktu_pengerjaan': other['waktu_pengerjaan'],
        'harga': other['harga'],
        'deskripsi': other['deskripsi'],
        'kategori': other['kategori'],
        'user_id': other['user_id'],
      });
      if (multipartThumb != null) {
        request.files.add(multipartThumb);
      }

      lampiran.forEach((element) async {
        print(element);
        var lengthLampiran = await element.length();
        var streamLampiran =
            new http.ByteStream(DelegatingStream.typed(element.openRead()));

        var multipartLampiran = new http.MultipartFile(
            "lampiran[]", streamLampiran, lengthLampiran,
            filename: path.basename(element.path));

        request.files.add(multipartLampiran);
      });

      apiResult = await request.send();

      await apiResult.stream.transform(utf8.decoder).listen((value) {
        jsonObject = json.decode(value);
        print(value);
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
      print(apiResult.statusCode);
      jsonObject = json.decode(apiResult.body);
    }

    print('tambah proyek privat undang status code : ' + apiResult.statusCode.toString());
    print(jsonObject);
    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return PublikModel(
          error: false,
          data:jsonObject['data'],
        );
      } else if (apiResult.statusCode == 422) {
        return PublikModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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
