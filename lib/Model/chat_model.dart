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
    String params='?';

    res.forEach((key, value) {

      params=params+key.toString()+'='+value.toString()+'&';
      // params=params+key.toString();
    });
  

    String apiURL = globalBaseUrl + "message"+params.substring(0,params.length-1);

    print(apiURL);


    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('chat load status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject['data']['typing']);
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
  
  

    String apiURL = globalBaseUrl + "message/typing?id="+id;

    print(apiURL);


    var apiResult = await http.get(apiURL, headers: {
      "Accept": "application/json",
      "Authorization": tokenJWT + tokenFixed
    });

    print('typing status code : ' + apiResult.statusCode.toString());
    Map jsonObject = json.decode(apiResult.body);
    print(jsonObject['data']['typing']);
    String message = jsonObject.containsKey('message')
        ? jsonObject['message'].toString()
        : notice;

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        return ChatModel(
          error: false,
          data: {"message":jsonObject['message']},
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
