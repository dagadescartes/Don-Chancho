
import 'package:demo_diego_lechona/domain/entities/User.dart';
import 'package:mockito/mockito.dart';
import 'package:demo_diego_lechona/domain/repositories/abstract_repository.dart';

class MockTest extends Mock implements AbstractRepository {
  @override
  Future<bool> recoverypassword({String email}) {
    // Test recoverypassword in process the implements
    throw UnimplementedError();
  }

  @override
  Future signOut() {
    //Test signOut in process the implements
    throw UnimplementedError();
  }

  @override
  Future<Users> singIn({String email, String password, String cargoval}) {
    //Test SignIn in process the implements
    throw UnimplementedError();
  }
  
}