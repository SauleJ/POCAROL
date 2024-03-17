import 'package:namer_app/PostList.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/ProfilePage.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;

  DestinationDetailPage({required this.destination});

  @override
  _DestinationDetailPageState createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  int selectedPeopleValue = 1;
  bool isPetsAllowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //--- Top Bar -BEGIN- ---//
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Destination Details'),
      ),
      //--- Top Bar -END- ---//
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //--- Selected Post Info -BEGIN- ---//
            Card(
              color: Color.fromRGBO(255, 255, 255, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRowProfile("Driver:",'', Icons.drive_eta_rounded, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(profile: myProfile),
                        ),
                      );
                    }),
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
            //--- Selected Post Info -END- ---//
            SizedBox(height: 16.0),
            //--- Input Kandidato Info -BEGIN- ---//
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
             //--- Input Kandidato Info -END- ---//
            SizedBox(height: 16.0),
            //--- Buttons -BEGIN- ---//
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {//GO BACK TO HOME
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationListPage(),
                  ),
                  );
                    print("Cancel button pressed");
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
                  onPressed: () { //FOWARD TO LIVE TRIPS
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationListPage(), //FOR NOW GOES BACK TO HOME
                  ),
                  );
                    print("OK button pressed");
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
             //--- Buttons -END- ---//
          ],
        ),
      ),
    );
  }

  //--- Selected Post Info -BEGIN- ---//
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
  //--- Selected Post Info -END- ---//

  //--- Selected Post Info For Profile -BEGIN- ---//
Widget buildDetailRowProfile(String label, String value, IconData iconData, Function()? onTap) {
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
      GestureDetector(
        onTap: onTap,
        child: Text(
          myProfile.username,
          style: TextStyle(fontSize: 18.0, decoration: TextDecoration.underline),
        ),
      ),
    ],
  );
}
  //--- Selected Post Info For Profile -BEGIN- ---//
  
  //--- People DropDown -BEGIN- ---//
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
  //--- People DropDown -END- ---//

  //--- Comment Text -BEGIN- ---//
  Widget buildTextField(String hintText, IconData iconData) {
    return TextField(
      decoration: InputDecoration(
        icon: Icon(iconData),
        hintText: hintText,
      ),
    );
  }
  //--- Comment Text -END- ---//

  //--- Pet Boolean -BEGIN- ---//
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
  //--- Pet Boolean -END- ---//
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
