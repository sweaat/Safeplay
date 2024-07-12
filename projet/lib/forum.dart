import 'package:flutter/material.dart';
import 'login_page.dart';
import 'create_account_page.dart';
import 'decouvrir_jeux.dart';
import 'edit_profile.dart';
import 'admin_page.dart';
import 'forum.dart';
import 'support.dart';
import 'forum_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'accueil.dart';

class ForumPage extends StatefulWidget {
  final String? username;

  ForumPage({this.username});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<dynamic> forums = [];
  List<dynamic> filteredForums = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchForums();
    searchController.addListener(_filterForums);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterForums);
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchForums() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/forums');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          forums = jsonDecode(response.body);
          filteredForums = forums;
        });
      } else {
        print('Failed to load forums');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterForums() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredForums = forums;
      } else {
        filteredForums = forums.where((forum) {
          final title = forum['Title'].toLowerCase();
          final description = forum['Description'].toLowerCase();
          return title.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  void _onMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'Accueil':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SafeplayHomePage(username: widget.username)),
        );
        break;
      case 'Découvrir un jeu':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscoverGamesPage()),
        );
        break;
      case 'Forum':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumPage(username: widget.username)),
        );
        break;
      case 'Messagerie':
      // Navigate to Messagerie
        break;
      case 'Support':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupportPage()),
        );
        break;
    }
  }

  void _showAddForumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Forum'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                  // Show error if fields are empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Title and Description cannot be empty')),
                  );
                } else {
                  _addForum();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addForum() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/forums');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Title': titleController.text,
          'Description': descriptionController.text,
        }),
      );
      if (response.statusCode == 201) {
        await _fetchForums(); // Refresh the forums list
        setState(() {
          titleController.clear();
          descriptionController.clear();
        });
        Navigator.of(context).pop(); // Close the form dialog
      } else {
        print('Failed to add forum');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SafeplayHomePage(username: widget.username)),
          ),
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
          if (widget.username == null) ...[
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
                      return Colors.transparent;
                    },
                  ),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered) ||
                          states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.white.withOpacity(0.12);
                      }
                      return Colors.transparent;
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
          ],
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredForums.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.black54,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredForums[index]['Title'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            filteredForums[index]['Description'],
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForumDetailsPage(
                                    forumId: filteredForums[index]['Forum_ID'],
                                    forumTitle: filteredForums[index]['Title'],
                                  ),
                                ),
                              );
                            },
                            child: const Text('Lire plus',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.username != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: _showAddForumDialog,
                    child: Icon(Icons.add),
                    backgroundColor: Color(0xFF00BFA5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
