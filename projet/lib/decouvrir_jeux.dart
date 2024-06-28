import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'game.dart';
import 'info_jeux.dart';
import 'login_page.dart'; // Import login page
import 'create_account_page.dart'; // Import create account page

class DiscoverGamesPage extends StatefulWidget {
  @override
  _DiscoverGamesPageState createState() => _DiscoverGamesPageState();
}

class _DiscoverGamesPageState extends State<DiscoverGamesPage> {
  final String apiKey = '2a1d014aff3047c89633948844735bfb';
  List<Game> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final response = await http.get(
        Uri.parse('https://api.rawg.io/api/games?key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        games = (data['results'] as List)
            .map((gameData) => Game.fromJson(gameData))
            .toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<Game> fetchGameDetails(String gameId) async {
    final response = await http.get(
        Uri.parse('https://api.rawg.io/api/games/$gameId?key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Game.fromJson(data);
    } else {
      throw Exception('Failed to load game details');
    }
  }

  void _onMenuItemSelected(BuildContext context, String value) {
    // Handle the menu item selection
    switch (value) {
      case 'Accueil':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiscoverGamesPage()),
        );
        break;
      case 'Découvrir un jeu':
      // Navigate to Découvrir un jeu
        break;
      case 'Forum':
      // Navigate to Forum
        break;
      case 'Messagerie':
      // Navigate to Messagerie
        break;
      case 'Support':
      // Navigate to Support
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
            begin: Alignment(0.2, 1.3),
            end: Alignment(1.3, -0.5),
            colors: [
              Color(0xFF00BFA5),
              Color(0xFF3133B1),
              Colors.black,
            ],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.black54,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(games[index].backgroundImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      games[index].name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Sortie: ${games[index].released}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Note Metacritic: ${games[index].rating}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Genres: ${games[index].genres.join(', ')}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        final gameDetails = await fetchGameDetails(games[index].id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameInfoPage(game: gameDetails),
                          ),
                        );
                      },
                      child: const Text('Lire plus',
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
