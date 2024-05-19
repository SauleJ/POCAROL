import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BottomNavigationBar.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class Profile {
  final String profilePhotoUrl;
  final String username;
  final String firstName;
  final String lastName;
  final String carNumber;
  final double rating;

  Profile({
    required this.profilePhotoUrl,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.carNumber,
    required this.rating,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await getUserByToken(globalToken!);
      setState(() {
        _profile = Profile(
          profilePhotoUrl: response['photo'],
          username: response['username'],
          firstName: response['name'],
          lastName: response['lastname'],
          carNumber: 'Unknown', // Assuming car number is not included in the response
          rating: response['rating'].toDouble(),
        );
      });
    } catch (error) {
      print('Error fetching user profile: $error');
      // Handle error
    }
  }

  Future<Map<String, dynamic>> getUserByToken(String token) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/getUserByToken/$token'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      return userData;
    } else {
      throw Exception('Failed to load user data by token: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
      ),
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: _profile != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                backgroundImage: NetworkImage(_profile!.profilePhotoUrl),
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
                                      _profile!.carNumber,
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          buildDetailRow("Username:", _profile!.username, Icons.person),
                          SizedBox(height: 8.0),
                          buildDetailRow("Name:", "${_profile!.firstName} ${_profile!.lastName}", Icons.person),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRatingStars(_profile!.rating),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }

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

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor();
    double decimal = rating - fullStars;
    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.yellow[700]));
    }
    if (decimal > 0) {
      stars.add(Icon(Icons.star_half, color: Colors.yellow[700]));
    }
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
          SizedBox(width: 8.0),
          Text(
            '$rating',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
