import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    Key key,
    this.text,
    this.iconos, this.go,
  }) : super(key: key);
  final String text;
  final Function go;
  final IconData iconos;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
        elevation: 0.5,
        color: kColorWhite,
        child: Padding(
          padding: const EdgeInsets.only(left: kPaddinDefaulHorizontal),
          child: Row(
            children: [
              Icon(
                iconos,
                size: 27,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        onPressed: go);
  }
}
