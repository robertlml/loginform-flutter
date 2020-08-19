import 'package:flutter/material.dart';
import 'package:loginform/src/blocs/provider.dart';
import 'package:loginform/src/pages/home_page.dart';
import 'package:loginform/src/pages/login_page.dart';
import 'package:loginform/src/pages/producto_page.dart';
import 'package:loginform/src/pages/registro_page.dart';
import 'package:loginform/src/preferencias_usuario/preferencia_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Provider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MATERIAL APP',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'registro': (BuildContext context) => RegistroPage(),
        'home': (BuildContext context) => HomePage(),
        'producto': (BuildContext context) => ProductoPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
