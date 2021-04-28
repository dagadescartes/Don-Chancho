import 'package:demo_diego_lechona/UI/Pages/Administrador/Admin.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Login.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Register.dart';
import 'package:demo_diego_lechona/UI/Pages/Chef/Cocina.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Repartidor.dart'; 
import 'package:demo_diego_lechona/UI/Pages/Vendedor/Vendedor.dart';
import 'package:flutter/material.dart';

final Map <String, WidgetBuilder> routes = {   
    'Administrador': (BuildContext context) => Admin(),
    'Vendedor'     : (BuildContext context) => Vendedor(),
    'Login'        : (BuildContext context) => Login(),
    'Register'     : (BuildContext context) => Register(),
    'Domiciliario' : (BuildContext context) => Repartidor(),
    'Cocina'       : (BuildContext context) => Cocina()
};
