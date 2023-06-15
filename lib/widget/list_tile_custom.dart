import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final IconData iconData;
  final Widget widget;
  final String info;
  const ListTileCustom({
    super.key,
    required this.iconData,
    required this.widget,
    required this.info
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(iconData),
        title: widget,
        subtitle: Text(info),
      );
  }
}

