import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_banco/const/app_colors.dart';
import 'package:app_banco/dto/response/client_account_dto_response.dart';
import 'package:app_banco/service/cliente_service.dart';
import 'package:app_banco/widget/list_tile_custom.dart';
import 'package:app_banco/widget/text_field_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class PayQrScreen extends StatefulWidget {
  static const String route = "/cobrar/qr";
  const PayQrScreen({super.key});
  @override
  State<PayQrScreen> createState() => _PayQrScreenState();
}

class _PayQrScreenState extends State<PayQrScreen> {
  TextEditingController monto = TextEditingController(text: "0");
  String? valueChoose;
  Cuenta? cuentaSelected;
  List<Cuenta> cuentas = [];
  Map<String, String> data = {"nro": "", "monto": ""};
  GlobalKey globalKey = GlobalKey();
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

  void updateDataQr() {
    data["nro"] = valueChoose ?? "";
    data["monto"] = monto.text;
  }

  void saveQr() async {
    var res = await Permission.storage.request();
    if (res.isGranted) {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if(byteData!=null){
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),quality: 60, name: "${DateTime.now()}");
          QuickAlert.show(context: context, type: QuickAlertType.success,text: "El qr se guardo correctamente !!!");
          return;
      }
    }
    QuickAlert.show(context: context, type: QuickAlertType.warning,text: "Error al guardar la Imagen !!!");
  }

  void compartirQr()async{
     var res = await Permission.storage.request();
    if (res.isGranted) {
       final String? res = await capturePng();
       if (res != null) {
          await Share.shareFiles(
            [res],
            mimeTypes: ["image/png"],
            text: 'qr_generado',
          );
          return;
      }
    }
    QuickAlert.show(context: context, type: QuickAlertType.warning,text: "Error al guardar la Imagen !!!");
  }


  Future<String?> capturePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if(byteData!=null){
          Uint8List pngBytes = byteData.buffer.asUint8List();
          final appDir = await getApplicationDocumentsDirectory();
          var datetime = DateTime.now();
          final file = await File('${appDir.path}/$datetime.png').create();
          await file.writeAsBytes(pngBytes);
          return file.path;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyleTitle = TextStyle(
        fontWeight: FontWeight.bold, color: AppColors.Text, fontSize: 20);

    return Scaffold(
        appBar: AppBar(
            title: const Text("Pagar Qr"),
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
                  hint: const Text("Selecciona una Cuenta"),
                  isExpanded: true,
                  items: cuentas
                      .map((item) => DropdownMenuItem(
                          child: Text(item.nro), value: item.nro))
                      .toList(),
                  onChanged: (value) {
                    cuentaSelected = getCuenta(value.toString());
                    valueChoose = value.toString();
                    updateDataQr();
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
            ListTileCustom(
                iconData: Icons.monetization_on_outlined,
                info: 'monto',
                widget: TextFieldColor(
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  color: AppColors.themeSelect,
                  textController: monto,
                  onChanged: (String value) {
                    updateDataQr();
                    setState(() {});
                  },
                )),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: RepaintBoundary(
                key: globalKey,
                child: QrImageView(
                  data: jsonEncode(data),
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: saveQr,
                child: Text("Guardar Qr"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeSelect)
            ),
            ElevatedButton(
                onPressed: compartirQr,
                child: Text("Compartir Qr"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeSelect)
            ),
          ],
        ));
  }
}
