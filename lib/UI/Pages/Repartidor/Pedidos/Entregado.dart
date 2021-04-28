import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Entregado extends StatefulWidget {
  final QuerySnapshot data;
  Entregado({Key key, @required this.data}) : super(key: key);

  @override
  _EntregadoState createState() => _EntregadoState();
}

class _EntregadoState extends State<Entregado> {
  List entrega;
  bool isLoading = true;
  @override
  void initState() {
    setState(() {
      isLoading = false;
      entrega = widget.data.docs;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List data = entrega;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          height: size.height,
          child: data.length == 0
              ? Center(
                  child: Text('No tenemos entregas tuyas en el server'),
                )
              : validate(isLoading, data)),
    );
  }

  Widget validate(bool isLoading, List data) {
    if (isLoading) {
      return Center(
          child: Container(
        child: CircularProgressIndicator(),
      ));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data[index]['direccion']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${data[index]['name']}',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                '${data[index]['producto']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' ${data[index]['person']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text('|'),
                              Text('Total: ',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                              Text(
                                '${data[index]['precio']}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${data[index]['fecha']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'estado: ${data[index]['staterepartidor']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            child: Text(
                              '${data[index]['nota']}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )));
      },
    );
  }
}
