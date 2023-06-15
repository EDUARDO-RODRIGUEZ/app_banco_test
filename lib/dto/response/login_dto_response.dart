import 'dart:convert';

LoginDtoResponse loginDtoResponseFromJson(String str) => LoginDtoResponse.fromJson(json.decode(str));
String loginDtoResponseToJson(LoginDtoResponse data) => json.encode(data.toJson());

class LoginDtoResponse {
    bool ok;
    Data data;
    dynamic message;
    dynamic errors;

    LoginDtoResponse({
        required this.ok,
        required this.data,
        this.message,
        this.errors,
    });

    factory LoginDtoResponse.fromJson(Map<String, dynamic> json) => LoginDtoResponse(
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
    Cliente cliente;

    Data({
        required this.cliente,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cliente: Cliente.fromJson(json["cliente"]),
    );

    Map<String, dynamic> toJson() => {
        "cliente": cliente.toJson(),
    };
}

class Cliente {
    String ci;
    String apellido;
    String nombre;
    String token;

    Cliente({
        required this.ci,
        required this.apellido,
        required this.nombre,
        required this.token,
    });

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        ci: json["ci"],
        apellido: json["apellido"],
        nombre: json["nombre"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ci": ci,
        "apellido": apellido,
        "nombre": nombre,
        "token": token,
    };
}
