import 'dart:ui';

import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Forgetpassword.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Register.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Backphoto.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Bottom.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/TextFiedDemo.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:demo_diego_lechona/UI/Pages/Routes/Routes.dart';

import '../../../../data/Repository/auth.dart';
import '../../Routes/Routes.dart';
import '../Widgets/Logo.dart';
import '../Widgets/TextFiedDemo.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List cargos = ['Administrador', 'Vendedor', 'Cocina', 'Domiciliario'];
  String dropdownValue;

  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBlack,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              padding: EdgeInsets.only(top: 25),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fondo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Logo(),
                const SizedBox(height: 15),
                TextFiedDemo(
                  controller: email,
                  obscurecer: false,
                  tipo: 'Correo',
                  helper: 'email@example.com',
                ),
                const SizedBox(height: 15),
                TextFiedDemo(
                  controller: password,
                  obscurecer: true,
                  tipo: 'Contrasena',
                  helper: '************',
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: DropdownButton(
                    dropdownColor: kColorBlack,
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                    style: TextStyle(color: kColorWhite),
                    hint: Text(
                      'Cargo',
                      style: TextStyle(color: kColorWhite),
                    ),
                    value: dropdownValue,
                    items: cargos.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final response = await AuthService()
                            .singIn(
                          email: email.text,
                          password: password.text,
                          cargoval: dropdownValue,
                        )
                            .whenComplete(() {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        if (response != null) {
                          Navigator.pushReplacementNamed(context, dropdownValue,
                              arguments: routes);
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('Ocurrio un error'),
                                content: Text('Intentalo de nuevo mas tarde'),
                              );
                            },
                          );
                        }
                      },
                      child: isLoading == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Ingresar',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          )),
                      child: Text(
                        'Registrarse',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Forgetpassword(),
                      )),
                  child: Text(
                    'Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
