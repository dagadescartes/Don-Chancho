import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Pedidos {
  final String telefono, nombre, direccion, correo, producto, nota, id;
  final int precio;

  const Pedidos({
      @required this.telefono,
      @required this.nombre,
      @required this.direccion,
      @required this.correo,
      @required this.producto,
      @required this.precio,
      @required this.nota,
      @required this.id});

  static Pedidos fromsnapshot(QuerySnapshot snapshot, int index) {
    return Pedidos(
      telefono: snapshot.docs[index]['telefono'],
      nombre: snapshot.docs[index]['nombre'],
      direccion: snapshot.docs[index]['direccion'],
      correo: snapshot.docs[index]['correo'],
      producto: snapshot.docs[index]['producto'],
      precio: snapshot.docs[index]['precio'],
      nota: snapshot.docs[index]['nota'],
      id: snapshot.docs[index].id,
    );
  }
}
