import 'package:flutter/material.dart';
import 'login_page.dart'; // Importez votre page d'accueil
import 'create_account_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.2, 1.3),  // Début du dégradé légèrement décalé vers le bas à droite
                end: Alignment(1.3, -0.5),  // Fin du dégradé légèrement décalé vers le haut à gauche
                colors: [
                  Color(0xFFE145B3),
                  Color(0xFF74032C),
                  Colors.black,
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildForgotPasswordForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Forgot Password',
            style: TextStyle(fontSize: 20, fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter your email to reset your password",
            style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            style: const TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle password reset action
            },
            child: const Text('Reset Password'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAA246F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              textStyle: const TextStyle(fontFamily: 'NotoSans-SemiBold'),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Don't have an account?",
            style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              // Naviguer vers la page de création de compte
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: const Text(
              'Signup',
              style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Color(0xFFAA246F)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
