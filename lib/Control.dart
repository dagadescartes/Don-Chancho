import 'package:demo_diego_lechona/UI/Pages/Authenticate/Login&Register&Forget/Login.dart';
import 'package:demo_diego_lechona/data/Repository/auth.dart';
import 'package:demo_diego_lechona/Wrapper.dart';
import 'package:flutter/material.dart';

///
///
/// [true] evalua los roles, [false] nos lleva a login
///
class Control extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (AuthService().isAuth == true) {
      return Wrapper();
    } else {
      return Login();
    }
  }
}
