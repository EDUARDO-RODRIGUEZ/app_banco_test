import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/screen/account/account_screen.dart';
import 'package:app_banco/screen/charge/charge_screen.dart';
import 'package:app_banco/screen/chargeQr/charge_qr_screen.dart';
import 'package:app_banco/screen/pay/pay_screen.dart';
import 'package:app_banco/screen/payQr/pay_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatelessWidget {
  static const String route = "/home";
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banco Distribuidos"),
        centerTitle: true,
        backgroundColor: AppColors.themeSelect,
      ),
      body: ListView(
            padding: EdgeInsets.zero,
            children:[ 
                SizedBox( height: 20),
                Container(
                  child: Text("Servicios",textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                ),
                 SizedBox( height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30,
                    children: const [
                      Card(title: "Pagar",background: AppColors.themeSelect,iconData: Icons.payment,route:PayScreen.route),
                      Card(title: "Cobrar",background: AppColors.themeSelect,iconData: Icons.monetization_on_outlined,route: ChargeScreen.route),
                      Card(title: "Cuentas",background: AppColors.themeSelect,iconData: Icons.account_balance,route: AccountScreen.route),
                      Card(title: "Movimientos",background: AppColors.themeSelect,iconData: Ionicons.list,route: ""),
                      Card(title: "Pagar Qr",background: AppColors.themeSelect,iconData: Ionicons.qr_code,route: PayQrScreen.route),
                      Card(title: "Cobrar Qr",background: AppColors.themeSelect,iconData: Ionicons.scan,route: ChargeQrScreen.route),
                    ],
                  )
                )
            ]
          )
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color background;
  final String route;
  
  const Card({super.key,required this.title, required this.iconData,  required this.background, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Colors.black.withOpacity(.3),
              spreadRadius: 3,
              blurRadius: 2
            )
          ]
        ),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration( 
                color: background,
                shape: BoxShape.circle
              ),
              child: Icon(iconData,color: Colors.white,size: 40),
            ),
            const SizedBox(height: 8),
            Text(title)
           ],
        ),
      ),
    );
  }
}