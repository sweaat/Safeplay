import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For using jsonEncode and jsonDecode
import 'accueil.dart'; // Make sure this is pointing to the correct file
import 'create_account_page.dart'; // Make sure this file exists
import 'forgot_password.dart'; // Make sure this file exists

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false; // Boolean to track the checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.2, 1.3), // Start of gradient slightly off to the bottom right
                end: Alignment(1.3, -0.5), // End of gradient slightly off to the top left
                colors: [
                  Color(0xFFCC97F4),
                  Color(0xFF722BFF),
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
                Navigator.of(context).pop();
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
                    _buildLoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 20, fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            "Glad you're back!",
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
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
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
                colors: [Colors.black, Color(0xFF722BFF), Colors.black],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ElevatedButton(
              onPressed: _login,
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Color(0xFF6200EA)),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Don't have an account?",
            style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: const Text(
              'Signup',
              style: TextStyle(fontFamily: 'NotoSans-SemiBold', color: Color(0xFF6200EA)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _login() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/users');
    try {
      var response = await http.post(url, body: jsonEncode({
        'Username': _usernameController.text,
        'Password': _passwordController.text,
      }), headers: {
        'Content-Type': 'application/json',
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SafeplayHomePage(username: data['Username']),
              ),
            );
          } else {
            _showDialog('Login Failed', 'No user found with these credentials!');
          }
        } catch (e) {
          _showDialog('Error', 'Invalid response format: ${response.body}');
          print('Error: $e');
        }
      } else if (response.statusCode == 400) {
        _showDialog('Error', 'Bad Request: ${response.body}');
      } else {
        _showDialog('Error', 'Failed to connect to the server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog('Error', 'An error occurred: $e');
      print('Error: $e');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }
}
