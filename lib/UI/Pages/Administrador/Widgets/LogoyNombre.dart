import 'package:flutter/material.dart';

class LogoyNombre extends StatelessWidget {
  const LogoyNombre({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'LECHONERIA\nDON CHANCHO',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Container(
            height: MediaQuery.of(context).size.width * .15,
            width: MediaQuery.of(context).size.width * .15,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            )),
          )
        ],
      ),
    );
  }
}
