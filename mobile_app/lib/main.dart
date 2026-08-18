import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const FitBackApp());
}

class FitBackApp extends StatelessWidget {
  const FitBackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitBack',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
//Hola Alfonso creo que ya esta listo el proyecto, si quieres podemos hacer una videollamada para que me digas que mas quieres agregarle al proyecto.