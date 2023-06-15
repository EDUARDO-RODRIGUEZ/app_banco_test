import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/dto/request/deposito_dto_request.dart';
import 'package:app_banco/dto/request/retiro_dto_request.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/service/cliente_service.dart';
import 'package:app_banco/service/movimiento_service.dart';
import 'package:app_banco/widget/list_tile_custom.dart';
import 'package:app_banco/widget/text_field_color.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ChargeScreen extends StatefulWidget {
  static const route = "/charge";
  const ChargeScreen({super.key});
  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  TextEditingController nro = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController monto = TextEditingController(text: "0");
  String? valueChoose;
  Cuenta? cuentaSelected;
  List<Cuenta> cuentas = [];
  @override
  void initState() {
    super.initState();
    initData();
  }
  void initData() async {
    cuentas = await ClienteService.getClientAccount();
    setState(() {});
  }
  Cuenta getCuenta(String nro) {
    return cuentas.firstWhere((element) => element.nro == nro);
  }
  void changeDropdown(value){
    cuentaSelected = getCuenta(value.toString());
    valueChoose = value.toString();
    setState(() {});
  }
  void realizarCobro()async{
    String nroCuentaDestino = cuentaSelected?.nro??"";
    if(nroCuentaDestino.isEmpty){
      return QuickAlert.show(context: context,type: QuickAlertType.warning,text: "Seleccione una cuenta");
    }
    bool depositoCorrect = await MovimientoService.realizarDeposito(DepositoDtoRequest(nroAccount: nroCuentaDestino, monto: double.parse( monto.text )));
    bool retiroCorrect  = await MovimientoService.realizarRetiro(RetiroDtoRequest(nroAccount: nro.text, password: password.text, monto: double.parse( monto.text )));
    if(!depositoCorrect || !retiroCorrect){
      return QuickAlert.show(context: context,type: QuickAlertType.warning,text: "EL cobro no se pudo realizar verique los datos");
    }
    nro.clear();
    password.clear();
    monto.clear();
    return QuickAlert.show(context: context,type: QuickAlertType.success,text: "Pago Realizado Correctamente");
  }

  @override
  Widget build(BuildContext context) {
    
    const textStyleTitle = TextStyle(fontWeight: FontWeight.bold, color: AppColors.Text, fontSize: 20);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cobro"),
        backgroundColor: AppColors.themeSelect,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        children: [
           const Text("Cuenta Origen", style: textStyleTitle),
           ListTileCustom(
              iconData: Icons.add_card_sharp,
              info: 'Nro',
              widget: TextFieldColor(
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  color: AppColors.themeSelect,
                  textController: nro,
                  onChanged: null
              )
            ),
            ListTileCustom(
              iconData: Icons.lock,
              info: 'Password',
              widget: TextFieldColor(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  color: AppColors.themeSelect,
                  textController: password,
                  onChanged: null
              )
            ),
            ListTileCustom(
              iconData: Icons.monetization_on_outlined,
              info: 'monto',
              widget: TextFieldColor(
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  color: AppColors.themeSelect,
                  textController: monto,
                  onChanged: null
              )
            ),
            const Divider(thickness: 1),
            const Text("Cuenta Destino", style: textStyleTitle),
            ListTileCustom(
              iconData: Icons.add_card_sharp,
              info: 'Nro',
              widget: DropdownButton(
                value: valueChoose,
                hint: const Text("Selecciona una Cuenta"),
                isExpanded: true,
                items: cuentas.map((item) => DropdownMenuItem(child: Text(item.nro), value: item.nro)).toList(),
                onChanged: changeDropdown,
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
                ]
          ),
          ElevatedButton(
            child: Text("Realizar Cobro"),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.themeSelect),
            onPressed: realizarCobro
          )
        ],
      ),
    );
  }
}
