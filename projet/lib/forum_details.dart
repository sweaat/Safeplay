import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumDetailsPage extends StatefulWidget {
  final int forumId;
  final String forumTitle;

  ForumDetailsPage({required this.forumId, required this.forumTitle});

  @override
  _ForumDetailsPageState createState() => _ForumDetailsPageState();
}

class _ForumDetailsPageState extends State<ForumDetailsPage> {
  List<dynamic> forumPosts = [];
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchForumPosts();
  }

  Future<void> _fetchForumPosts() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/forumposts?Forum_ID=${widget.forumId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          forumPosts = jsonDecode(response.body);
        });
      } else {
        print('Failed to load forum posts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Post'),
          content: TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (contentController.text.isEmpty) {
                  // Show error if field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Content cannot be empty')),
                  );
                } else {
                  _addPost();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPost() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/forumposts');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Forum_ID': widget.forumId,
          'Content': contentController.text,
          'User_ID': 1, // Example user ID, replace with actual user ID
        }),
      );
      if (response.statusCode == 201) {
        await _fetchForumPosts(); // Refresh the forum posts list
        setState(() {
          contentController.clear();
        });
        Navigator.of(context).pop(); // Close the form dialog
      } else {
        print('Failed to add post');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forumTitle),
        backgroundColor: Colors.black,
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: forumPosts.length,
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
                            forumPosts[index]['Content'],
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Posted by: User ${forumPosts[index]['User_ID']}', // Example, replace with actual username
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (true) // Replace with actual check for logged in user
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: _showAddPostDialog,
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
