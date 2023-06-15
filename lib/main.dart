import 'package:app_banco/screen/account/account_screen.dart';
import 'package:app_banco/screen/auth/login_screen.dart';
import 'package:app_banco/screen/charge/charge_screen.dart';
import 'package:app_banco/screen/chargeQr/charge_qr_screen.dart';
import 'package:app_banco/screen/home/home_screen.dart';
import 'package:app_banco/screen/pay/pay_screen.dart';
import 'package:app_banco/screen/payQr/pay_qr_screen.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  return runApp(
      const Main()
  );
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.route,
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.route: (ctx) => const LoginScreen(),
        HomeScreen.route: (ctx) => const HomeScreen(),
        PayScreen.route: (ctx) => const PayScreen(),
        ChargeScreen.route: (ctx) => const ChargeScreen(),
        AccountScreen.route: (ctx) => const AccountScreen(),
        PayQrScreen.route: (ctx) => const PayQrScreen(),
        ChargeQrScreen.route: (ctx) => const ChargeQrScreen(),
      },
    );
  }
}
