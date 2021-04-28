import 'dart:io';

import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Bottom.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetProducto extends StatefulWidget {
  SetProducto({Key key}) : super(key: key);

  @override
  _SetProductoState createState() => _SetProductoState();
}

class _SetProductoState extends State<SetProducto> {
  BlocOtherRepository _repository = BlocOtherRepository();
  List tipoOpc = ['Cojines', 'Lechonas'];
  List personOpc = [5, 7, 12, 20];
  String tipo, description, name;
  int person;
  String price;
  File image;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/lechonas.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.api_sharp),
                  Text(
                    'Crear Producto',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.api_sharp),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                height: 2,
                width: size.width,
                color: kColorGray,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xffFFECC2)),
                    height: size.height / 1.8,
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16)),
                              child: TextFormField(
                                onChanged: (value) {
                                  name = value;
                                },
                                onSaved: (value) {
                                  name = value;
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: kColorBlack),
                                  labelText: 'Nombre del producto',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => getGallery(),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: kColorGray),
                                      height: size.height * 0.15,
                                      width: size.width * 0.45,
                                      child: image == null
                                          ? Icon(Icons.add_a_photo)
                                          : Image.file(
                                              image,
                                              height: size.height * 0.15,
                                              width: size.width * 0.45,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    DropdownButton(
                                      onChanged: (value) {
                                        setState(() {
                                          tipo = value;
                                        });
                                      },
                                      style: TextStyle(color: kColorBlack),
                                      hint: Text(
                                        'Tipo',
                                        style: TextStyle(color: kColorBlack),
                                      ),
                                      value: tipo,
                                      items: tipoOpc.map((value) {
                                        return DropdownMenuItem(
                                            child: Text(value), value: value);
                                      }).toList(),
                                    ),
                                    DropdownButton(
                                      onChanged: (value) {
                                        setState(() {
                                          person = value;
                                        });
                                      },
                                      style: TextStyle(color: kColorBlack),
                                      hint: Text(
                                        'Porciones',
                                        style: TextStyle(color: kColorBlack),
                                      ),
                                      value: person,
                                      items: personOpc.map((value) {
                                        return DropdownMenuItem(
                                            child: Text(value.toString()),
                                            value: value);
                                      }).toList(),
                                    ),
                                    Container(
                                      width: size.width * 0.30,
                                      height: size.height * 0.10,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          price = value;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Precio',
                                            labelStyle:
                                                TextStyle(color: kColorBlack)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(),
                            Container(
                              width: size.width,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: kColorWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: TextFormField(
                                onChanged: (value) {
                                  description = value;
                                },
                                maxLines: 5,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(color: kColorBlack),
                                  labelText: 'Descripcion',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Bottom(
                texto: 'Guardar',
                colorText: kColorWhite,
                colorBottom: kColorBlack,
                ir: () async {
                  final precio = int.parse(price);
                  final dynamic response = await _repository.setProductos(
                      name, person.toString(), tipo, precio, description, image);
                  if (response == true) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Producto guardado'),
                            content: Text('Genial, lo hamos logrado guardar'),
                          );
                        });
                  } else {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Oh noo'),
                            content:
                                Text('Que mal, no lo hamos logrado guardar'),
                          );
                        });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getGallery() async {
    //aqui tomo la imagen de galeria
    final currentImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(currentImage.path);
    });
  }
}
