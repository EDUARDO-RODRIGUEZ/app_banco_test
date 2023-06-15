import 'dart:convert';

import 'package:app_banco/const/app_config.dart';
import 'package:app_banco/dto/response/login_dto_response.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static String log = "AuthService";

  static Future<LoginDtoResponse?> login(String ci, String password) async {
    var url = Uri.parse("${AppConfig.baseUrl}/auth/login");
    Map body = {"ci": ci, "password": password};
    print("login");
    print(body);
    try {
      var response = await http.post(url, body: jsonEncode(body), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      });
      if(response.statusCode == 403){
        return null;
      }
      LoginDtoResponse loginDtoResponse = loginDtoResponseFromJson(response.body);
      return loginDtoResponse;
    } catch (error) {
      print("${AuthService.log} : $error");
      return null;
    }
  }
}
