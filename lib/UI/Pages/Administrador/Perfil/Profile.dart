import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/UI/Pages/Authenticate/Widgets/Logo.dart';
import 'package:demo_diego_lechona/data/Repository/Repository.dart';
import 'package:demo_diego_lechona/UI/Utils/Colors.dart';
import 'package:demo_diego_lechona/UI/Utils/Paddins.dart';
import 'package:demo_diego_lechona/data/Repository/Repository_Alterno.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DocumentSnapshot currentProfile;
  bool isLoading = true;
  final streamProfile = StreamController<DocumentSnapshot>();
  final controller = TextEditingController();
  String direccion, fullName, email;

  @override
  void initState() {
    BlocOtherRepository().getCredentialUser((userDocument) {
      setState(() {
        isLoading = false;
        currentProfile = userDocument;
      });
      print(currentProfile.data());
    });
    super.initState();
  }

  RepositoryAlterno _alterno = RepositoryAlterno();

  Widget renderTitle(String text) {
    return Text(text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));
  }

  Widget renderSubtitle(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: kColorGray));
  }

  Widget renderBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Cargando Perfil ...")
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kPaddinDefaulHorizontal,
          vertical: kPaddinDefaulVertical * 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      '${currentProfile.data()['fullName']}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Align(
                    alignment: Alignment.centerLeft,
                    child: renderTitle("${currentProfile.data()['role']}")),
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Logo(
                      kheight: 150,
                      kwidth: 150,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            children: [
              renderSubtitle('Telefono: ${currentProfile.data()['telefono']}'),
              GestureDetector(
                onTap: () {
                  print('Agregamos data');
                  streamProfile.add(currentProfile);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [Icon(Icons.edit), Text('Editar')],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          renderSubtitle('Correo: ${currentProfile.data()['email']}'),
          SizedBox(
            height: 20,
          ),
          renderSubtitle('Direccion: ${currentProfile.data()['direccion']}'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Perfil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: StreamBuilder(
          stream: streamProfile.stream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return renderBody();
            }
            if (snapshot.hasData) {
              return renderData();
            }
            return null;
          },
        ));
  }

  Widget renderData() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Cargando Perfil ...")
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kPaddinDefaulHorizontal,
          vertical: kPaddinDefaulVertical * 4),
      child: SingleChildScrollView(
        child: Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                      '${currentProfile.data()['fullName']}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    Align(
                    alignment: Alignment.centerLeft,
                    child: renderTitle("${currentProfile.data()['role']}")),
                  ],
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Logo(
                      kheight: 150,
                      kwidth: 150,
                    ),
                  ),
                ],
              )
            ],
          ),
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  renderSubtitle('Telefono:'),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: controller,
                        style: TextStyle(color: kColorBlack),
                        decoration: InputDecoration(
                          focusColor: kColorBlack,
                          fillColor: kColorBlack,
                          hintStyle: TextStyle(color: kColorBlack),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Color(0xff00000),
                              style: BorderStyle.solid,
                            ),
                          ),
                          labelText: 'Agrega tu telefono',
                          labelStyle: TextStyle(color: kColorBlack),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              renderSubtitle('Correo: ${currentProfile.data()['email']}'),
              SizedBox(
                height: 20,
              ),
              renderSubtitle('Direccion: ${currentProfile.data()['direccion']}'),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton(
                    onPressed: () async {
                      setState(() {
                        email = currentProfile.data()['email'];
                        direccion = currentProfile.data()['direccion'];
                        fullName = currentProfile.data()['fullName'];
                      });
                      final resp = await _alterno.updatenumbre(
                          email: email,
                          fullName: fullName,
                          direccion: direccion,
                          phone: controller.text);
                      if (resp != false) {
                        return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Numero actualizado con exito'),
                                  content: Text(
                                      'Podra ver el cambio entrando nuevamente a perfil'),
                                ));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Numero no actualizado'),
                                  content: Text('Intentelo mas tarde'),
                         ));
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 70,
                      child: Text(
                        'Guardar',
                        style: TextStyle(fontSize: 19),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
