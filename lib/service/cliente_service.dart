import 'package:app_banco/const/app_config.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class ClienteService {
  static String log = "ClienteService";
  static Future<List<Cuenta>> getClientAccount() async {
    var url = Uri.parse("${AppConfig.baseUrl}/cliente/cuentas/${AuthProvider.ci}");
    var header = {
      ...?AppConfig.header,
      "Authorization": "Bearer ${AuthProvider.token}",
    };
    try {
      var response = await http.get(url, headers: header);
      if (response.statusCode == 403) {
        return [];
      }
      var responsebBody = clientAccountDtoResponseFromJson(response.body);
      return responsebBody.data.cuentas;
    } catch (e) {
      print(" ${ClienteService.log} : ${e}");
      return [];
    }
  }
}
