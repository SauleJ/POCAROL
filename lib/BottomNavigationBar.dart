import 'package:flutter/material.dart';
import 'package:namer_app/PostList.dart';

class MyBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
    child: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
          color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat,
          color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create,
          color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.car_crash,
          color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person,
          color: Colors.black),
          label: '',
        ),
      ],
      selectedItemColor: Colors.red[900],
      unselectedItemColor: Colors.black.withOpacity(0.8),
      showSelectedLabels: false,
      showUnselectedLabels: false, 
      elevation: 10,
          onTap: (index) {
          switch (index) {
            case 0:
              //Home
              Navigator.push(context,MaterialPageRoute(builder: (context) => DestinationListPage()));
              break;
            case 1:
              //Chat
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 2:
              //Create Post
              Navigator.pushReplacementNamed(context, '/create');
              break;
            case 3:
              //Add people
              Navigator.pushReplacementNamed(context, '/car_crash');
              break;
            case 4:
              //Profile
              Navigator.pushReplacementNamed(context, '/person');
              break;
          }
        },
    ),
    );
  }
}