import 'package:demo_diego_lechona/Control.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Perfil/Profile.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/DrawerItems.dart';
import 'package:demo_diego_lechona/UI/Pages/Chef/ChefPedidos.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';

class Cocina extends StatefulWidget {
  Cocina({Key key}) : super(key: key);

  @override
  _CocinaState createState() => _CocinaState();
}

class _CocinaState extends State<Cocina> {
  @override
  Widget build(BuildContext context) {
    BlocOtherRepository _repository = BlocOtherRepository();
    AuthService _auth = AuthService();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chef',
                      style: TextStyle(color: kColorBlack, fontSize: 24),
                    ),
                    Text(
                      '',
                      style: TextStyle(color: kColorBlack, fontSize: 18),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kColorOrange, kColorBlack],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      stops: [0.7, 1.0])),
            ),
            DrawerItems(
                text: 'Inicio',
                iconos: Icons.home,
                go: () {
                  Navigator.of(context).pop();
                }),
            DrawerItems(
                text: 'Pedidos',
                iconos: Icons.shopping_bag,
                go: () async {
                  final resp2 = await RepositoryAlterno().getpedidoschefnow();
                  final resp = await RepositoryAlterno().getTimeNow();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChefPedidos(
                                db: resp,
                                dbc: resp2,
                              )));
                }),
            DrawerItems(
                text: 'Perfil',
                iconos: Icons.person,
                go: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                }),
            DrawerItems(
                text: 'Salir',
                iconos: Icons.exit_to_app_sharp,
                go: () async {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Control(),
                      ),
                      (route) => false);
                })
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Chef Activo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
