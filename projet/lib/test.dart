import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Application"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Action lorsque l'utilisateur appuie sur l'icône de connexion
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Action lorsque l'utilisateur appuie sur un bouton
            },
            child: Card(
              elevation: 4,
              child: Center(
                child: Text(
                  _getButtonText(index), // Remplacez par vos libellés
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getButtonText(int index) {
    switch (index) {
      case 0:
        return "Accueil";
      case 1:
        return "Actualités";
      case 2:
        return "Forums";
      case 3:
        return "Messagerie";
      case 4:
        return "Support";
      case 5:
        return "S'inscrire";
      default:
        return "";
    }
  }
}
