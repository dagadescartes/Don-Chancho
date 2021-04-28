import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Mapb0x extends StatefulWidget {
  final String name, direccion, fecha, producto, person, phone;
  final double precio;
  const Mapb0x(
      {Key key,
      @required this.name,
      @required this.direccion,
      @required this.fecha,
      @required this.producto,
      @required this.person,
      @required this.precio,
      @required this.phone})
      : super(key: key);

  @override
  _Mapb0xState createState() => _Mapb0xState();
}

class _Mapb0xState extends State<Mapb0x> {
  String name, direccion, fecha, producto, person, phone;
  int precio;
  @override
  void initState() {
    setState(() {
      name = widget.name;
      direccion = widget.direccion;
      fecha = widget.fecha;
      producto = widget.producto;
      person = widget.person;
      precio = widget.precio.toInt();
      phone = widget.phone;
    });
    super.initState();
  }

  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  String defaul = 'mapbox://styles/stivenmorelo/ckmx69l7c0jec17t7y37snwng';
  final basic = 'mapbox://styles/stivenmorelo/ckmx69l7c0jec17t7y37snwng';
  final darkLigth = 'mapbox://styles/stivenmorelo/ckmx64thj0j5617o680eiq3ge';
  final center = LatLng(4.71154392845879, -74.06954038791866);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String estado;
    BlocOtherRepository _repository = BlocOtherRepository();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              height: 50,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/repartidor-0.png'),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 148,
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
                            direccion,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                             overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            name,
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis
                          ),
                          Row(
                            children: [
                              Text(
                                producto,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                person,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text('|'),
                              Text('Total',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                              Text(
                                precio.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            fecha,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            phone,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                estado = 'entregado';
                              });
                              final resp = await _repository.pedidosEntregados(
                                  direccion, fecha, precio, name, estado);
                              if (resp != null) {
                                return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              'Confirmacion positiva agregada'),
                                          content: Text(
                                              'Continua con otros pedidos, este desaparecera cuando ingreses de nuevo'),
                                        ));
                              } else {
                                return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Lo sentimos'),
                                          content: Text(
                                              'Tenemos problemas para conectarnos con el servidor'),
                                        ));
                              }
                            },
                            child: Container(
                              height: 22,
                              width: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green),
                              child: Center(
                                  child: Text(
                                'Entregado',
                                style: TextStyle(color: Colors.white),
                              )),
                            )),
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                estado = 'Rechazado';
                              });
                              final resp = await _repository.pedidosRechazados(
                                  direccion, fecha, precio, name, estado);
                              if (resp != null) {
                                return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                              'Confirmacion Negativa agregada'),
                                          content: Text(
                                              'Continua con otros pedidos, este desaparecera cuando ingreses de nuevo'),
                                        ));
                              } else {
                                return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text('Lo sentimos'),
                                          content: Text(
                                              'Tenemos problemas para comunicarnos con el servidor'),
                                        ));
                              }
                            },
                            child: Container(
                              height: 22,
                              width: 75,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.red),
                              child: Center(
                                  child: Text(
                                'Rechazado',
                                style: TextStyle(color: Colors.white),
                              )),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: size.height - 302,
              child: Stack(
                children: [
                  MapboxMap(
                      styleString: defaul,
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                      initialCameraPosition:
                          CameraPosition(target: center, zoom: 11)),
                  BotonesFlotantes()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align BotonesFlotantes() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          FloatingActionButton(
              child: Icon(Icons.data_usage_rounded),
              onPressed: () {
                if (defaul == darkLigth) {
                  defaul = basic;
                } else {
                  defaul = darkLigth;
                }
                setState(() {});
              }),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton(
              child: Icon(Icons.zoom_in),
              onPressed: () {
                mapController.animateCamera(CameraUpdate.zoomIn());
                setState(() {});
              }),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton(
              child: Icon(Icons.zoom_out),
              onPressed: () {
                mapController.animateCamera(CameraUpdate.zoomOut());
                setState(() {});
              }),
        ],
      ),
    );
  }
}
