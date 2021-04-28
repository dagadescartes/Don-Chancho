import 'package:demo_diego_lechona/domain/entities/User.dart';
import 'package:demo_diego_lechona/domain/repositories/abstract_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends AbstractRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fr = FirebaseFirestore.instance;
  
  // Stream o 'Rio' que controla el flujo de autenticacion.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  // Con esto ya tienes el id del usuario en el caso de que este logueado
  String get userUid => _firebaseAuth.currentUser.uid;

  // Saber si esta logueado
  bool get isAuth =>
      _firebaseAuth.currentUser != null &&
      _firebaseAuth.currentUser.uid != null;

  //Saber el displayName
  String get getDisplayName => _firebaseAuth.currentUser.displayName;

  //Inicio de sesion
  Future signInWithEmailAndPassword(
      String email, String password, String cargoval) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final userrole =
          (await _fr.collection('users').doc(user.user.uid).get()).data();
      final String role = userrole['role'];
      if (role == cargoval) {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String cargoval,
      String telefono,
      String direccion) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _fr.collection("users").doc(credentials.user.uid).set({
        'email': email,
        'fullName': fullName,
        'createdAt': DateTime.now().toIso8601String(),
        'role': cargoval,
        'telefono': telefono,
        'direccion': direccion
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Ya aqui sabes el usuario que rol tiene, pero para ello al registrarse debes darle un rol inicial
  Future<String> getRole() async {
    final userDoc =
        (await _fr.collection("users").doc(this.userUid).get()).data();
    final String role = userDoc['role'];

    if (role != null) {
      switch (role) {
        case "Vendedor":
          return '/Vendedor';
          break;
        case "Administrador":
          return '/Administrador';
          break;
        case "Cocina":
          return "/Cocina";
          break;
        case "Domiciliario":
          return "/Domiciliario";
          break;
        default:
          return null;
      }
    } else {
      return 'null';
    }
  }

  @override
  Future<Users> singIn({
    @required String email,
    @required String password,
    @required String cargoval,
  }) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userrole =
          (await _fr.collection('users').doc(user.user.uid).get()).data();
      final String role = userrole['role'];
      if (role == cargoval) {
        return Users();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> recoverypassword({String email}) async {
    try {
      final user = await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return null;
    }
  }

  @override
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
