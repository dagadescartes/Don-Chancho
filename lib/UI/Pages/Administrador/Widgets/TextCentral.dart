import 'package:flutter/material.dart';

class TextCentral extends StatelessWidget {
  final String texto;
  const TextCentral({
    Key key, this.texto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
          fontSize: 25, fontWeight: FontWeight.w700, color: Color(0xff787878)),
    );
  }
}