
import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/service/cliente_service.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static const String route = "/account";
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
      const textStyleTitle = TextStyle(fontWeight: FontWeight.bold, color: AppColors.Text, fontSize: 20);
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Cuentas"),
        centerTitle: true,
        backgroundColor: AppColors.themeSelect,
      ),
      body:Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text("Listado de cuentas",style:textStyleTitle),
          ),
          FutureBuilder(
                future: ClienteService.getClientAccount(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {  
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(color: Colors.red));
                  }
                  if(snapshot.hasData){
                    return _ListCuenta(cuentas: snapshot.data);
                  }
                  return const Text("Empty List");
                }
          )
        ],
      )
    );
  }
}

class _ListCuenta extends StatelessWidget {
  final List<Cuenta> cuentas;
  const _ListCuenta({super.key,required this.cuentas});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: cuentas.length,
      itemBuilder: (BuildContext context, int index) {
        Cuenta cuenta = cuentas[index];
        return ExpansionTile(
          title: Text(cuenta.banco),
          children: [
           ListTile(
              title: const Text("Nro"),
              subtitle: Text(cuenta.nro),
           ),
           ListTile(
              title: const Text("TipoCuenta"),
              subtitle: Text(cuenta.tipoCuenta),
           ),
           ListTile(
              title: const Text("Saldo"),
              subtitle: Text("${cuenta.saldo}"),
           )
          ],
        );
      }
    );
  }
}