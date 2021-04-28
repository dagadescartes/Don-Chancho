import 'package:flutter/material.dart';
import 'package:demo_diego_lechona/Control.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:demo_diego_lechona/UI/Pages/Routes/Routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('es', ''), // Spanish, no country code
      ],
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'Donchancho',
      home: Control(),
      theme: ThemeData(
        primaryColor: Color(0xffFFFFFF),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Color(0xffFFFFFF),
          ),
          headline2: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
