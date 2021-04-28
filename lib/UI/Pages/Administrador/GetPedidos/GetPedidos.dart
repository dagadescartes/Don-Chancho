import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/AsignarRoll/Asignar.dart';
import 'package:flutter/material.dart';

class GetPedidos extends StatefulWidget {
  final QuerySnapshot pedidos;
  GetPedidos({Key key, @required this.pedidos}) : super(key: key);

  @override
  _GetPedidosState createState() => _GetPedidosState();
}

class _GetPedidosState extends State<GetPedidos> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final QuerySnapshot pdd = widget.pedidos;
    final List pedido = pdd.docs;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: pedido.length == 0
              ? Center(
                  child: Text('No tenemos pedidos registrados'),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: pedido.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RowDemo(
                                  pedido: pedido,
                                  index: index,
                                  tipo: 'Telefono:',
                                  data: 'telefono',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RowDemo(
                                  pedido: pedido,
                                  index: index,
                                  tipo: 'Nombre:',
                                  data: 'name',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RowDemo(
                                  pedido: pedido,
                                  index: index,
                                  tipo: 'Direccion:',
                                  data: 'direccion',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RowDemo(
                                  pedido: pedido,
                                  index: index,
                                  tipo: 'Repartidor:',
                                  data: 'repartidor',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RowDemo(
                                  pedido: pedido,
                                  index: index,
                                  tipo: 'Correo:',
                                  data: 'email',
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pedido[index]['producto'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      pedido[index]['precio'].toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      pedido[index]['person'],
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
                                        pedido[index]['nota'],
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Asignar(
                                            pedidos: pedido[index],
                                          ),
                                        )),
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        'Asignar',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ));
                  }),
        ),
      ),
    );
  }
}

class RowDemo extends StatelessWidget {
  final int index;
  const RowDemo({
    Key key,
    @required this.index,
    @required this.pedido,
    @required this.tipo,
    @required this.data,
  }) : super(key: key);

  final List pedido;
  final String tipo;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          tipo,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            pedido[index][data],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
