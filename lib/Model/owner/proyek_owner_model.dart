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

  static Future<ProyekOwnerModel> getProgress(String proyekId,Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/proyek/"+proyekId+"/progress";
    String params = '';
    int z = 0;

    res.forEach((key, value) {
      if (value != null || value != '') {
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


  static Future<ProyekOwnerModel> addProyek(
      Map other, List<File> lampiran, File thumb, String updateId) async {
    var apiResult;
    Map jsonObject = {};
    String urll =
        globalBaseUrl + "klien/proyek" + (updateId != null ? '/$updateId' : '');
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
        'jenis': other['jenis'],
        'waktu_pengerjaan': other['waktu_pengerjaan'],
        'harga': other['harga'],
        'deskripsi': other['deskripsi'],
        'kategori': other['kategori'],
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

    print('add proyek status code : ' + apiResult.statusCode.toString());
    print(jsonObject);
    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekOwnerModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return ProyekOwnerModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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

  static Future<ProyekOwnerModel> hapusProyek(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/proyek/" + id;

    print(apiURL);

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

  static Future<ProyekOwnerModel> hapusLampiran(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');

    String params = '?';

    res.forEach((key, value) {
      params = params + key + '=' + value + '&';
    });

    params = params.substring(0, params.length - 1);
    String apiURL = globalBaseUrl + "klien/proyek/lampiran" + params;
    print(apiURL);

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

    print(jsonObject);

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

  static Future<ProyekOwnerModel> addLampiran(
      Map other, List<File> lampiran) async {
    var apiResult;
    Map jsonObject = {};
    String urll = globalBaseUrl + "klien/proyek/lampiran";
    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    var uri = Uri.parse(
      urll,
    );

    var request = new http.MultipartRequest("POST", uri);

    request.headers.addAll({'Authorization': tokenJWT + tokenFixed});
    request.fields.addAll({
      'proyek_id': other['proyek_id'],
    });

    lampiran.forEach((element) async {
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
    });

    print('add proyek status code : ' + apiResult.statusCode.toString());
    print(jsonObject);
    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekOwnerModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return ProyekOwnerModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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
