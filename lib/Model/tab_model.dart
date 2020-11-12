import 'dart:convert';
//import 'dart:developer';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undangi/Constant/note.dart';

String tokenFixed = '';
String userData = '';

_setCount(Map count) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('countHome', jsonEncode(count));
}

_destroyToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String tokenFixed = prefs.getString('token');

  if (tokenFixed != null) {
    await prefs.remove("token");
    await prefs.remove("dataUser");
  }
}

_getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  tokenFixed = prefs.getString('token');
  //  prefs.getString('token');
}

class tabModel {
  bool error;
  Map data;

  tabModel({
    this.error,
    this.data,
  });

  factory tabModel.loopJson(Map<String, dynamic> object) {
    return tabModel(
      error: object['error'],
      data: object['data'],
    );
  }

  static Future<tabModel> homeCount() async {
    // final LocalStorage storage = new LocalStorage('auth');
    String apiURL = globalBaseUrl +  "home";

    var apiResult = await http.get(apiURL,
       
        headers: {"Accept": "application/json"});

    print('homeCount status code : ' + apiResult.statusCode.toString());

    try {
      if (apiResult.statusCode == 201 || apiResult.statusCode == 200) {
        Map jsonObject = json.decode(apiResult.body);
        Map a;

      


        _setCount(jsonObject['data']);
        return tabModel(
          error: false,
          data: jsonObject['data'],
        );
      } 
    } catch (e) {
      print('error catch');
      print(e);
      
    }
  }

  }
