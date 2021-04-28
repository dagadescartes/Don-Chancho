import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class BlocOtherRepository {
  FirebaseFirestore _fr = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage _st = FirebaseStorage.instance;

  String get currentUsername => FirebaseAuth.instance.currentUser.displayName;

  Future<void> getCredentialUser(
      Function(DocumentSnapshot userDocument) onState) async {
    _firebaseAuth.authStateChanges().listen((event) async {
      final response = await _fr.collection('users').doc(event.uid).get();
      onState(response);
    });
  }

  Future setPedidos(
      int cantidadchef,
      String email,
      String direction,
      String name,
      String note,
      int price,
      String product,
      String phone,
      String fecha,
      String person) async {
    String repartidor = 'no signado';
    String staterepatidor = 'pendiente';
    String statecaja = 'no cancelado';
    try {
      DateTime date = DateTime.parse(fecha);
      final timedb = DateFormat('yyyy-MM-dd').format(date);
      final hourdb = DateFormat('h:mm a').format(date);
      await _fr.collection('pedidos').doc().set({
        'email': email,
        'direccion': direction,
        'name': name,
        'precio': price,
        'producto': product,
        'telefono': phone,
        'fecha': fecha,
        'person': person,
        'repartidor': repartidor,
        'staterepartidor': staterepatidor,
        'statecaja': statecaja,
        'nota': note,
        'timechef': timedb
      });
      await _fr.collection('PedidosChef').doc().set({
        'Producto': product,
        'Cantidad': cantidadchef,
        'timechef': timedb,
        'index': 1,
        'hour': hourdb
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future setProductos(String name, String person, String tipo, int precio,
      String description, File image) async {
    try {
      //Aqui es donde guardo la imagen en Storage
      final postimageRef = _st.ref().child('setProductos');
      var timekey = DateTime.now();

      final UploadTask uploadTask =
          postimageRef.child(timekey.toString() + '.jpg').putFile(image);
      var urlImage = await (await uploadTask).ref.getDownloadURL();
      var url = urlImage;
      // Aqui es donde guardo el producto en Cloud FireStore
      await _fr.collection(tipo).doc().set({
        'name': name,
        'tipo': tipo,
        'url': url,
        'descripcion': description,
        'price': precio,
        'person': person
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future getRepartidores(Function(QuerySnapshot userDocuments) onState) async {
    try {
      final resp = await _fr
          .collection('users')
          .where('role', isEqualTo: 'Repartidor')
          .get();
      onState(resp);
    } catch (e) {
      return null;
    }
  }

  Future getDataUserPedidos(String phone) async {
    try {
      final QuerySnapshot resp = await _fr
          .collection('pedidos')
          .where('telefono', isEqualTo: phone)
          .get();
      return resp.docs.length != 0 ? resp : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getPedidos() async {
    try {
    final timedb = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    print(timedb);
      final resp = (await _fr
          .collection('pedidos')
          .where('fecha',isLessThan: timedb)
          .get());
      return resp;
    } catch (e) {
      return null;
    }
  }

  Future getCojines() async {
    return await _fr.collection('Cojines').get();
  }

  Future getLechona() async {
    return await _fr.collection('Lechonas').get();
  }

  Future updateRepartidor(String fecha, String direccion, String producto,
      String correo, String phone, String namerepartidor) async {
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('fecha', isEqualTo: fecha)
          .where('direccion', isEqualTo: direccion)
          .where('producto', isEqualTo: producto)
          .where('email', isEqualTo: correo)
          .where('telefono', isEqualTo: phone)
          .get();
      final id = resp.docs[0].id;
      await _fr
          .collection('pedidos')
          .doc(id)
          .set({'repartidor': namerepartidor}, SetOptions(merge: true));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future pedidospendientes(format) async {
    final String uid = _firebaseAuth.currentUser.uid;
    final data = await _fr.collection('users').doc(uid).get();
    final name = data.data()['fullName'];
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('repartidor', isEqualTo: name)
          .where('staterepartidor', isEqualTo: 'pendiente')
          .where('fecha', isGreaterThan: format)
          .get();
      return resp;
    } catch (e) {
      return null;
    }
  }

  Future getpedidosentregados() async {
    final String uid = await _firebaseAuth.currentUser.uid;
    final data = await _fr.collection('users').doc(uid).get();
    final name = data.data()['fullName'];
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('repartidor', isEqualTo: name)
          .where('staterepartidor', isEqualTo: 'Entregado')
          .get();
      return resp;
    } catch (e) {
      return null;
    }
  }

  Future getpedidosrechazados() async {
    final uid = await _firebaseAuth.currentUser.uid;
    final data = await _fr.collection('users').doc(uid).get();
    final name = data.data()['fullName'];
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('repartidor', isEqualTo: name)
          .where('staterepartidor', isEqualTo: 'Rechazada')
          .get();
      return resp;
    } catch (e) {
      return null;
    }
  }

  Future getPendientes() async {
    try {
      final resp = _fr
          .collection('pedidos')
          .where('staterepartidor', isEqualTo: 'pendiente')
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getPedidoEntregadosTotal() async {
    try {
      final resp = _fr
          .collection('pedidos')
          .where('staterepartidor', isEqualTo: 'Entregado')
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getOrdenesAtrazadas(String time) async {
    DateTime date = DateTime.parse(time);
    final timedb = DateFormat('yyyy-MM-dd HH:mm').format(date);
    print(timedb);
    final resp = await _fr
        .collection('pedidos')
        .where('staterepartidor', isEqualTo: "pendiente")
        .where('fecha', isLessThan: timedb)
        .get();
    return resp;
  }

  Future getAdminTotalPedidos() async {
    final resp = await _fr
        .collection('pedidos')
        .where('staterepartidor', isEqualTo: 'Entregado')
        .get();
    final data = resp;
    return data;
  }

  Future getOrdenesRechazadas() async {
    try {
      final resp = _fr
          .collection('pedidos')
          .where('staterepartidor', isEqualTo: 'Rechazada')
          .get();
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future pedidosEntregados(String direccion, String fecha, int precio,
      String name, String estado) async {
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('direccion', isEqualTo: direccion)
          .where('fecha', isEqualTo: fecha)
          .where('precio', isEqualTo: precio)
          .where('name', isEqualTo: name)
          .get();
      final id = resp.docs[0].id;
      await _fr
          .collection('pedidos')
          .doc(id)
          .set({'staterepartidor': estado}, SetOptions(merge: true));
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future pedidosRechazados(String direccion, String fecha, int precio,
      String name, String estado) async {
    try {
      final resp = await _fr
          .collection('pedidos')
          .where('direccion', isEqualTo: direccion)
          .where('fecha', isEqualTo: fecha)
          .where('precio', isEqualTo: precio)
          .where('name', isEqualTo: name)
          .get();
      final id = resp.docs[0].id;
      await _fr
          .collection('pedidos')
          .doc(id)
          .set({'staterepartidor': estado}, SetOptions(merge: true));
      return resp;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
