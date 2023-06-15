import 'dart:convert';

import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/dto/request/deposito_dto_request.dart';
import 'package:app_banco/dto/request/retiro_dto_request.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/service/cliente_service.dart';
import 'package:app_banco/service/movimiento_service.dart';
import 'package:app_banco/widget/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/quickalert.dart';

class ChargeQrScreen extends StatefulWidget {
  static const String route = "/pagar/qr";
  const ChargeQrScreen({super.key});

  @override
  State<ChargeQrScreen> createState() => _ChargeQrScreenState();
}

class _ChargeQrScreenState extends State<ChargeQrScreen> {
  String nro = "";
  String password = "123";
  double monto = 0;
  String error = "";
  String? valueChoose;
  Cuenta? cuentaSelected;
  List<Cuenta> cuentas = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void scannerQr() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#8db5e0", "Cancelar", false, ScanMode.QR);
    if (barcodeScanRes == "-1") {
      print("Cancel Scanner");
      return;
    }
    print("Dectecto QR $barcodeScanRes");
    if (!barcodeScanRes.contains("{")) {
      print("Error al decodificar el qr intentelo de nuevo!!!");
    }
    final dataqr = jsonDecode(barcodeScanRes);
    setState(() {
      nro = dataqr["nro"];
      monto = double.parse(dataqr["monto"]);
    });
  }

  void initData() async {
    cuentas = await ClienteService.getClientAccount();
    setState(() {});
  }

  Cuenta getCuenta(String nro) {
    return cuentas.firstWhere((element) => element.nro == nro);
  }

  void RealizarCobro() async {
    String nroDeposito = cuentaSelected?.nro ?? "";
    if (nroDeposito.isEmpty) {
      setState(() {
        error = "Seleccione una cuenta";
      });
      return;
    }
    if (nro.isEmpty || password.isEmpty || monto < 0 || nroDeposito.isEmpty) {
      setState(() {
        error = "Datos no validos revise los datos";
      });
      return;
    }
    bool depositoCorrect = await MovimientoService.realizarDeposito(DepositoDtoRequest(
        nroAccount: nroDeposito,
        monto: monto
    ));
    //Data QR
    bool retiroCorrect = await MovimientoService.realizarRetiro(RetiroDtoRequest(
      nroAccount: nro, 
      password: password, 
      monto: monto
    ));
    setState(() {
        error = "";
    });
    if(!depositoCorrect || !retiroCorrect){
      QuickAlert.show(context: context, type: QuickAlertType.error,text: "No se pudo realizar el cobro !!!");
      return;
    }
   QuickAlert.show(context: context, type: QuickAlertType.success,text: "El cobro se realizo correctamnete !!!");
  }

  @override
  Widget build(BuildContext context) {
    const textStyleTitle = TextStyle(
        fontWeight: FontWeight.bold, color: AppColors.Text, fontSize: 20);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Cobrar Qr"),
          centerTitle: true,
          backgroundColor: AppColors.themeSelect),
      body: ListView(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        children: [
          const Text("Mis Cuentas", style: textStyleTitle),
          ListTileCustom(
              iconData: Icons.add_card_sharp,
              info: 'Nro',
              widget: DropdownButton(
                value: valueChoose,
                hint: Text("Selecciona una Cuenta"),
                isExpanded: true,
                items: cuentas
                    .map((item) => DropdownMenuItem(
                        child: Text(item.nro), value: item.nro))
                    .toList(),
                onChanged: (value) {
                  cuentaSelected = getCuenta(value.toString());
                  valueChoose = value.toString();
                  setState(() {});
                },
              )),
          ExpansionTile(
            title: const Text("Detalle de la cuenta"),
            children: [
              ListTile(
                  title: const Text("Nro"),
                  subtitle: Text(cuentaSelected?.nro ?? "")),
              ListTile(
                  title: const Text("Banco"),
                  subtitle: Text(cuentaSelected?.banco ?? "")),
              ListTile(
                  title: const Text("TipoCuenta"),
                  subtitle: Text(cuentaSelected?.tipoCuenta ?? "")),
              ListTile(
                  title: const Text("Saldo"),
                  subtitle: Text(cuentaSelected?.saldo.toString() ?? "")),
            ],
          ),
          ElevatedButton(
              onPressed: scannerQr,
              child: Text("Scanner QR"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.themeSelect)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            alignment: Alignment.center,
            child:
                Text("${error}", style: TextStyle(color: Colors.red.shade400)),
          ),
          ElevatedButton(
              onPressed: RealizarCobro,
              child: Text("Realizar Cobro"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.themeSelect))
        ],
      ),
    );
  }
}
