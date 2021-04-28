import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({
    Key key,
    this.texto,
    this.colorText,
    this.colorBottom,
    this.ir,
  }) : super(key: key);
  final String texto;
  final Color colorText, colorBottom;
  final Function ir;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 250,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: colorBottom,
        child: Text(
          texto,
          style: TextStyle(color: colorText),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: ir,
      ),
    );
  }
}
