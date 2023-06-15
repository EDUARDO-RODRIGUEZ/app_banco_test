import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/provider/auth_provider.dart';
import 'package:app_banco/screen/home/home_screen.dart';
import 'package:app_banco/service/auth_service.dart';
import 'package:app_banco/widget/text_container_rounded.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/auth/login";
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ciController = TextEditingController(text: "12345678SC");
  final _passwordController = TextEditingController(text: "123");
  String error = "";

  @override
  Widget build(BuildContext context) {

    const titleCard = Text("Login",
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: AppColors.themeSelect));

    var fieldUserName = TextField(
      controller: _ciController,
      decoration: const InputDecoration(
          hintText: "username",
          icon: Icon(Ionicons.person, color: AppColors.themeSelect),
          border: InputBorder.none),
    );

    var fieldPassword = TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
          hintText: "password",
          icon: Icon(Ionicons.lock_closed, color: AppColors.themeSelect),
          border: InputBorder.none),
      obscureText: true,
    );

    final contentLogin = BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.white);

    var btnLogin = TextButton(
        child: const Text("LOGIN", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          var login = await AuthService.login(
              _ciController.text, _passwordController.text);
          if (login == null) {
            setState(() {
              error = "Datos Invalidos";
            });
            return;
          }
          if (!login.ok) {
            setState(() {
              error = "Datos Invalidos";
            });
            return;
          }
          AuthProvider.token = login.data.cliente.token;
          AuthProvider.nombre = login.data.cliente.nombre;
          AuthProvider.apellido = login.data.cliente.apellido;
          AuthProvider.ci = login.data.cliente.ci;
          Navigator.pushReplacementNamed(context, HomeScreen.route);
        });

    return Scaffold(
      backgroundColor: AppColors.themeBackground,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(20),
          decoration: contentLogin,
          child: Column(children: [
            titleCard,
            TextContainerRounded(
                color: AppColors.themeBackground, child: fieldUserName),
            TextContainerRounded(
                color: AppColors.themeBackground, child: fieldPassword),
            Text("$error", style: TextStyle(color: Colors.red.shade400)),
            TextContainerRounded(
                color: AppColors.themeSelect,
                child: SizedBox(width: double.infinity, child: btnLogin))
          ]),
        ),
      ),
    );
  }
}
