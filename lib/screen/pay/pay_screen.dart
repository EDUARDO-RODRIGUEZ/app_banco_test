import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/dto/request/deposito_dto_request.dart';
import 'package:app_banco/dto/request/retiro_dto_request.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/service/cliente_service.dart';
import 'package:app_banco/service/movimiento_service.dart';
import 'package:app_banco/widget/list_tile_custom.dart';
import 'package:app_banco/widget/text_button_color.dart';
import 'package:app_banco/widget/text_field_color.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class PayScreen extends StatefulWidget {
  static const String route = "/pay";
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final TextEditingController passwordController = TextEditingController(text: "");
  final TextEditingController nroController = TextEditingController(text: "");
  final TextEditingController montoController = TextEditingController(text: "0");

  String? valueChoose;
  Cuenta? cuentaSelected;
  List<Cuenta> cuentas = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() async {
    cuentas = await ClienteService.getClientAccount();
    setState(() {});
  }

  Cuenta getCuenta(String nro) {
    return cuentas.firstWhere((element) => element.nro == nro);
  }

  void realizarPago() async {
    double monto = double.parse(montoController.text);
    double saldo = cuentaSelected?.saldo.toDouble() ?? 0;
    String nroCuentaOrigen = cuentaSelected?.nro ?? "";
    if (nroCuentaOrigen.isEmpty) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: "Seleccione una cuenta");
      return;
    }
    if (saldo < monto) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: "Saldo Insuficiente");
      return;
    }
    bool depositoCorrect = await MovimientoService.realizarDeposito(DepositoDtoRequest(
        nroAccount: nroController.text,
        monto: monto
    ));
    bool retiroCorrect = await MovimientoService.realizarRetiro(RetiroDtoRequest(
      nroAccount: nroCuentaOrigen, 
      password: passwordController.text, 
      monto: monto
    ));
    if(!depositoCorrect || !retiroCorrect){
      QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: "EL pago no se pudo realizar verique los datos"
      ); 
      return; 
    }
    passwordController.clear();
    montoController.clear();
    return QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Pago Realizado Correctamente"
    ); 
  }

  @override
  Widget build(BuildContext context) {
    const textStyleTitle = TextStyle(
        fontWeight: FontWeight.bold, color: AppColors.Text, fontSize: 20);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Pago"),
          centerTitle: true,
          backgroundColor: AppColors.themeSelect),
      body: ListView(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        children: [
          const Text("Cuenta Origen", style: textStyleTitle),
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
          ListTileCustom(
              iconData: Icons.lock,
              info: 'Password',
              widget: TextFieldColor(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  color: AppColors.themeSelect,
                  textController: passwordController,
                  onChanged: null
            )
          ),
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
          const Divider(thickness: 1),
          const Text("Cuenta Destino", style: textStyleTitle),
          ListTileCustom(
              iconData: Icons.add_card_sharp,
              widget: TextFieldColor(
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  color: AppColors.themeSelect,
                  textController: nroController,
                  onChanged: null),
              info: 'Nro cuenta'),
          const Divider(thickness: 1),
          ListTileCustom(
              iconData: Icons.monetization_on_outlined,
              info: 'monto',
              widget: TextFieldColor(
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  color: AppColors.themeSelect,
                  textController: montoController,
                  onChanged: null)),
          TextButtonColor(
            color: AppColors.themeSelect,
            text: "Realizar Pago",
            onPressed: realizarPago,
          )
        ],
      ),
    );
  }
}
