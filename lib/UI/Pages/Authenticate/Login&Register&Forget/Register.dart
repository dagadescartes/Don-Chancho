import 'package:demo_diego_lechona/Control.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Backphoto.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Bottom.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/TextFiedDemo.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _RegisterState extends State<Register> {
  List cargos = ['Administrador', 'Vendedor', 'Cocina', 'Domiciliario'];
  String cargoval, fullName, telefono, email, password;
  final _formKey = GlobalKey<FormState>();
  String direccion;
  String error = '', go = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBlack,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Backphoto(),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Logo(
                    kheight: 150,
                    kwidth: 150,
                  ),
                  SizedBox(
                    height: kPaddinDefaulVertical * 4,
                  ),
                  TextFiedDemo(
                    validate: (value) =>
                        value.isEmpty ? 'Ingrese su nombre' : null,
                    valor: (value) {
                      setState(() {
                        fullName = value;
                      });
                    },
                    tipo: 'Nombre',
                    obscurecer: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFiedDemo(
                    validate: (value) =>
                        value.isEmpty ? 'Ingrese su numero movil' : null,
                    valor: (value) {
                      setState(() {
                        telefono = value;
                      });
                    },
                    obscurecer: false,
                    tipo: 'Telefono',
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFiedDemo(
                    validate: (value) =>
                        value.isEmpty ? 'Ingrese su correo' : null,
                    valor: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    tipo: 'Correo',
                    obscurecer: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFiedDemo(
                    validate: (value) =>
                        value.isEmpty ? 'Ingrese su direccion' : null,
                    valor: (value) {
                      setState(() {
                        direccion = value;
                      });
                    },
                    tipo: 'Direccion',
                    obscurecer: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFiedDemo(
                    helper: 'Ingrese una contraseña segura',
                    validate: (value) => value.length < 6
                        ? 'Ingrese una contraseña con longitud mayor a 6'
                        : null,
                    valor: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    tipo: 'Contraseña',
                    obscurecer: false,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  DropdownButton(
                    dropdownColor: kColorBlack,
                    onChanged: (value) {
                      setState(() {
                        cargoval = value;
                      });
                    },
                    style: TextStyle(color: kColorWhite),
                    hint: Text(
                      'Cargo',
                      style: TextStyle(color: kColorWhite),
                    ),
                    value: cargoval,
                    items: cargos.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Bottom(
                      texto: 'Registrar',
                      colorBottom: kColorBlack,
                      colorText: kColorWhite,
                      ir: () async {
                        print(email);
                        print(password);
                        print(fullName);
                        print(cargoval);
                        print(telefono);
                        print(direccion);
                        dynamic result = await AuthService()
                            .registerWithEmailAndPassword(email, password,
                                fullName, cargoval, telefono, direccion);
                        if (result == false) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Oh! Hemos tenido un problema'),
                                content: Text(
                                    'No hemos podido terminar el registro'),
                              );
                            },
                          );
                        } else {
                          CircularProgressIndicator();
                          Future.delayed(
                              Duration(seconds: 3),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Control())));
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    error,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  Text(
                    go,
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
