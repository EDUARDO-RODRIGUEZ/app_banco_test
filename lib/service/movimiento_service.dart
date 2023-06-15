import 'dart:convert';

import 'package:app_banco/const/app_config.dart';
import 'package:app_banco/dto/request/deposito_dto_request.dart';
import 'package:app_banco/dto/request/retiro_dto_request.dart';
import 'package:app_banco/dto/response/deposito_dto_response.dart';
import 'package:app_banco/dto/response/retiro_dto_response.dart';
import 'package:app_banco/provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class MovimientoService {
  static const log = "MovimientoService";

  static Future<bool> realizarDeposito(
      DepositoDtoRequest depositoDtoRequest) async {
    var url = Uri.parse("${AppConfig.baseUrl}/movimiento/deposito");
    var headers = {
      ...?AppConfig.header,
      "Authorization": "Bearer ${AuthProvider.token}"
    };
    var body = { "nroAccount":depositoDtoRequest.nroAccount,"monto":depositoDtoRequest.monto};
    try {
      var response = await http.post(url, headers: headers,body: jsonEncode(body));
      if (response.statusCode == 403) return false;
      var depositoResponse = depositoDtoResponseFromJson(response.body);
      return depositoResponse.ok;
    } catch (e) {
      print("${MovimientoService.log} : ${e}");
      return false;
    }
  }

  static Future<bool> realizarRetiro(RetiroDtoRequest retiroDtoRequest) async {
    var url = Uri.parse("${AppConfig.baseUrl}/movimiento/retiro");
    var headers = {
      ...?AppConfig.header,
      "Authorization": "Bearer ${AuthProvider.token}"
    };
    var body={"nroAccount":retiroDtoRequest.nroAccount,"passwordAccount":retiroDtoRequest.password,"monto":retiroDtoRequest.monto};
    try {
      var response = await http.post(url, headers: headers,body:jsonEncode(body));
      if (response.statusCode == 403) return false;
      var retiroResponse = retiroDtoResponseFromJson(response.body);
      return retiroResponse.ok;
    } catch (e) {
      print("${MovimientoService.log} : ${e}");
      return false;
    }
  }
}
