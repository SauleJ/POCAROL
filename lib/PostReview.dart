import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/LoginPage.dart';
import 'dart:convert';
import 'PostList.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;

  DestinationDetailPage({required this.destination});

  @override
  _DestinationDetailPageState createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  int selectedPeopleValue = 1;
  String userName = "";
  bool isPetsAllowed = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  // Fetch user that created the post
  void fetchUser() async {
    try {
      final userData = await fetchUserById(widget.destination.createdBy);
      if (mounted) {
        setState(() {
          userName = userData?['email'] ?? "User data not available";
        });
      }
    } catch (error) {
      print(error);
      if (mounted) {
        setState(() {
          userName = "Failed to fetch user data";
        });
      }
    }
  }

  // Fetch current user data
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    try {
      final userCurrentData = await getUserByToken(globalToken!);
      return userCurrentData;
    } catch (error) {
      print(error);
      return null; // Indicate error or missing data
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
      print("------------------");
      print(token);
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

  Future<Map<String, dynamic>> fetchUserById(String userID) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/getUserById/$userID'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData;
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch user data: $error');
    }
  }

  Future<void> savePostRequest(String postID, bool userState) async {
    try {
      // Fetch current user data
      Map<String, dynamic>? userData = await fetchCurrentUser();

      // Check if userData is not null and contains user ID
      if (userData != null && userData.containsKey('_id')) {
        String userID = userData['_id'];

        if (widget.destination.createdBy == userID) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Not allowed'),
                  content: Text('You cannot apply to your post.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            print("You created this post");
        } else {

          // Construct the request body
          var regBody = {
            'postID': postID,
            'users': [{'userID': userID, 'state': userState}],
          };

          // Send the POST request
          final response = await http.post(
            Uri.parse('http://localhost:3000/savePostRequest'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(regBody),
          );
          print(response.statusCode);

          if (response.statusCode == 200) {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Applied Suceesfully'),
                  content: Text('You applied to this post'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            print('Post request saved successfully!');
          } else if (response.statusCode == 409) {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Already applied'),
                  content: Text('You have already applied'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
              print("Already applied");
          } else {
            print('Error saving post request: ${response.statusCode}');
          }
        }
      }
    } catch (error) {
      print('Error sending POST request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Destination Details'),
      ),
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Padding(
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
                    buildDetailRow("Profile:", userName, Icons.drive_eta_rounded),
                    SizedBox(height: 3.0),
                    buildDetailRow("To City:", widget.destination.toCity, Icons.location_on),
                    SizedBox(height: 3.0),
                    buildDetailRow("From City:", widget.destination.fromCity, Icons.location_city),
                    SizedBox(height: 3.0),
                    buildDetailRow("Date:", widget.destination.date, Icons.calendar_today),
                    SizedBox(height: 3.0),
                    buildDetailRow("People Amount:", widget.destination.peopleAmount.toString(), Icons.person),
                    SizedBox(height: 3.0),
                    buildDetailRow("Price Amount:", widget.destination.priceAmount.toString(), Icons.attach_money),
                    SizedBox(height: 3.0),
                    buildDetailRow("Comment:", widget.destination.postComment.toString(), Icons.comment),
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
                    buildDropdownRow("Number of People:", buildPeopleDropdown()),
                    SizedBox(height: 4.0),
                    buildBooleanSwitch("Pets Allowed:", Icons.pets, buildBooleanSwitchWidget()),
                    SizedBox(height: 4.0),
                    buildTextField("Leave a comment", Icons.comment),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel, color: Colors.red),
                  label: Text("Cancel", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print("presseddd");
                    savePostRequest(widget.destination.id, false);
                    //Navigator.pop(context);
                  },
                  icon: Icon(Icons.check, color: Colors.green),
                  label: Text("OK", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  Widget buildDropdownRow(String label, Widget dropdownWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.people,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(label, style: TextStyle(fontSize: 18.0)),
          ],
        ),
        dropdownWidget,
      ],
    );
  }

  Widget buildPeopleDropdown() {
    return DropdownButton<int>(
      value: selectedPeopleValue,
      items: List.generate(
        widget.destination.peopleAmount,
        (index) => DropdownMenuItem<int>(
          value: index + 1,
          child: Text((index + 1).toString()),
        ),
      ),
      onChanged: (selectedValue) {
        setState(() {
          selectedPeopleValue = selectedValue!;
        });
      },
      hint: Text('Number'),
    );
  }

  Widget buildTextField(String hintText, IconData iconData) {
    return TextField(
      decoration: InputDecoration(
        icon: Icon(iconData),
        hintText: hintText,
      ),
    );
  }

  Widget buildBooleanSwitch(String label, IconData iconData, Widget switchWidget) {
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
        switchWidget,
      ],
    );
  }

  Widget buildBooleanSwitchWidget() {
    return Switch(
      value: isPetsAllowed,
      onChanged: (value) {
        setState(() {
          isPetsAllowed = value;
        });
      },
    );
  }
}
