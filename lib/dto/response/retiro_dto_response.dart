import 'dart:convert';

RetiroDtoResponse retiroDtoResponseFromJson(String str) =>
    RetiroDtoResponse.fromJson(json.decode(str));

String retiroDtoResponseToJson(RetiroDtoResponse data) =>
    json.encode(data.toJson());

class RetiroDtoResponse {
  bool ok;
  Data data;
  dynamic message;
  dynamic errors;

  RetiroDtoResponse({
    required this.ok,
    required this.data,
    this.message,
    this.errors,
  });

  factory RetiroDtoResponse.fromJson(Map<String, dynamic> json) =>
      RetiroDtoResponse(
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
  Movimiento movimiento;

  Data({
    required this.movimiento,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        movimiento: Movimiento.fromJson(json["movimiento"]),
      );

  Map<String, dynamic> toJson() => {
        "movimiento": movimiento.toJson(),
      };
}

class Movimiento {
  DateTime fecha;
  double monto;
  int id;
  String tipoMovimiento;

  Movimiento({
    required this.fecha,
    required this.monto,
    required this.id,
    required this.tipoMovimiento,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
        fecha: DateTime.parse(json["fecha"]),
        monto: json["monto"],
        id: json["id"],
        tipoMovimiento: json["tipoMovimiento"],
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha.toIso8601String(),
        "monto": monto,
        "id": id,
        "tipoMovimiento": tipoMovimiento,
      };
}
