import 'package:flutter/material.dart';
import 'BottomNavigationBar.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;

  ProfilePage({required this.profile});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class Profile {
  final String profilePhotoUrl;
  final String username;
  final String firstName;
  final String lastName;
  // final String email;
  // final String phoneNumber;
  final String carNumber;
  final double rating;

  Profile({
    required this.profilePhotoUrl,
    required this.username,
    required this.firstName,
    required this.lastName,
    // required this.email,
    // required this.phoneNumber,
    required this.carNumber,
    required this.rating,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //--- Top Bar -BEGIN- ---//
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
      ),
    //--- Top Bar -END- ---//
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //--- Profile Info -BEGIN- ---//  
            Card(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.red[900],
                          backgroundImage: NetworkImage(widget.profile.profilePhotoUrl),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.directions_car,
                                color: Colors.black,
                                size: 30.0,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                widget.profile.carNumber,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    buildDetailRow("Username:", widget.profile.username, Icons.person),
                    SizedBox(height: 8.0),
                    buildDetailRow("Name:", "${widget.profile.firstName} ${widget.profile.lastName}", Icons.person),
                    SizedBox(height: 8.0),
                    // buildDetailRow("Email:", widget.profile.email, Icons.email),
                    // SizedBox(height: 8.0),
                    // buildDetailRow("Phone Number:", widget.profile.phoneNumber, Icons.phone),
                  ],
                ),
              ),
            ),
            //--- Profile Info -END- ---// 
            SizedBox(height: 16.0),
            //--- Ratings and Comments -BEGIN- ---// 
            Card(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRatingStars(widget.profile.rating),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                              width: 300.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chat),
                                onPressed: () {
                                  // TO Comment LIST
                                },
                              ),
                        )
                      ],
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          //--- Ratings and Comments -END- ---// 
          ],
        ),
      ),
      //--- Bottom Navigation -BEGIN- ---//
      bottomNavigationBar: MyBottomNavigationBar(),
      //--- Bottom Navigation -END- ---//
    );
  }

//--- Profile Information Card Style -BEGIN- ---//
  Widget buildDetailRow(String label, String value, IconData iconData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: Colors.black, 
            ),
            SizedBox(width: 8.0),
            Text(label, style: TextStyle(fontSize: 18.0)),
          ],
        ),
        Text(value, style: TextStyle(fontSize: 18.0)),
      ],
    );
  }
//--- Profile Information Card Style -END- ---//

//--- Stars rating  -BEGIN- ---//
Widget buildRatingStars(double rating) {
  int fullStars = rating.floor();
  double decimal = rating - fullStars;
  List<Widget> stars = [];
  // Full stars
  for (int i = 0; i < fullStars; i++) {
    stars.add(Icon(Icons.star, color: Colors.yellow[700]));
  }
  // Half stars
  if (decimal > 0) {
    stars.add(Icon(Icons.star_half, color: Colors.yellow[700]));
  }
  // Empty stars
  for (int i = stars.length; i < 5; i++) {
    stars.add(Icon(Icons.star_border, color: Colors.yellow[700]));
  }

  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: stars,
        ),
        SizedBox(width: 8.0), // Add some space between stars and text
        Text(
          '$rating', // Display the rating value as text
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    ),
  );
}
}
//--- Stars rating  -END- ---//
