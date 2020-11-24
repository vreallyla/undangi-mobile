import 'dart:convert';

import 'package:undangi/Constant/app_var.dart';
import 'package:http/http.dart' as http;
import './general_model.dart';

class AuthModel {
  bool error;
  final data;

  AuthModel({
    this.error,
    this.data,
  });

  static Future<AuthModel> login(String email, String password) async {
    String apiURL = globalBaseUrl + globalPathAuth + "login";

    print(apiURL);

    try {
      var apiResult = await http.post(
        apiURL,
        body: {'email': email, 'password': password},
        headers: {
          "Accept": "application/json",
        },
      );

      print('login status code : ' + apiResult.statusCode.toString());

      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        var jsonObject = json.decode(apiResult.body);

        await GeneralModel.setToken(jsonObject['token']);

        // print(jsonObject['status']);

        return AuthModel(
          error: false,
          data: jsonEncode({"message": 'berhasil login'}),
        );
      } else {
        var jsonObject = json.decode(apiResult.body);
        print(jsonObject);
        // other failed
        return AuthModel(
          error: true,
          data: jsonEncode({"message": 'Gagal login'}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AuthModel(
        error: true,
        data: jsonEncode({"message": 'error'}),
      );
    }
  }

  static Future<AuthModel> register(String email, String name, String username,
      String password, String password_) async {
    String apiURL = globalBaseUrl + globalPathAuth + "register";

    print(apiURL);

    try {
      var apiResult = await http.post(
        apiURL,
        body: {
          'email': email,
          'name': name,
          'username': username,
          'password': password,
          'password_confirmation': password_,
        },
        headers: {
          "Accept": "application/json",
        },
      );

      print('register status code : ' + apiResult.statusCode.toString());
      var jsonObject = json.decode(apiResult.body);
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        await GeneralModel.setToken(jsonObject['data']['token']);

        return AuthModel(
          error: false,
          data: jsonEncode({"message": 'berhasil register'}),
        );
      } else if (apiResult.statusCode == 422) {
        return AuthModel(
          error: true,
          data: jsonEncode({
            "message": jsonObject['data']['message'],
            'revisi': true,
          }),
        );
      } else {
        print(jsonObject);
        // other failed
        return AuthModel(
          error: true,
          data: jsonEncode({"message": 'Gagal register'}),
        );
      }
    } catch (e) {
      print('error catch');
      print(e.toString());
      return AuthModel(
        error: true,
        data: jsonEncode({"message": 'error'}),
      );
    }
  }
}
