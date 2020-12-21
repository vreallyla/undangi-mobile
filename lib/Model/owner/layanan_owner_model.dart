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

    print('get klien proyek status code : ' + apiResult.statusCode.toString());
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

  static Future<LayananOwnerModel> addLayanan(
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
        return LayananOwnerModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return LayananOwnerModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
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

  static Future<LayananOwnerModel> hapusProyek(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "klien/proyek/" + id;

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
