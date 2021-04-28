import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';

import 'package:flutter/material.dart';

class Asignar extends StatefulWidget {
  final QueryDocumentSnapshot pedidos;
  Asignar({
    Key key,
    @required this.pedidos,
  }) : super(key: key);

  @override
  _AsignarState createState() => _AsignarState();
}

class _AsignarState extends State<Asignar> {
  QuerySnapshot datarepar;
  List repartidor;
  @override
  void initState() {
    BlocOtherRepository().getRepartidores((userDocuments) {
      setState(() {
        datarepar = userDocuments;
        repartidor = datarepar.docs;
      });
    });
    super.initState();
  }

  bool isLoading;
  String namerepartidor, fecha, direccion, producto, correo, phone;
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot data = widget.pedidos;
    List dataRepar = repartidor;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ),
        body: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        height: size.height * 0.36,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RowDemo(
                              data: data,
                              text: 'Telefono: ',
                              textData: 'telefono',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowDemo(
                              data: data,
                              text: 'Nombre: ',
                              textData: 'name',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowDemo(
                              data: data,
                              text: 'Correo: ',
                              textData: 'email',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowDemo(
                              data: data,
                              text: 'Fecha:  ',
                              textData: 'fecha',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowDemo(
                              data: data,
                              text: 'Direccion:  ',
                              textData: 'direccion',
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '   Producto',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '               Precio',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '   Personas',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['producto'],
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  data['precio'].toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  data['person'],
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Nota',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    data['nota'],
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: size.height * 0.65,
                    child: dataRepar == null
                        ? Center(
                            child: Column(
                              children: [
                                Text('Buscando Repartidores'),
                                CircularProgressIndicator()
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: dataRepar.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(16)),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      RowListRepartidor(
                                          dataRepar: dataRepar,
                                          index: index,
                                          texto: 'Nombre: ',
                                          data: 'fullName'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RowListRepartidor(
                                          dataRepar: dataRepar,
                                          index: index,
                                          texto: 'Role: ',
                                          data: 'role'),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RowListRepartidor(
                                          dataRepar: dataRepar,
                                          index: index,
                                          texto: 'Telefono: ',
                                          data: 'telefono'),
                                      SizedBox(
                                        height: size.height * 0.015,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            setState(() {
                                              phone = data['telefono'];
                                              direccion = data['direccion'];
                                              fecha = data['fecha'];
                                              producto = data['producto'];
                                              correo = data['email'];
                                              namerepartidor = datarepar
                                                  .docs[index]['fullName'];
                                            });
                                            final resp =
                                                await BlocOtherRepository()
                                                    .updateRepartidor(
                                                        fecha,
                                                        direccion,
                                                        producto,
                                                        correo,
                                                        phone,
                                                        namerepartidor)
                                                    .whenComplete(() {
                                              Future.delayed(
                                                  Duration(milliseconds: 210));
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                            if (resp != true) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                    'Lo sentimos no se puede asignar este repartidor ahora',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  content: Text(
                                                      'Te invitamos a usar otro repartidor'),
                                                ),
                                              );
                                              Future.delayed(
                                                  Duration(seconds: 2));
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: isLoading == true
                                              ? Center(child: CircularProgressIndicator())
                                              : Container(
                                                  height: 30,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: Colors
                                                          .lightGreen[400]),
                                                  child: Center(
                                                      child: Text(
                                                    'Asignar',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontFamily: 'Oswald'),
                                                  ))))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowListRepartidor extends StatelessWidget {
  const RowListRepartidor({
    Key key,
    @required this.dataRepar,
    @required this.index,
    @required this.texto,
    @required this.data,
  }) : super(key: key);
  final int index;
  final List dataRepar;
  final String texto, data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(texto, style: TextStyle(fontSize: 18)),
        Text(
          dataRepar[index][data],
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }
}

class RowDemo extends StatelessWidget {
  const RowDemo({
    Key key,
    @required this.data,
    @required this.text,
    @required this.textData,
  }) : super(key: key);
  final String text, textData;
  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
        Expanded(child: Text(data[textData], style: TextStyle(fontSize: 18)))
      ],
    );
  }
}
