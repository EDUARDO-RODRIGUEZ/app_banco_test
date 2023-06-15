import 'dart:convert';

ClientAccountDtoResponse clientAccountDtoResponseFromJson(String str) => ClientAccountDtoResponse.fromJson(json.decode(str));
String clientAccountDtoResponseToJson(ClientAccountDtoResponse data) => json.encode(data.toJson());

class ClientAccountDtoResponse {
    bool ok;
    Data data;
    String? message;
    dynamic errors;

    ClientAccountDtoResponse({
        required this.ok,
        required this.data,
        this.message,
        this.errors,
    });

    factory ClientAccountDtoResponse.fromJson(Map<String, dynamic> json) => ClientAccountDtoResponse(
        ok: json["ok"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        errors: json["errors"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "data": data.toJson(),
        "message": message,
        "errors": errors,
    };
}

class Data {
    List<Cuenta> cuentas;

    Data({
        required this.cuentas,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cuentas: List<Cuenta>.from(json["cuentas"].map((x) => Cuenta.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cuentas": List<dynamic>.from(cuentas.map((x) => x.toJson())),
    };
}

class Cuenta {
    String tipoCuenta;
    String banco;
    String nro;
    double saldo;

    Cuenta({
        required this.tipoCuenta,
        required this.banco,
        required this.nro,
        required this.saldo,
    });

    factory Cuenta.fromJson(Map<String, dynamic> json) => Cuenta(
        tipoCuenta: json["tipoCuenta"],
        banco: json["banco"],
        nro: json["nro"],
        saldo: json["saldo"],
    );

    Map<String, dynamic> toJson() => {
        "tipoCuenta": tipoCuenta,
        "banco": banco,
        "nro": nro,
        "saldo": saldo,
    };
}
