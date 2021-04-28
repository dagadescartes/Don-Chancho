import 'dart:io';

import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final String phone, name, direction, email, product, person, fecha, note;
  final int price;
  SecondPage(
      {Key key,
      @required this.phone,
      @required this.name,
      @required this.direction,
      @required this.email,
      @required this.fecha,
      @required this.product,
      @required this.price,
      @required this.person,
      this.note})
      : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String note;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String phone = widget.phone,
        name = widget.name,
        direction = widget.direction,
        email = widget.email,
        product = widget.product,
        person = widget.person,
        fecha = widget.fecha;
    int price = widget.price;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'LECHONERIA\nDON CHANCHO',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Logo(
                    kheight: 150,
                    kwidth: 150,
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row1(
                data: phone,
                tipo: 'Telefono',
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row1(
                data: name,
                tipo: 'Nombre',
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                  child: Row1(
                data: direction,
                tipo: 'Direccion',
              )),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                  child: Row1(
                data: email,
                tipo: 'Correo',
              )),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                height: 3,
                width: size.width * 0.9,
                color: Colors.grey[600],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Producto',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(product, style: TextStyle(fontSize: 16)),
                          Text(' ' + person, style: TextStyle(fontSize: 16))
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Precio',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(price.toString(), style: TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Row(
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '   ' + price.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: size.height * 0.15,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  onChanged: (val) {
                    note = val;
                  },
                  maxLength: 70,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Nota',
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextButton(
                  onPressed: () async {
                    print(note);
                    final cantidadchef = int.parse(person);
                    print(cantidadchef);
                    final resp = await BlocOtherRepository().setPedidos(
                        cantidadchef,
                        email,
                        direction,
                        name,
                        note,
                        price,
                        product,
                        phone,
                        fecha,
                        person);
                    if (resp) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Pedido realizado existosamente',
                                    style: TextStyle(fontSize: 20)),
                                content: Text(
                                  'Enviaremos una copia del recibo al cliente, por favor espere',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                      await metodo(name, phone, direction, email, product,
                          price, note, person, fecha);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('No pudimos guardaro correctamente',
                                    style: TextStyle(fontSize: 20)),
                                content: Text(
                                  'Lo sentimos, la conexion con la BD esta fallando',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16)),
                    height: 50,
                    width: 85,
                    child: Center(
                        child: Text(
                      'Guardar',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  metodo(name, phone, direction, email, product, price, note, person,
      fecha) async {
    String username = 'donchancho01@gmail.com';
    String password = 'diegoavenda';

    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Hola $name')
      ..recipients.add(email)
      ..subject =
          'Datos del Pedido :: Donchancho :: Fecha de envio del correo: ${DateTime.now()}'
      ..text = 'Texto 1 del mensaje.'
      ..html = '<h1 align="center">Donchancho</h1>'
          '<td align="center" bgcolor="#FFFFFF" style="padding: 40px 0 30px 0;">'
          '\n<h2 align="center">Apreciado cliente gracias por su compra</h2>'
          '\n<h3 align="center">Adjuntamos una copia con los datos de la factura a su correo registrado.</h3>'
          '\n'
          '\n'
          '\n<h3 align="center"> Numero movil registrado para la compra: $phone</h3>'
          '\n<h3 align="center"> Nombre del cliente registrado para la compra: $name</h3>'
          '\n<h3 align="center"> Direccion registrada para la compra: $direction</h3>'
          '\n<h3 align="center"> Correo registrado para la compra: $email</h3>'
          '\n<h3 align="center"> Nombre del repartidor: en proceso...</h3>'
          '\n<h3 align="center"> Nota para el repartidor: $note</h3>'
          '\n<h3 align="center"> Producto'
          ' --------------------'
          ' Precio</h3>'
          '\n<h3 align="center">$product'
          ' ---------------------'
          ' $price</h3>'
          '\n<h1 align="center">               Total</h1>'
          '\n<h2 align="center">              $price</h2>'
          '\n'
          '\n<h3 align="center"> En caso tal se entregara una parte del pago por adelantado, compruebe que este escrito en la nota anterior.</h3>'
          '\n'
          '\n<h3> Si crees que existe alguna equivocacion o desees preguntar algo, por favor comunicate con nosotros.</h3>'
          '\n<h3> Correo: donchancho01@gmail.com.</h3>'
          '\n<h3> Telefono: 3210144569.</h3>'
          '<img assets/images="logo.png" width="300" height="230"/>';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    var connection = PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }
}

class Row1 extends StatelessWidget {
  const Row1({
    Key key,
    @required this.data,
    this.tipo,
  }) : super(key: key);

  final String data;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15),
      child: Container(
        child: Row(
          children: [
            Text(
              '$tipo: ',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
