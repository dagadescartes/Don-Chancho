import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendienteporPago extends StatefulWidget {
  final QuerySnapshot data;
  const PendienteporPago({Key key, @required this.data}) : super(key: key);

  @override
  _PendienteporPagoState createState() => _PendienteporPagoState();
}

class _PendienteporPagoState extends State<PendienteporPago> {
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
    int numped = 1;
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '${numped++}.',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.airport_shuttle_outlined,
                                size: 28,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                height: 30,
                                width: 140,
                                child: Center(
                                  child: Text('Pedido N.' + '${numoedi++}',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                height: 30,
                                width: 120,
                                child: Center(
                                  child: Text(docslist.docs[index]['precio'].toString(),
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
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
