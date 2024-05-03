import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Message {
  final String senderId;
  final String message;
  final String username;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.message,
    required this.username,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  final String postId;
  final String senderId;

  ChatScreen({required this.postId, required this.senderId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchChatMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchChatMessages() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getChatMessages/${widget.postId}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            _messages.addAll(jsonData.map((message) => Message(
                  senderId: message['senderID'],
                  message: message['message'],
                  username: message['senderUsername'],
                  timestamp: DateTime.parse(message['timestamp']),
                )));
          });
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });
        }
      } else {
        print('Failed to fetch chat messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching chat messages: $error');
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    final newMessage = Message(
      senderId: widget.senderId,
      message: text,
      username: 'Me',
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(newMessage);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/saveChatMessages'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'postId': widget.postId,
          'message': text,
          'senderId': widget.senderId,
        }),
      );

      if (response.statusCode == 200) {
        print('Message saved successfully');
      } else {
        print('Failed to save message: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat Name',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: _messages.map((message) {
                  final isMe = message.senderId == widget.senderId;
                  return _buildMessageBubble(isMe, message);
                }).toList(),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Type'),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(bool isMe, Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.white : Color.fromARGB(255, 33, 135, 152),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? 'Me' : message.username,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                message.message,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
