import 'package:flutter/material.dart';
import 'Accueil.dart'; // Importez la page d'accueil
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Ajoutez une variable booléenne pour maintenir l'état de la case à cocher
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Rend le fond transparent
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.2, 1.3),
                end: Alignment(1.3, -0.5),
                colors: [
                  Color(0xFF3DC85C),
                  Color(0xFF2FA16D),
                  Colors.black,
                ],
              ),
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
                    _buildSignupForm(),
                  ],
                ),
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
                  MaterialPageRoute(builder: (context) => SafeplayApp()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Create Account',
            style: TextStyle(fontSize: 20, fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Glad you're here!",
            style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
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
          TextField(
            controller: _emailController,
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
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            style: const TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: _rememberMe, // Utilisez la variable d'état pour initialiser la valeur de la case à cocher
                onChanged: (bool? value) {
                  // Mettez à jour l'état de la case à cocher lorsque l'utilisateur clique dessus
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: Colors.green, // Changer la couleur de fond de la case à cocher
              ),
              const Text(
                'Remember me',
                style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF3DC85C), Colors.black,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Handle login action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontFamily: 'NotoSans-SemiBold'),
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Don't have an account?",
            style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              // Naviguer vers la page de connexion
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text(
              'Signin',
              style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Color(0xFF3DC85C)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
