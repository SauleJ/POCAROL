import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';

class PostCreationPage extends StatefulWidget {


  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fromCityController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  int? selectedPeopleAmount;
  TextEditingController priceController = TextEditingController();

  //////////////////Sending to backend//////////////

  void createPost() async {
    if(descriptionController.text.isNotEmpty && fromCityController.text.isNotEmpty && toCityController.text.isNotEmpty && dateController.text.isNotEmpty && priceController.text.isNotEmpty ){
        
      Map<String, String> regBody = {
      "description": descriptionController.text,
      "date": dateController.text,
      "fromCity": fromCityController.text,
      "toCity": toCityController.text,
      "peopleAmount": selectedPeopleAmount.toString(),
      "priceAmount": priceController.text,
    };

    // Check if globalToken is not null, then include it in the request body
    if (globalToken != null) {
      regBody['token'] = globalToken!;
    }


    var response = await http.post(
      Uri.parse('http://localhost:3000/savePost'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if (jsonResponse['status']) {
      print('Post created successfully');
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Post Created"),
            content: Text("You have created a post."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      print('Error creating post');
    }
    }
  }

  ///////////////////////////////////////////////////

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: Color.fromRGBO(128, 0, 0, 1)),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  buildTextFieldWithIcon(fromCityController, 'From', Icons.location_on, isFirst: true),
                  SizedBox(height: 16.0),
                  buildTextFieldWithIcon(toCityController, 'To', Icons.location_on),
                  SizedBox(height: 16.0),
                  buildTextFieldWithIcon(dateController, 'Date', Icons.date_range),
                  SizedBox(height: 16.0),
                  buildPeopleAmountDropdown(),
                  SizedBox(height: 16.0),
                  buildTextFieldWithIcon(priceController, 'Price', Icons.attach_money),
                  SizedBox(height: 16.0),
                  buildTextFieldWithIcon(descriptionController, 'Description', Icons.description, maxLines: 4, verticalAlignment: CrossAxisAlignment.start, isLast: true),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 80.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 255, 255, 1)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8.0)),
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 80.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          createPost();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 255, 255, 1)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8.0)),
                        alignment: Alignment.center,
                      ),
                      child: Icon(Icons.check, color: Colors.green),
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

  Widget buildTextFieldWithIcon(
    TextEditingController controller,
    String hintText,
    IconData icon, {
    int maxLines = 1,
    CrossAxisAlignment verticalAlignment = CrossAxisAlignment.center,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
        fillColor: isFirst || isLast ? Colors.grey : Colors.white,
        filled: true,
        prefixIcon: Icon(icon, color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(8.0) : Radius.zero,
            bottom: isLast ? Radius.circular(8.0) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget buildPeopleAmountDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.people, color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          value: selectedPeopleAmount,
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text('People Amount', style: TextStyle(color: Colors.black.withOpacity(0.5))),
            ),
            for (int i = 1; i <= 5; i++)
              DropdownMenuItem<int?>(
                value: i,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(i.toString()),
                  ],
                ),
              ),
          ],
          onChanged: (int? value) {
            setState(() {
              selectedPeopleAmount = value;
            });
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PostCreationPage(),
  ));
}
