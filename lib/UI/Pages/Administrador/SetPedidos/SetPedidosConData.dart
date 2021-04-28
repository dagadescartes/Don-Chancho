import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:demo_diego_lechona/UI/Pages/Administrador/SetPedidos/SecondPage.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';

class SetPedidosSinData extends StatefulWidget {
  final QuerySnapshot lechona, cojines, data;
  SetPedidosSinData(
      {Key key,
      @required this.lechona,
      @required this.cojines,
      @required this.data})
      : super(key: key);

  @override
  _SetPedidosSinDataState createState() => _SetPedidosSinDataState();
}

class _SetPedidosSinDataState extends State<SetPedidosSinData> {
  QuerySnapshot datos;
  String fecha, person, producto;
  int price;
  int selectCojines, selectLechonas;
  @override
  void initState() {
    setState(() {
      datos = widget.data;
      dato = datos.docs;
    });
    super.initState();
  }

  List dato;
  @override
  Widget build(BuildContext context) {
    final QuerySnapshot lh = widget.lechona, cj = widget.cojines;
    final List lechona = lh.docs, cojines = cj.docs, data = dato;
    Size size = MediaQuery.of(context).size;
    String email = data[0]['email'],
        phone = data[0]['telefono'],
        name = data[0]['name'],
        direccion = data[0]['direccion'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.api_sharp),
                  Text(
                    'Datos Cliente',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.api_sharp),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  height: 250,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            'Telefono:  ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            data[0]['telefono'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            'Nombre:  ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            data[0]['name'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            'Direccion:  ',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            data[0]['direccion'],
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            'Correo:  ',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            data[0]['email'],
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.api_sharp),
                  Text(
                    'Lista Precios',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.api_sharp),
                ],
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('    Cojines',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 215,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                        padding: EdgeInsets.only(right: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.cojines.docs.length,
                        itemBuilder: (context, indexx) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectCojines = indexx;
                                selectLechonas = -1;
                                person = widget.cojines.docs[indexx]['person'];
                                producto = widget.cojines.docs[indexx]['name'];
                                price = widget.cojines.docs[indexx]['price'];
                                print(selectCojines);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    height: size.height * 0.15,
                                    width: size.width * 0.5,
                                    child: FadeInImage(
                                      placeholder: (AssetImage(
                                          'assets/images/Blocks-1s-200px.gif')),
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          widget.cojines.docs[indexx]['url']),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(widget.cojines.docs[indexx]['name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          widget.cojines.docs[indexx]['person'],
                                          style: TextStyle(fontSize: 16)),
                                      Text('porciones',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                          widget.cojines.docs[indexx]['price']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '    Seleccionado',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: selectCojines == indexx
                                                ? kColorGreen
                                                : kColorWhite),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('    Lechonas',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700))),
              SizedBox(
                  height: 228,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                        padding: EdgeInsets.only(right: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.lechona.docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectLechonas = index;
                                selectCojines = -1;
                                person = widget.lechona.docs[index]['person'];
                                producto = widget.lechona.docs[index]['name'];
                                price = widget.lechona.docs[index]['price'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    height: size.height * 0.15,
                                    width: size.width * 0.5,
                                    child: FadeInImage(
                                      placeholder: (AssetImage(
                                          'assets/images/Blocks-1s-200px.gif')),
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          widget.lechona.docs[index]['url']),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(widget.lechona.docs[index]['name'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(widget.lechona.docs[index]['person'],
                                          style: TextStyle(fontSize: 16)),
                                      Text('porciones',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          widget.lechona.docs[index]['price']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        '    Seleccionado',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: selectLechonas == index
                                                ? kColorGreen
                                                : kColorWhite),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )),
              SizedBox(
                height: 5,
              ),
              DateTimePicker(
                dateHintText: 'Fecha y Hora',
                style: TextStyle(color: Colors.black),
                initialValue: '',
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy - h:mm a',
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Fecha y Hora',
                onChanged: (value) {
                  setState(() {
                    fecha = value;
                  });
                },
                onSaved: (value) {
                  fecha = value;
                },
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Guardar(
                kdireccion: direccion,
                kemail: email,
                kname: name,
                kphone: phone,
                kperson: person,
                kfecha: fecha,
                kprice: price,
                kproducto: producto,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Guardar extends StatefulWidget {
  const Guardar({
    Key key,
    this.kphone,
    this.kname,
    this.kdireccion,
    this.kemail,
    this.kproducto,
    this.kperson,
    this.kprice,
    this.kfecha,
  }) : super(key: key);

  final String kphone, kname, kdireccion, kemail, kproducto, kperson, kfecha;
  final int kprice;

  @override
  _GuardarState createState() => _GuardarState();
}

class _GuardarState extends State<Guardar> {
  @override
  Widget build(BuildContext context) {
    String name = widget.kname,
        phone = widget.kphone,
        direccion = widget.kdireccion,
        email = widget.kemail,
        fecha = widget.kfecha,
        producto = widget.kproducto,
        person = widget.kperson;
    int price = widget.kprice;
    return TextButton(
        onPressed: () {
          print(email);
          print(phone);
          print(name);
          print(direccion);
          print(producto);
          print(price);
          print(person);
          print(fecha);
          if (email.length != 0 &&
              phone.length != 0 &&
              name.length != 0 &&
              direccion.length != 0 &&
              producto.length != 0 &&
              price != 0 &&
              person.length != 0 &&
              fecha.length != 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondPage(
                          email: email,
                          phone: phone,
                          name: name,
                          direction: direccion,
                          product: producto,
                          price: price,
                          person: person,
                          fecha: fecha,
                        )));
          } else {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Debes llenar todas las opciones de pedido'),
                      content: Text('Ve e intentalo de nuevo'),
                    ));
          }
        },
        child: Container(
            child: Text('\nGuardar',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            height: 50,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            )));
  }
}
