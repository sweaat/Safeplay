import 'package:flutter/material.dart';
import 'Accueil.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
        ),
      ),
      home: SafeplayApp(),
    );
  }
}


