import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChefPedidos extends StatefulWidget {
  final QuerySnapshot db;
  final int dbc;
  ChefPedidos({Key key, @required this.db, @required this.dbc})
      : super(key: key);

  @override
  _ChefPedidosState createState() => _ChefPedidosState();
}

class _ChefPedidosState extends State<ChefPedidos> {
  final firebaseStream = StreamController<QuerySnapshot>();
  QuerySnapshot data;
  int dbc;
  @override
  void initState() {
    setState(() {
      data = widget.db;
      dbc = widget.dbc;
    });
    super.initState();
  }

  @override
  void dispose() {
    firebaseStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(time);
    DateTime datanow = DateTime.parse(date);
    Size size = MediaQuery.of(context).size;
    String fecha;
    RepositoryAlterno _repository = RepositoryAlterno();
    QuerySnapshot resp;
    List listadb = data.docs;
    int cantidad = dbc;
    int total;
    int newdbc;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }),
          title: Text('Chef'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/repartidor-0.png'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Center(
                  child: Container(
                    height: size.height * 0.005,
                    width: size.width * 0.80,
                    color: kColorGray,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text('Fecha',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Oswald')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        newdbc = await RepositoryAlterno().getpedidoschefnow();
                        resp = await _repository.getTimeNow();
                        if (resp != null) {
                          firebaseStream.sink.add(resp);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Lo sentimos'),
                                    content: Text(
                                        'No podemos conectar con el server'),
                                  ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff001D4B),
                            borderRadius: BorderRadius.circular(16)),
                        height: 50,
                        width: 60,
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
                        type: DateTimePickerType.date,
                        initialValue: '',
                        dateMask: '  yyyy-MM-dd',
                        initialDate: datanow,
                        lastDate: DateTime(2100),
                        firstDate: datanow,
                        dateLabelText: 'Fecha',
                        dateHintText: 'Fecha',
                        onChanged: (value) {
                          fecha = value;
                        },
                        onSaved: (value) {
                          fecha = value;
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          newdbc = await RepositoryAlterno()
                              .getpedidoschefdate(fecha: fecha);
                          resp = await _repository.getTimeTable(fecha);
                          print(newdbc);
                          if (resp != null) {
                            firebaseStream.sink.add(resp);
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          'Hemos perdido conexion con el server'),
                                      content: Text('Intente mas tarde'),
                                    ));
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
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: size.height * 0.005,
                    width: size.width * 0.80,
                    color: kColorGray,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: firebaseStream.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      print(cantidad);
                      return LoadingData(
                        size: size,
                        data: listadb,
                        canti: total,
                        dbc: cantidad,
                      );
                    }
                    if (snapshot.hasData) {
                      print('Tenemos data');
                      return LoadingData(
                          size: size,
                          data: resp.docs,
                          canti: total,
                          dbc: newdbc);
                    }
                    if (snapshot.hasError) {
                      return Text('Error',
                          style: TextStyle(
                            fontSize: 18,
                          ));
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            )),
      ),
    );
  }
}

class LoadingData extends StatelessWidget {
  const LoadingData({
    Key key,
    @required this.size,
    @required this.data,
    @required this.canti,
    @required this.dbc,
  }) : super(key: key);

  final Size size;
  final List data;
  final int canti;
  final int dbc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 670,
        child: Center(
          child: Column(
            children: [
              Container(
                height: size.height * 0.32,
                width: size.width * 0.97,
                decoration: BoxDecoration(
                    color: Color(0xffF1F6FE),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      'Lista de Pedidos',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w600),
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Text('Producto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w600)),
                          Text('Hora',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w600)),
                          Text('Cantidad',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center)
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: size.height * (0.2),
                      width: size.width,
                      child: data.length == 0
                          ? Center(
                              child: Text('No hay pedidos para este dia',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)))
                          : ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, left: 4, bottom: 4, right: 50),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          data[index]['Producto'] +
                                              ' ' +
                                              data[index]['Cantidad']
                                                  .toString() +
                                              ' porciones  ' +
                                              data[index]['hour'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Text(data[index]['index'].toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700))
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Center(
                      child: Text('INSUMOS',
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w700)),
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Insumos(
                                  image: 'assets/images/ARROZ.png',
                                  text: 'Arroz',
                                  calculo: (100.0 * dbc)),
                              Insumos(
                                  image: 'assets/images/carne-de-cerdo.png',
                                  text: 'Pernil de Cerdo',
                                  calculo: (175.0 * dbc)),
                              Insumos(
                                  image: 'assets/images/sal.png',
                                  text: 'Sal',
                                  calculo: (2.5 * dbc))
                            ],
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Insumos(
                                    image: 'assets/images/arbeja.png',
                                    text: 'Arbeja',
                                    calculo: (25.0 * dbc)),
                                Insumos(
                                    image: 'assets/images/cebolla.png',
                                    text: 'Pernil de Cerdo',
                                    calculo: (7.5 * dbc)),
                                Insumos(
                                    image: 'assets/images/especias.png',
                                    text: 'Especias',
                                    calculo: (4.0 * dbc))
                              ],
                            ),
                          )
                        ]),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Insumos extends StatelessWidget {
  const Insumos({
    Key key,
    @required this.image,
    @required this.text,
    @required this.calculo,
  }) : super(key: key);
  final String image, text;
  final double calculo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: Image.asset(
          image,
          fit: BoxFit.cover,
        )),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text('$calculo'.toString() + ' Kilos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
      ],
    );
  }
}
