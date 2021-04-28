import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_diego_lechona/domain/entities/User.dart';
import 'package:demo_diego_lechona/domain/repositories/abstract_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';

class RepositoryAlterno extends AbstractRepository2 {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Users users = Users();

  @override
  Future getTimeNow() async {
    final DateTime data = DateTime.now();
    final timedb = DateFormat('yyyy-MM-dd').format(data);
    try {
      final resp = await _firestore
          .collection('PedidosChef')
          .where('timechef', isEqualTo: timedb)
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future getTimeTable(String fecha) async {
    final DateTime data = DateTime.parse(fecha);
    final timedb = DateFormat('yyyy-MM-dd').format(data);
    try {
      final resp = await _firestore
          .collection('PedidosChef')
          .where('timechef', isEqualTo: timedb)
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updatenumbre(
      {String phone, String fullName, String email, String direccion}) async {
    try {
      final resp = await _firestore
          .collection('users')
          .where('direccion', isEqualTo: direccion)
          .where('fullName', isEqualTo: fullName)
          .where('email', isEqualTo: email)
          .get();
      final id = resp.docs[0].id;
      await _firestore
          .collection('users')
          .doc(id)
          .set({'telefono': phone}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e.toString);
      return false;
    }
  }

  @override
  Future getconsolidadonow() async {
    final DateTime data = DateTime.now();
    final timedb = DateFormat('yyyy-MM-dd').format(data);
    try {
      final resp = await _firestore
          .collection('pedidos')
          .where('timechef', isEqualTo: timedb)
          .where('staterepartidor', isEqualTo: 'Entregado')
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future getconsolidadodate({String date}) async {
    try {
      DateTime time = DateTime.parse(date);
      final timesearch = DateFormat('yyyy-MM-dd').format(time);
      final resp = await _firestore
          .collection('pedidos')
          .where('timechef', isEqualTo: timesearch)
          .where('staterepartidor', isEqualTo: 'Entregado')
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future getpedidoschefnow() async {
    final DateTime data = DateTime.now();
    final timedb = DateFormat('yyyy-MM-dd').format(data);
    int number = 0, result = 0;
    try {
      final resp = await _firestore.collection('PedidosChef').get();
      print(resp.docs.length);
      final respnow = await _firestore
          .collection('PedidosChef')
          .where('timechef', isEqualTo: timedb)
          .get();
      print(respnow.docs.length);
      for (int i = 0; i < resp.docs.length; i++) {
        number = respnow.docs[i]['Cantidad'];
        print(number);
        result = (result + number);
      }
      print('Este es el resultado');
      print(result);
      return result;
    } catch (e) {
      print(e.toString());
      return result;
    }
  }

  @override
  Future getpedidoschefdate({String fecha}) async {
    final DateTime data = DateTime.parse(fecha);
    final timedb = DateFormat('yyyy-MM-dd').format(data);
    int number = 0, result = 0;
    try {
      final resp = await _firestore.collection('PedidosChef').get();
      print(resp.docs.length);
      final respnow = await _firestore
          .collection('PedidosChef')
          .where('timechef', isEqualTo: timedb)
          .get();
      print(respnow.docs.length);
      for (int i = 0; i < resp.docs.length; i++) {
        number = respnow.docs[i]['Cantidad'];
        print(number);
        result = (result + number);
      }
      print('Este es el resultado');
      print(result);
      return result;
    } catch (e) {
      print(e.toString());
      return result;
    }
  }

  @override
  Future searchusers() async {
    try {
      final resp = await _firestore.collection('users').get();
      return resp;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future deleteUser(
      {String email, String name, String role, String phone}) async {
    try {
      final resp = await _firestore
          .collection('users')
          .where('fullName', isEqualTo: name)
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: role)
          .where('telefono', isEqualTo: phone)
          .get();
      await _firestore.collection('users').doc(resp.docs[0].id).delete();
      return resp;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future pedidosporpagas() async {
    final String uid = _firebaseAuth.currentUser.uid;
    final data = await _firestore.collection('users').doc(uid).get();
    final name = data.data()['fullName'];
    dynamic now = DateTime.now();
    print(now);
    String format = DateFormat('yyyy-MM-dd').format(now);
    print(format);
    try {
      final resp = await _firestore
          .collection('pedidos')
          .where('repartidor', isEqualTo: name)
          .where('staterepartidor', isEqualTo: 'Entregado')
          .where('timechef', isEqualTo: format)
          .where('statecaja', isEqualTo: 'no cancelado')
          .get();
      return resp;
    } catch (e) {
      return null;
    }
  }

  @override
  Future revisiondepedidosporpagar(String nombre, String phone) async {
    final uid = await _firestore
        .collection('users')
        .where('fullName', isEqualTo: nombre)
        .where('telefono', isEqualTo: phone)
        .get();
    final data = await _firestore.collection('users').doc(uid.docs[0].id).get();
    final name = data.data()['fullName'];
    dynamic now = DateTime.now();
    print(now);
    String format = DateFormat('yyyy-MM-dd').format(now);
    print(format);
    try {
      final resp = await _firestore
          .collection('pedidos')
          .where('repartidor', isEqualTo: name)
          .where('staterepartidor', isEqualTo: 'Entregado')
          .where('statecaja',isEqualTo: 'no cancelado')
          .where('timechef', isEqualTo: format)
          .get();
      return resp;
    } catch (e) {
      return null;
    }
  }

  @override
  Future confirmcaja(
      {String phone,
      String name,
      String fecha,
      int precio,
      String direccion}) async {
    try {
      final resp = await _firestore
          .collection('pedidos')
          .where('telefono', isEqualTo: phone)
          .where('repartidor', isEqualTo: name)
          .where('fecha', isEqualTo: fecha)
          .where('precio', isEqualTo: precio)
          .where('direccion', isEqualTo: direccion)
          .get();
      await _firestore
          .collection('pedidos')
          .doc(resp.docs[0].id)
          .set({'statecaja': 'Entregado'}, SetOptions(merge: true));
      return resp;
    } catch (e) {
      return null;
    }
  }
}
