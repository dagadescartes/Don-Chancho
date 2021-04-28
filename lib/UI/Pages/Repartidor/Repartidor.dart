import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/Control.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/DrawerItems.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Pedidos/Entregado.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Pedidos/PedidosporPagar.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Pedidos/Pendiente.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Repartidor extends StatefulWidget {
  const Repartidor({Key key}) : super(key: key);

  @override
  _RepartidorState createState() => _RepartidorState();
}

class _RepartidorState extends State<Repartidor> {
  final streamProfile = StreamController<DocumentSnapshot>();
  BlocOtherRepository _repository = BlocOtherRepository();
  DocumentSnapshot currentProfile;
  String direccion, fullName, email;
  final controller = TextEditingController();
  RepositoryAlterno _alterno = RepositoryAlterno();
  bool isLoading = true;

  @override
  void initState() {
    _repository.getCredentialUser((userDocument) {
      setState(() {
        currentProfile = userDocument;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                        'Repartidor/a \n',
                        style: TextStyle(color: kColorBlack, fontSize: 18),
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
                  text: 'Pedidos Pendientes',
                  iconos: Icons.assignment_outlined,
                  go: () async {
                    dynamic now = DateTime.now();
                    print(now);
                    String format = DateFormat('yyyy-MM-dd HH:mm').format(now);
                    print(format);
                    final pedido = await _repository.pedidospendientes(format);
                    if (pedido != null) {
                      print('tenemos data');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pendiente(pedido: pedido),
                          ));
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Lo sentimos'),
                          content: Text(
                              'Tenemos problemas para conectar con el server'),
                        ),
                      );
                    }
                  }),
                  DrawerItems(
                  text: 'Pedidos por Cancelar',
                  iconos: Icons.assignment_outlined,
                  go: () async {
                    final pedido = await _alterno.pedidosporpagas();
                    if (pedido != null) {
                      print('tenemos data');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendienteporPago(data: pedido)
                          ));
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Lo sentimos'),
                          content: Text(
                              'Tenemos problemas para conectar con el server'),
                        ),
                      );
                    }
                  }),
              DrawerItems(
                  text: 'Pedidos Entregados',
                  iconos: Icons.assignment_turned_in,
                  go: () async {
                    final QuerySnapshot resp =
                        await _repository.getpedidosentregados();
                    if (resp != null) {
                      print('tenemos data');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Entregado(
                              data: resp,
                            ),
                          ));
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Lo sentimos'),
                          content: Text(
                              'Tenemos problemas para comunicarnos con el servidor'),
                        ),
                      );
                    }
                  }),
              DrawerItems(
                  text: 'Pedidos Rechazados',
                  iconos: Icons.assignment_late_rounded,
                  go: () async {
                    final QuerySnapshot resp =
                        await _repository.getpedidosrechazados();
                    if (resp != null) {
                      print('tenemos data');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Entregado(
                              data: resp,
                            ),
                          ));
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Lo sentimos'),
                          content: Text(
                              'Tenemos problemas para comunicarnos con el servidor'),
                        ),
                      );
                    }
                  }),
              DrawerItems(
                  text: 'Salir',
                  iconos: Icons.home,
                  go: () {
                    _auth.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Control()),
                        (route) => false);
                  }),
            ],
          ),
        ),
        appBar: AppBar(),
        body: StreamBuilder(
          stream: streamProfile.stream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return renderBody();
            }
            if (snapshot.hasData) {
              return renderData();
            }
            return null;
          },
        ));
  }

  Widget renderTitle(String text) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
    );
  }

  Widget renderSubtitle(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: kColorGray));
  }

  Widget renderBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Cargando Perfil ...")
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kPaddinDefaulHorizontal,
          vertical: kPaddinDefaulVertical * 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
          ),
          Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      '${currentProfile.data()['fullName']}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: renderTitle("${currentProfile.data()['role']}")),
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Logo(
                      kheight: 150,
                      kwidth: 150,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            children: [
              renderSubtitle('Telefono: ${currentProfile.data()['telefono']}'),
              GestureDetector(
                onTap: () {
                  print('Agregamos data');
                  streamProfile.add(currentProfile);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [Icon(Icons.edit), Text('Editar')],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          renderSubtitle('Correo: ${currentProfile.data()['email']}'),
          SizedBox(
            height: 20,
          ),
          renderSubtitle('Direccion: ${currentProfile.data()['direccion']}'),
        ],
      ),
    );
  }

  Widget renderData() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Cargando Perfil ...")
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kPaddinDefaulHorizontal,
          vertical: kPaddinDefaulVertical * 4),
      child: SingleChildScrollView(
        child: Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          '${currentProfile.data()['fullName']}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: renderTitle(
                                "${currentProfile.data()['role']}")),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Center(
                        child: Logo(
                          kheight: 150,
                          kwidth: 150,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  renderSubtitle('Telefono:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: controller,
                        style: TextStyle(color: kColorBlack),
                        decoration: InputDecoration(
                          focusColor: kColorBlack,
                          fillColor: kColorBlack,
                          hintStyle: TextStyle(color: kColorBlack),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Color(0xff00000),
                              style: BorderStyle.solid,
                            ),
                          ),
                          labelText: 'Agrega tu telefono',
                          labelStyle: TextStyle(color: kColorBlack),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              renderSubtitle('Correo: ${currentProfile.data()['email']}'),
              SizedBox(
                height: 20,
              ),
              renderSubtitle(
                  'Direccion: ${currentProfile.data()['direccion']}'),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        email = currentProfile.data()['email'];
                        direccion = currentProfile.data()['direccion'];
                        fullName = currentProfile.data()['fullName'];
                      });
                      final resp = await _alterno.updatenumbre(
                          email: email,
                          fullName: fullName,
                          direccion: direccion,
                          phone: controller.text);
                      if (resp == false) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Numero no actualizado'),
                                  content: Text('Intentelo mas tarde'),
                                ));
                        Future.delayed(Duration(milliseconds: 150));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Control()));
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Control()));
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 70,
                      child: Text(
                        'Guardar',
                        style: TextStyle(fontSize: 19),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
