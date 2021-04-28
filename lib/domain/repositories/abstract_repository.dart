import 'package:demo_diego_lechona/domain/entities/User.dart';

abstract class AbstractRepository {
  Future<Users> singIn({String email, String password, String cargoval});

  Future signOut();

  Future<bool> recoverypassword({String email});
}

abstract class AbstractRepository2 {
  Future<bool> updatenumbre(
      {String phone, String fullName, String email, String direccion});

  Future getTimeNow();

  Future getTimeTable(String fecha);

  Future getconsolidadonow();

  Future getconsolidadodate({String date});

  Future getpedidoschefnow();

  Future getpedidoschefdate({String fecha});

  Future searchusers();

  Future deleteUser({String email, String name, String role, String phone});

  Future pedidosporpagas();

  Future revisiondepedidosporpagar(String nombre, String phone);

  Future confirmcaja(
      {String phone, String name, String fecha, int precio, String direccion});
}
