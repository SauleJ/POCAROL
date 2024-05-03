import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RequestsHandling.dart';
import 'LoginPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserPostsPage(),
  ));
}

class UserPostsPage extends StatefulWidget {
  @override
  _UserPostsPageState createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  List<Post> userPosts = [];
  late Map<String, dynamic> userdata; // Declaration for userdata

  @override
  void initState() {
    super.initState();
    initializeUser(); // Call function to initialize user data
  }

  Future<void> initializeUser() async {
    try {
      // Fetch user data by token
      final userData = await getUserByToken(globalToken!);
      setState(() {
        userdata = userData;
      });
      // Fetch user posts after getting user data
      fetchUserPosts(userdata['_id']);
    } catch (error) {
      print('Error initializing user: $error');
    }
  }

  Future<Map<String, dynamic>> getUserByToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getUserByToken/$token'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData;
      } else {
        throw Exception('Failed to load user data by token: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch user data by token: $error');
    }
  }

  Future<void> fetchUserPosts(userId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/getPostsByUserId/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          userPosts = jsonData.map((postJson) => Post.fromJson(postJson)).toList();
        });
      } else {
        print('Failed to fetch user posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Posts'),
      ),
      body: Container(
        color: Color.fromRGBO(128, 0, 0, 1), // Red background color
        child: ListView.builder(
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            final post = userPosts[index];
            return Card(
              elevation: 4, // Add elevation for shadow
              margin: EdgeInsets.all(8), // Add margin around the card
              child: ListTile(
                title: Text('Post ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${post.fromCity}'),
                    Text('To: ${post.toCity}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestsHandling(postId: post.id),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Post {
  final String id;
  final String fromCity;
  final String toCity;
  final String description;

  Post({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'], // Use '_id' instead of 'id'
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      description: json['description'],
    );
  }
}
