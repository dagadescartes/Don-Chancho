import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Backphoto.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Bottom.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/TextFiedDemo.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:flutter/material.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({Key key}) : super(key: key);

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  // _getText() {
  //   _textFieldController.clear();
  // }

  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBlack,
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Backphoto(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Center(child: Logo(kheight: 200, kwidth: 200)),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: kPaddinDefaulHorizontal),
                      child: const Text(
                        'Ingrese su correo electronico con el cual se ha registrado, de esta manera le enviaremos las intrucciones para crear una nueva contraseña',
                        style: TextStyle(
                          fontSize: 18,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ),
                  TextFiedDemo(
                    controller: _textFieldController,
                    tipo: 'Email',
                    helper: 'Example@hotmail.com',
                    obscurecer: false,
                    validate: (value) =>
                        value.isEmpty ? 'Ingrese su correo' : null,
                  ),
                  SizedBox(height: 40),
                  Bottom(
                    texto: 'Enviar Correo',
                    colorBottom: kColorBlack,
                    colorText: kColorWhite,
                    ir: () async {
                      final response = await AuthService().recoverypassword(
                        email: _textFieldController.text,
                      );
                      if (response == true) {
                        return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Genial, ya esta hecho'),
                            content: Text(
                              'Ya puedes ir a tu correo y reestablecer tu contraseña',
                            ),
                          ),
                        );
                      } else {
                        return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Lo sentimos, justo ahora no podemos realizar esto',
                            ),
                            content: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
