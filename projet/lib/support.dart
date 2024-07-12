import 'package:flutter/material.dart';
import 'login_page.dart'; // Import login page
import 'create_account_page.dart'; // Import create account page
import 'accueil.dart'; // Import the HomePage
import 'decouvrir_jeux.dart' as decouvrir; // Import DiscoverGamesPage with alias
import 'forum.dart'; // Import the ForumPage

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  void _onMenuItemSelected(BuildContext context, String value) {
    // Handle the menu item selection
    switch (value) {
      case 'Accueil':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SafeplayHomePage()), // Navigate to HomePage
        );
        break;
      case 'Découvrir un jeu':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => decouvrir.DiscoverGamesPage()), // Navigate to DiscoverGamesPage
        );
        break;
      case 'Forum':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumPage()),  // Navigate to ForumPage
        );
        break;
      case 'Messagerie':
      // Navigate to Messagerie
        break;
      case 'Support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupportPage()), // Navigate to SupportPage
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'safeplay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                'Sign In',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) => _onMenuItemSelected(context, value),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Accueil',
                  child: Text('Accueil'),
                ),
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
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1D1E33),
              Color(0xFF311B92),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Text(
                      'Support',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Si vous avez des questions ou avez besoin d\'aide, veuillez nous contacter à l\'adresse suivante :',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'support@safeplay.com',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Questions Fréquemment Posées',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ExpansionTile(
                    title: Text(
                      'Comment puis-je créer un compte ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white, // Flèches blanches
                    collapsedIconColor: Colors.white, // Flèches blanches
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pour créer un compte, cliquez sur le bouton "Sign Up" en haut à droite de la page d\'accueil et remplissez les informations requises.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Comment puis-je réinitialiser mon mot de passe ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white, // Flèches blanches
                    collapsedIconColor: Colors.white, // Flèches blanches
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pour réinitialiser votre mot de passe, cliquez sur "Forgot Password" sur la page de connexion et suivez les instructions.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text(
                      'Comment contacter le support ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white, // Flèches blanches
                    collapsedIconColor: Colors.white, // Flèches blanches
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Vous pouvez nous contacter par email à support@safeplay.com ou via nos réseaux sociaux.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
