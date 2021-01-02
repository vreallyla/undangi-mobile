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

class ChatModel {
  bool error;
  Map<String, dynamic> data;

  ChatModel({
    this.error,
    this.data,
  });

  factory ChatModel.loopJson(Map<String, dynamic> object) {
    return ChatModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<ChatModel> get(Map res) async {
    // final LocalStorage storage = new LocalStorage('auth');

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });
    String params = '?';

    res.forEach((key, value) {
      params = params + key.toString() + '=' + value.toString() + '&';
      // params=params+key.toString();
    });

    String apiURL =
        globalBaseUrl + "message" + params.substring(0, params.length - 1);

    print(apiURL);

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    // print('chat load status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    // print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ChatModel(
          error: false,
          data: jsonObject['data'],
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ChatModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ChatModel(
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
      return ChatModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ChatModel> typing(String id) async {
    // final LocalStorage storage = new LocalStorage('auth');

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    String apiURL = globalBaseUrl + "message/typing?id=" + id;

    print(apiURL);

    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('typing status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ChatModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ChatModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ChatModel(
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
      return ChatModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

  static Future<ChatModel> sendMsg(Map res) async {

    // final LocalStorage storage = new LocalStorage('auth');

    await GeneralModel.token().then((value) {
      tokenFixed = value.res;
    });

    String apiURL = globalBaseUrl + "message/send";

    print(apiURL);

    var apiResult = await http.post(apiURL,
        headers: {
          "Accept": "application/json",
          "Authorization": tokenJWT + tokenFixed
        },
        body: res);

    print('send message status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject);

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ChatModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } 
      else if (apiResult.statusCode == 422) {
        return ChatModel(
          error: true,
          data: {"message": jsonObject['data']['message'].toString(), 'notValid': true},
        );
      }
      else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ChatModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ChatModel(
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
      return ChatModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

    static Future<ChatModel> sendImg(
      File _image,String chatTo) async {
    var apiResult;
    Map jsonObject = {};
    String urll = globalBaseUrl +
        "message/send";
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
        'chat_id': chatTo,
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
         );
      jsonObject = json.decode(apiResult.body);
    }

    print('send img status code : ' + apiResult.statusCode.toString());

    // listen for response

    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ChatModel(
          error: false,
          data: {"message": jsonObject['message']},
        );
      } else if (apiResult.statusCode == 422) {
        return ChatModel(
          error: true,
          data: {"message": jsonObject['data']['message'].toString(), 'notValid': true},
        );
      } else {
        if (apiResult.statusCode == 401) {
          await GeneralModel.destroyToken().then((value) => null);
          return ChatModel(
            error: true,
            data: {
              'message': message,
              'not_login': apiResult.statusCode == 401,
            },
          );
        } else {
          return ChatModel(
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
      return ChatModel(
        error: true,
        data: {
          'message': e.toString(),
        },
      );
    }
  }

}
