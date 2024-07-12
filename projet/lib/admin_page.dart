import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/admin.php');
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
        });
      } else {
        print('Failed to load users. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _deleteUser(int userId) async {
    var url = Uri.parse('http://10.0.2.2/projet/apiprojet/controller/users.php?id=$userId');
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        print('User deleted successfully');
        _fetchUsers(); // Refresh the user list
      } else {
        print('Failed to delete user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]['Username']),
            subtitle: Text(users[index]['Email']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteUser(users[index]['User_ID']);
              },
            ),
          );
        },
      ),
    );
  }
}
