import 'package:flutter/material.dart';
import 'BottomNavigationBar.dart';
import 'package:namer_app/PostList.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ChatScreen(),
    );
  }
}
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(0, text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //--- Top Bar -BEGIN- ---//
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chat Name', //CHAT NAME RANDOMIZER !CHANGE!
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => DestinationListPage()));
          },
        ),
      ),
      //--- Top Bar -END- ---//
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Column(
        children: <Widget>[
          //--- Display Chat -BEGIN- ---//
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = true;
                return _buildMessageBubble(isMe, message);
              },
            ),
          ),
          //--- Display Chat -END- ---//
          //--- Typing Box -BEGIN- ---//
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
          //--- Typing Box -END- ---//
        ],
      ),
    );
  }
}
//--- Display Chat -BEGIN- ---//
Widget _buildMessageBubble(bool isMe, String message) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    child: Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Me', //ACCORDING TO USER !CHANGE!
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
//--- Display Chat -END- ---//


