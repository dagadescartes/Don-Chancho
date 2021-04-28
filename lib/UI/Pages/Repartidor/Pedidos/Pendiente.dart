import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/device/Map/Mapbox.dart';
import 'package:flutter/material.dart';

class Pendiente extends StatefulWidget {
  final QuerySnapshot pedido;
  Pendiente({Key key, @required this.pedido}) : super(key: key);

  @override
  _PendienteState createState() => _PendienteState();
}

class _PendienteState extends State<Pendiente> {
  BlocOtherRepository _repository = BlocOtherRepository();
  List pedidos;
  DocumentSnapshot user;
  bool isLoading = true;
  @override
  void initState() {
    _repository.getCredentialUser((userDocument) {
      setState(() {
        isLoading = false;
        user = userDocument;
      });
    });
    setState(() {
      pedidos = widget.pedido.docs;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: validate(),
    );
  }

  Widget validate() {
    String direccion, name, fecha, estado, producto, person, phone;
    int precio;
    BlocOtherRepository _repository = BlocOtherRepository();
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Center(
          child: Container(
        child: CircularProgressIndicator(),
      ));
    } else {
      return SingleChildScrollView(
        child: Container(
          height: size.height,
          child: Column(
            children: [
              Container(
                height: size.height * 0.23,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/repartidor-0.png'),
                              fit: BoxFit.cover)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[300]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.data()['fullName']}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Cel. ${user.data()['telefono']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Pedidos Pendientes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Color(0xff9CED45)),
                                  child: Text('Confirmado'),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Color(0xffFB6E53),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Center(
                                          child: Text(
                                        '${pedidos.length}',
                                        style: TextStyle(
                                            fontSize: 34, color: kColorWhite),
                                      )),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  height: size.height * 0.67,
                  child: pedidos.length == 0
                      ? Center(
                          child: Text(
                            'No tienes pedidos asignados',
                            style: TextStyle(fontSize: 24),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: pedidos.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black)),
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${pedidos[index]['direccion']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${pedidos[index]['name']}',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${pedidos[index]['producto']}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                ' ${pedidos[index]['person']}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text('|'),
                                              Text('Total',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              Text(
                                                '${pedidos[index]['precio'].toString()}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${pedidos[index]['fecha']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                            child: Text(
                                              '${pedidos[index]['nota']}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                direccion =
                                                    pedidos[index]['direccion'];
                                                fecha = pedidos[index]['fecha'];
                                                precio =
                                                    pedidos[index]['precio'];
                                                name = pedidos[index]['name'];
                                                estado = 'Entregado';
                                              });
                                              final resp = await _repository
                                                  .pedidosEntregados(
                                                      direccion,
                                                      fecha,
                                                      precio,
                                                      name,
                                                      estado);
                                              Future.delayed(
                                                  Duration(milliseconds: 210));
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              if (resp == null) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              'Lo sentimos'),
                                                          content: Text(
                                                              'Tenemos problemas para conectarnos con el servidor'),
                                                        ));
                                              }
                                              Future.delayed(
                                                  Duration(milliseconds: 200));
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 22,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.green),
                                              child: Center(
                                                  child: Text(
                                                'Entregado',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            )),
                                        TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                direccion =
                                                    pedidos[index]['direccion'];
                                                fecha = pedidos[index]['fecha'];
                                                precio =
                                                    pedidos[index]['precio'];
                                                name = pedidos[index]['name'];
                                                producto =
                                                    pedidos[index]['producto'];
                                                person =
                                                    pedidos[index]['person'];
                                                phone =
                                                    pedidos[index]['telefono'];
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Mapb0x(
                                                              phone: phone,
                                                              direccion:
                                                                  direccion,
                                                              fecha: fecha,
                                                              precio: precio
                                                                  .toDouble(),
                                                              name: name,
                                                              producto:
                                                                  producto,
                                                              person: person)));
                                            },
                                            icon: Icon(Icons.add_location),
                                            label: Text('Map')),
                                        TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                direccion =
                                                    pedidos[index]['direccion'];
                                                fecha = pedidos[index]['fecha'];
                                                precio =
                                                    pedidos[index]['precio'];
                                                name = pedidos[index]['name'];
                                                estado = 'Rechazada';
                                              });
                                              final resp = await _repository
                                                  .pedidosRechazados(
                                                      direccion,
                                                      fecha,
                                                      precio,
                                                      name,
                                                      estado);
                                                       Future.delayed(
                                                  Duration(milliseconds: 210));
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              if (resp == null) {
                                                 showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              'Lo sentimos'),
                                                          content: Text(
                                                              'Tenemos problemas para comunicarnos con el servidor'),
                                                        ));
                                                    Future.delayed(
                                                  Duration(milliseconds: 200));
                                              Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              height: 22,
                                              width: 75,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.red),
                                              child: Center(
                                                  child: Text(
                                                'Rechazado',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
            ],
          ),
        ),
      );
    }
  }
}
