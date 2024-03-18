import 'package:flutter/material.dart';
import 'package:namer_app/PostList.dart';
import 'package:namer_app/CreatePost.dart';
import 'package:namer_app/ProfilePage.dart';
import 'RequestsHandling.dart';

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
            case 1:
              //Chat
              Navigator.pushReplacementNamed(context, '/chat');
            case 2:
              //Create Post
              Navigator.push(context,MaterialPageRoute(builder: (context) => PostCreationPage()));
            case 3:
              //Add people
              Navigator.push(context,MaterialPageRoute(builder: (context) => RequestsHandling()));
            case 4:
              //Profile
              Navigator.push(context,MaterialPageRoute(builder: (context) => 
              ProfilePage(profile: myProfile),),);
          }
        },
    ),
    );
  }

//--- Temporary Profile Data -BEGIN- ---//
  Profile myProfile = Profile(
  profilePhotoUrl: 'https://via.placeholder.com/150',
  username: 'user123',
  firstName: 'John',
  lastName: 'Doe',
  // email: 'john.doe@example.com',
  // phoneNumber: '123-456-7890',
  carNumber: 'ABC123',
  rating: 4.5,
);
//--- Temporary Profile Data -END- ---//
}