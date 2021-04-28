import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
    this.kheight,
    this.kwidth,
  }) : super(key: key);
  final double kheight, kwidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kheight,
      width: kwidth,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
