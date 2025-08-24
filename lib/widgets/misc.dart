import 'package:flutter/material.dart';

void displaySnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = const Color.fromRGBO(55, 255, 72, 0.6),
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 5),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message, style: TextStyle(color: textColor))),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}

Color hexToColor(String hexCode) {
  final buffer = StringBuffer();
  if (hexCode.startsWith('#')) hexCode = hexCode.substring(1);
  if (hexCode.length == 6) buffer.write('ff');
  buffer.write(hexCode.toUpperCase());
  return Color(int.parse(buffer.toString(), radix: 16));
}
