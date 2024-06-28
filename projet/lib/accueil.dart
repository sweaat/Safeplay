import 'package:flutter/material.dart';
import 'login_page.dart';
import 'create_account_page.dart';
import 'decouvrir_jeux.dart'; // Import the DiscoverGamesPage
import 'forum.dart'; // Import the ForumPage

void main() {
  runApp(SafeplayApp());
}

class SafeplayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeplayHomePage(),
    );
  }
}

class SafeplayHomePage extends StatelessWidget {
  final String? username;

  SafeplayHomePage({this.username});

  void _onMenuItemSelected(BuildContext context, String value) {
    // Handle the menu item selection
    switch (value) {
      case 'Découvrir un jeu':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscoverGamesPage()), // Navigate to DiscoverGamesPage
        );
        break;
      case 'Forum':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumPage()), // Navigate to ForumPage
        );
        break;
      case 'Messagerie':
      // Navigate to Messagerie
        break;
      case 'Support':
      // Navigate to Support
        break;
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          // Wireframe pattern (Resized)
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/image_accueil.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width, // Width of the screen
                height: MediaQuery.of(context).size.height, // Height of the screen
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BIENVENUE\nSUR SAFEPLAY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (username != null)
                  Column(
                    children: [
                      Text(
                        'Bienvenue, $username!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return Colors.transparent; // Transparent by default
                            },
                          ),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.12);
                              }
                              return Colors.transparent; // Default color
                            },
                          ),
                        ),
                        onPressed: () => _logout(context),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (username == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return Colors.transparent; // Transparent by default
                            },
                          ),
                          overlayColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.12);
                              }
                              return Colors.transparent; // Default color
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF3133B1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Dropdown Menu
          Positioned(
            top: 40,
            right: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) => _onMenuItemSelected(context, value),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Découvrir un jeu',
                    child: Text('Découvrir un jeu'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Forum',
                    child: Text('Forum'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Messagerie',
                    child: Text('Messagerie'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Support',
                    child: Text('Support'),
                  ),
                ];
              },
            ),
          ),
          // Safeplay logo
          const Positioned(
            top: 40,
            left: 20,
            child: Text(
              'safeplay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
