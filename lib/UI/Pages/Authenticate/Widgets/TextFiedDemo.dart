import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:flutter/material.dart';

class TextFiedDemo extends StatelessWidget {
  const TextFiedDemo({
    Key key,
    this.tipo,
    this.helper,
    this.obscurecer,
    this.valor,
    this.validate,
    this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String tipo;
  final String helper;
  final bool obscurecer;
  final Function valor;
  final Function validate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddinDefaulHorizontal * 1.8,
      ),
      child: TextFormField(
        controller: controller,
        validator: validate,
        onChanged: valor,
        //textInputAction: TextInputAction.search.,
        style: TextStyle(color: kColorWhite),
        obscureText: obscurecer,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: kColorWhite),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Color(0xffFFFFFF),
              style: BorderStyle.solid,
            ),
          ),
          labelText: tipo,
          labelStyle: TextStyle(color: kColorWhite),
          helperText: helper,
          helperStyle: TextStyle(color: kColorWhite),
        ),
      ),
    );
  }
}
