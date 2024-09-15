import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import 'ChatPage.dart';

void main() {
  runApp(MaterialApp(
    home: ChatListPage(),
  ));
}

class Post {
  final String id;
  final String fromCity;
  final String toCity;
  final String date;

  Post({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      date: json['date'],
    );
  }
}

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPostsByUserIdWithTrueStateUsers();
  }

  Future<void> fetchPostsByUserIdWithTrueStateUsers() async {
    try {
      final userData = await getUserByToken(globalToken!);
      final userId = userData['_id'];
      final response = await http.get(Uri.parse('http://localhost:3000/getPostsByUserIdWithTrueStateUsers/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          posts = jsonData.map((postJson) => Post.fromJson(postJson)).toList();
        });
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching posts: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: Icon(
                Icons.person_4_outlined,
                size: 40,
                color: Colors.black,
              ),
              title: Text(
                post.fromCity,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.toCity,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    post.date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              onTap: () async {
                final userData = await getUserByToken(globalToken!);
                final senderId = userData['_id'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(postId: post.id, senderId: senderId),
                    ),
                  );
                },
            ),
          );
        },
      ),
    );
  }
}