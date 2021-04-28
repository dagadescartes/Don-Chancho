import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/DeleteUser/DeleteUser.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/GetPedidos/GetPedidos.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/OrdenesAtrazadas.dart/OrdenesAtrazadas.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/OrdenesEntregadas/OrdenesRechazadas.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/OrdenesRechazadas/OrdenesEntregadas.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Pedidosporcancelar/AdminPedidosporcancelar.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Perfil/Profile.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/SetPedidos/SetPedidos.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/SetPedidos/SetPedidosConData.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/SetProductos/SetProductos.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/DrawerItems.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/TextCentral.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/Widgets/TotalOrdenesContainer.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Login.dart';
import 'package:demo_diego_lechona/UI/Pages/Repartidor/Pedidos/PedidosporPagar.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Admin extends StatefulWidget {
  Admin({
    Key key,
  }) : super(key: key);
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  TextEditingController nomdomi = TextEditingController();
  TextEditingController phodomi = TextEditingController();
  BlocOtherRepository _repository = BlocOtherRepository();
  RepositoryAlterno _alterno = RepositoryAlterno();
  QuerySnapshot _cojines, _lechona, resp;
  double number;
  String phone,
      date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  double top = 0;
  TextEditingController controller = TextEditingController();

  // ignore: close_sinks
  final consolidado = StreamController<double>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Administrador/a \n',
                    style: TextStyle(color: kColorBlack, fontSize: 18),
                  ),
                  Text(
                    '',
                    style: TextStyle(color: kColorBlack, fontSize: 18),
                  ),
                ],
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
                final resp = DateTime.now();
                print(resp);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Admin()));
              },
            ),
            DrawerItems(
                text: 'Pedidos',
                iconos: Icons.shopping_basket,
                go: () async {
                  final QuerySnapshot _pedidos = await _repository.getPedidos();
                  if (_pedidos != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetPedidos(
                                  pedidos: _pedidos,
                                )));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Oh no, algo esta mal'),
                            content: Text(
                                'Lo sentimos, justo ahora no podemos traer los datos de pedidos de la base de datos'),
                          );
                        });
                  }
                }),
            DrawerItems(
                text: 'Ordenes Rechazadas',
                iconos: Icons.assignment_late,
                go: () async {
                  final data = await _repository.getOrdenesRechazadas();
                  if (data != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdenesRechazadas(data: data)));
                  } else {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Lo sentimos'),
                              content: Text(
                                  'Ahora no podemos conectar con el server'),
                            ));
                  }
                }),
            DrawerItems(
                text: 'Ordenes Entregadas',
                iconos: Icons.assignment_turned_in,
                go: () async {
                  final data = await _repository.getPedidoEntregadosTotal();
                  if (data != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdenesEntregadas(data: data)));
                  } else {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Lo sentimos'),
                              content: Text(
                                  'Ahora no podemos conectar con el server'),
                            ));
                  }
                }),
            DrawerItems(
                text: 'Ordenes Atrazadas',
                iconos: Icons.assignment_late,
                go: () async {
                  final time = DateTime.now().toString();
                  final data = await _repository.getOrdenesAtrazadas(time);
                  if (data != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdenesAtrazadas(data: data)));
                  } else {
                    return showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Lo sentimos'),
                              content: Text(
                                  'Ahora no podemos conectar con el server'),
                            ));
                  }
                }),
            DrawerItems(
                text: 'Perfil',
                iconos: Icons.person,
                go: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()))),
            DrawerItems(
              text: 'Eliminar Roll',
              iconos: Icons.person_remove,
              go: () async {
                final resp = await _alterno.searchusers();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeleteUsers(
                              data: resp,
                            )));
              },
            ),
            DrawerItems(
              text: 'Pendientes de Pago',
              iconos: Icons.card_travel_sharp,
              go: () async {
                setState(() {
                  phodomi.clear();
                  nomdomi.clear();
                });
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Column(
                            children: [
                              TextFormField(
                                controller: nomdomi,
                                decoration: InputDecoration(
                                    labelText: 'Nombre del domiciliario',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.black,
                                            style: BorderStyle.solid))),
                              ),
                              TextFormField(
                                controller: phodomi,
                                decoration: InputDecoration(
                                    labelText: 'Telefono del domiciliario',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.black,
                                            style: BorderStyle.solid))),
                              ),
                            ],
                          ),
                          content: TextButton(
                              onPressed: () async {
                                final data = await RepositoryAlterno()
                                    .revisiondepedidosporpagar(
                                        nomdomi.text, phodomi.text);
                                if (data != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminPedidosporCancelar(data: data, name: nomdomi.text, phone: phodomi.text,)));
                                } else {
                                  return showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Lo sentimos'),
                                            content: Text(
                                                'Ahora no podemos conectar con el server'),
                                          ));
                                }
                              },
                              child: Text(
                                'Buscar',
                                style: TextStyle(fontSize: 18),
                              )),
                        ));
              },
            ),
            DrawerItems(
                text: 'Nuevo Pedido',
                iconos: Icons.add_shopping_cart,
                go: () {
                  setState(() {
                    phone = null;
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Text('Buscar por Telefono',
                                style: TextStyle(fontSize: 18)),
                            TextFormField(
                              onChanged: (value) {
                                phone = value;
                              },
                              onSaved: (value) {
                                phone = value;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                          color: Colors.black,
                                          style: BorderStyle.solid))),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await _repository
                                      .getDataUserPedidos(phone)
                                      .then((value) {
                                    setState(() {
                                      resp = value;
                                    });
                                  });
                                  if (resp != null) {
                                    print('Tenemos data');
                                    await _repository
                                        .getLechona()
                                        .then((value) {
                                      _lechona = value;
                                    });
                                    await _repository
                                        .getCojines()
                                        .then((value) {
                                      _cojines = value;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SetPedidosSinData(
                                                  lechona: _lechona,
                                                  cojines: _cojines,
                                                  data: resp,
                                                )));
                                  } else {
                                    await _repository
                                        .getLechona()
                                        .then((value) {
                                      _lechona = value;
                                    });
                                    await _repository
                                        .getCojines()
                                        .then((value) {
                                      _cojines = value;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SetPedidos(
                                                lechona: _lechona,
                                                cojines: _cojines)));
                                  }
                                },
                                child: Text(
                                  'Buscar',
                                  style: TextStyle(fontSize: 18),
                                )),
                          ],
                        ),
                        content: TextButton(
                            onPressed: () async {
                              await _repository.getLechona().then((value) {
                                _lechona = value;
                              });
                              await _repository.getCojines().then((value) {
                                _cojines = value;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SetPedidos(
                                          lechona: _lechona,
                                          cojines: _cojines)));
                            },
                            child: Text(
                              'Nuevo cliente',
                              style: TextStyle(fontSize: 18),
                            )),
                      );
                    },
                  );
                }),
            DrawerItems(
                text: 'Nuevo Producto',
                iconos: Icons.add_circle_outline,
                go: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetProducto()))),
            DrawerItems(
              text: 'Salir',
              iconos: Icons.exit_to_app,
              go: () {
                AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              child: Image.asset(
                'assets/images/Admin.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextCentral(
              texto: 'TOTAL ORDENES',
            ),
            TOrdenes(size: size),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 3,
              color: kColorGray,
            ),
            SizedBox(
              height: 10,
            ),
            TextCentral(
              texto: 'CONSOLIDADO PEDIDOS',
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final QuerySnapshot pedidos =
                            await _repository.getPedidos();
                        final QuerySnapshot resp =
                            await _alterno.getconsolidadonow();
                        int data;
                        data = pedidos.docs.length;
                        List listadata = resp.docs;
                        setState(() {
                          top = 0;
                          date = DateFormat('yyyy-MM-dd')
                              .format(DateTime.now())
                              .toString();
                        });
                        for (int i = 0; i < data; i++) {
                          number = listadata[i]['precio'];
                          setState(() {
                            if (number != null) {
                              top += number;
                            } else {
                              top = 0;
                            }
                          });
                          print(top);
                          consolidado.sink.add(top);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff001D4B),
                            borderRadius: BorderRadius.circular(16)),
                        height: 50,
                        width: 90,
                        child: Center(
                            child: Text('Hoy',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Oswald',
                                    color: kColorWhite))),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kColorBlack)),
                      width: 100,
                      child: DateTimePicker(
                        controller: controller,
                        type: DateTimePickerType.date,
                        dateMask: '  yyyy-MM-dd',
                        initialDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        firstDate: DateTime(2000),
                        dateLabelText: 'Fecha',
                        dateHintText: 'Fecha',
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          final QuerySnapshot pedidos =
                              await _repository.getPedidos();
                          final QuerySnapshot resp = await _alterno
                              .getconsolidadodate(date: controller.text);
                          int data;
                          data = pedidos.docs.length;
                          List listadata = resp.docs;
                          setState(() {
                            top = 0;
                            date = controller.text;
                          });
                          if (listadata.length > 0) {
                            for (int i = 0; i < data; i++) {
                              number = listadata[i]['precio'];
                              setState(() {
                                top += number;
                              });
                              print(top);
                              consolidado.sink.add(top);
                            }
                          } else {
                            setState(() {
                              top = 0;
                            });
                          }
                        },
                        child: Text(
                          'Buscar Fecha',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff001D4B),
                          ),
                        ))
                  ],
                ),
                StreamBuilder(
                    stream: consolidado.stream,
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Center(
                                child: Text(
                                  'Escoge el consolidado que desees ver ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: kColorBlack,
                                ),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Text('Consolidados Ordenes Entregadas',
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: size.height * 0.05,
                                ),
                                Text(date,
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text('$top',
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        );
                      }
                      return null;
                    })
              ],
            )
          ],
        ),
      ),
    ));
  }
}
