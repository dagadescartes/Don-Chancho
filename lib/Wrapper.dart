import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Login.dart';
import 'package:demo_diego_lechona/UI/Pages/Chef/Cocina.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Repartidor.dart';
import 'package:demo_diego_lechona/UI/Pages/Vendedor/Vendedor.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Admin.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = true;
  String _currentRol;

  @override
  void initState() {
    AuthService().getRole().then((rol) {
      setState(() {
        _currentRol = rol;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: render(),
    );
  }

  Widget render() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_currentRol != 'null') {
      switch (_currentRol) {
        case "/Vendedor":
          return Vendedor();
          break;
        case "/Administrador":
          return Admin();
          break;
        case '/Domiciliario':
          return Repartidor();
        case '/Cocina':
          return Cocina();
          break;
        default:
          return Login();
      }
    } else {
      return Login();
    }
  }
}
