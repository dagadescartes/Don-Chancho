import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final dynamic uid;
  final String correo;
  final String nombre;
  final String telefono;
  final String rol;

  Users({this.telefono, this.rol, this.nombre, this.correo, this.uid});

  static Users fromSnapshot(QuerySnapshot snapshot, int index) {
    return Users(
        correo: snapshot.docs[index]['email'],
        nombre: snapshot.docs[index]['fullName'],
        uid: snapshot.docs[index].id,
        telefono: snapshot.docs[index]['telefono'],
        rol: snapshot.docs[index]['role']
     );
  }
}
