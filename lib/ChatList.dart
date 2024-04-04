import 'package:flutter/material.dart';
import 'BottomNavigationBar.dart';
import 'ChatPage.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //--- Top Bar -BEGIN- ---//
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.white,
      ),
      //--- Top Bar -END- ---//
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      //--- Chat List -BEGIN- ---//
            body: ListView.builder(
        itemCount: 3, // Number of chat items
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0), 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ChatListItem(
              iconData: Icons.person_4_outlined,
              name: 'Chat Name ${index + 1}', //CHAT NAME RANDOMIZER !CHANGE!
              toCity: 'Destination: Vilnius', //DESTINATION CITY !CHANGE!
              date: '2024-05-05',
              //--- Aditional Attributes -BEGIN- ---//
              lastMessage: 'This is the last message in the chat.',
              time: '10:30 AM', // Last message time
              unreadCount: index % 3 == 0 ? 0 : index % 3,
              //--- Aditional Attributes -END- ---//
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => ChatApp()));
              },
            ),
          );
        },
      ),
      //--- Chat List -END- ---//
      //--- Bottom Navigation -BEGIN- ---//
      bottomNavigationBar: MyBottomNavigationBar(),
      //--- Bottom Navigation -END- ---//
    );
  }
}

class ChatListItem extends StatelessWidget {
  final IconData iconData;
  final String name;
  final String toCity;
  final String date;
  //--- Aditional Attributes -BEGIN- ---//
  final String lastMessage;
  final String time;
  final int unreadCount;
  //--- Aditional Attributes -END- ---//
  final VoidCallback onTap;

  const ChatListItem({
    required this.iconData,
    required this.name,
    required this.toCity,
    required this.date,
    //--- Aditional Attributes -BEGIN- ---//
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    //--- Aditional Attributes -END- ---//
    required this.onTap,
  });

//--- Chat List Theme -BEGIN- ---//
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        size: 40,
        color: Colors.black,
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toCity,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            date,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
      //--- Aditional Attributes -BEGIN- ---//
      // subtitle: Row(
      //   children: [
      //     Expanded(
      //       child: Text(
      //         lastMessage,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //     ),
      //     SizedBox(width: 10),
      //     Text(
      //       time,
      //       style: TextStyle(color: Colors.grey),
      //     ),
      //   ],
      // ),
      // trailing: unreadCount > 0
      //     ? CircleAvatar(
      //         backgroundColor: Colors.blue,
      //         radius: 12,
      //         child: Text(
      //           unreadCount.toString(),
      //           style: TextStyle(color: Colors.white, fontSize: 12),
      //         ),
      //       )
      //     : SizedBox.shrink(),
      //--- Aditional Attributes -END- ---//
}
//--- Chat List Theme -END- ---//

void main() {
  runApp(MaterialApp(
    home: ChatListPage(),
  ));
}
