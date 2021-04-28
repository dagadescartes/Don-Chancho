import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({
    Key key,
    this.orderText,
    this.press,
    this.ordernumber,
  }) : super(key: key);
  final String orderText;
  final Function press;
  final int ordernumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          orderText,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xffD1D6DE)),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            height: 50,
            width: 80,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(0xffFB6E53),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: press,
              child: Text(
                ('$ordernumber'),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: kColorWhite),
              ),
            ))
      ],
    );
  }
}
