import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPedidosporCancelar extends StatefulWidget {
  final QuerySnapshot data;
  final String name, phone;
  AdminPedidosporCancelar(
      {Key key, @required this.data, @required this.name, @required this.phone})
      : super(key: key);

  @override
  _AdminPedidosporCancelarState createState() =>
      _AdminPedidosporCancelarState();
}

class _AdminPedidosporCancelarState extends State<AdminPedidosporCancelar> {
  QuerySnapshot docslist;
  double total = 0;
  bool isLoading = true;

  @override
  void initState() {
    setState(() {
      docslist = widget.data;
    });
    for (var i = 0; i < docslist.docs.length; i++) {
      total = (docslist.docs[i]['precio'] + total);
    }
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RepositoryAlterno _alterno = RepositoryAlterno();
    int numoedi = 1;
    DateTime date = DateTime.now();
    String now = DateFormat('EEEE, M/y/d', 'es').format(date);
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Flexible(
          child: Column(
            children: [
              Container(
                height: 120,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/lechonas.png'),
                        fit: BoxFit.cover)),
              ),
              Divider(),
              Text(
                'Pedidos Pendientes por Pago',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                overflow: TextOverflow.fade,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(8.0),
                  height: 110,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        now.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Total Pedidos:   ' + docslist.docs.length.toString(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Efectivo a Entregar:   ' + total.toString(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12.0),
                  height: size.height,
                  width: size.width,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: docslist.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(16)),
                                height: 30,
                                width: 140,
                                child: Center(
                                  child: Text('Pedido N.' + '${numoedi++}',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(16)),
                                height: 30,
                                width: 120,
                                child: Center(
                                  child: Text(
                                      docslist.docs[index]['precio'].toString(),
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final resp = _alterno.confirmcaja(
                                      phone: docslist.docs[index]['telefono'],
                                      name: docslist.docs[index]['repartidor'],
                                      fecha: docslist.docs[index]['fecha'],
                                      precio: docslist.docs[index]['precio'],
                                      direccion: docslist.docs[index]
                                          ['direccion']);
                                  if (resp != null) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  } else {
                                    return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text('No realizado'),
                                              content:
                                                  Text('Intente mas tarde'),
                                            ));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(16)),
                                  height: 30,
                                  width: 70,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
