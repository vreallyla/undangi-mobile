import 'dart:convert';
import 'dart:io';
// import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:undangi/Constant/app_var.dart';

import 'package:undangi/Model/general_model.dart';

import 'package:path/path.dart' as path;
import 'package:async/async.dart';

String tokenFixed = '';
String userData = '';

class ProyekFrelencerModel {
  bool error;
  Map<String, dynamic> data;

  ProyekFrelencerModel({
    this.error,
    this.data,
  });

  factory ProyekFrelencerModel.loopJson(Map<String, dynamic> object) {
    return ProyekFrelencerModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<ProyekFrelencerModel> get(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "pekerja/proyek";
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

    print('get frelencer proyek status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    // print(jsonObject);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProyekFrelencerModel> getProgress(String id,Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "pekerja/proyek/"+id+"/progress";
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

    print('get frelencer proyek status code : ' +
        apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    // print(jsonObject);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProyekFrelencerModel> saveProgress(
    String proyekId,  Map other, File thumb) async {
    var apiResult;
    Map jsonObject = {};
    String urll =
        globalBaseUrl + "pekerja/proyek/"+proyekId+"/progress" ;
    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    if (thumb != null ) {
      var multipartThumb;
      if (thumb != null) {
        var lengthThumb = await thumb.length();
        var streamThumb =
            new http.ByteStream(DelegatingStream.typed(thumb.openRead()));

        multipartThumb = new http.MultipartFile(
            "bukti_gambar", streamThumb, lengthThumb,
            filename: path.basename(thumb.path));
      }

      var uri = Uri.parse(
        urll,
      );


      var request = new http.MultipartRequest("POST", uri);

      request.headers.addAll({'Authorization': tokenJWT + tokenFixed});
      request.fields.addAll({
        'deskripsi': other['deskripsi'],
      });
      if (multipartThumb != null) {
        request.files.add(multipartThumb);
      }

     
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

    print('tambah progress proyek status code : ' + apiResult.statusCode.toString());
    print(jsonObject);
    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data:jsonObject['data'],
        );
      } else if (apiResult.statusCode == 422) {
        return ProyekFrelencerModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }


//TODO:: USE IMAGE EXAMPLE
  static Future<ProyekFrelencerModel> addLayanan(
      Map other, List<File> lampiran, File thumb, String updateId) async {
    var apiResult;
    Map jsonObject = {};
    String urll = globalBaseUrl +
        "pekerja/layanan" +
        (updateId != null ? '/$updateId' : '');
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
        'pengerjaan': other['pengerjaan'],
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

    print('add layanan status code : ' + apiResult.statusCode.toString());
    print(jsonObject);
    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return ProyekFrelencerModel(
          error: true,
          data: {"message": jsonObject['data']['message'], 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProyekFrelencerModel> deleteBid(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "pekerja/proyek/bid?id=" + id;

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });
    print(apiURL);

    var apiResult = await http.delete(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('hapus bid pekerja status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ProyekFrelencerModel> konfirmInvite(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl + "pekerja/proyek/invitation";

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });
    print(apiURL);

    var apiResult = await http.post(apiURL, body: res, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('KONFIRM UNDANGAN pekerja status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ProyekFrelencerModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ProyekFrelencerModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ProyekFrelencerModel(
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
      return ProyekFrelencerModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }
}
