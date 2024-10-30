import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController fromCityController = TextEditingController();
  final TextEditingController toCityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  int? selectedPeopleAmount;

  @override
  void dispose() {
    descriptionController.dispose();
    fromCityController.dispose();
    toCityController.dispose();
    dateController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPostForm(),
              SizedBox(height: 16.0),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostForm() {
    return Container(
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.close, Colors.red, () => Navigator.pop(context)),
        _buildActionButton(Icons.check, Colors.green, _handleCreatePost),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 80.0,
        height: 50.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: color),
          child: Icon(icon),
        ),
      ),
    );
  }

  void _handleCreatePost() {
    if (_validateMandatoryFields()) {
      createPost();
    } else {
      _showSnackBar('Please fill all fields', Colors.red);
    }
  }

  bool _validateMandatoryFields() {
    return fromCityController.text.isNotEmpty &&
        toCityController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
  }

  void createPost() async {
    final regBody = {
      "description": descriptionController.text,
      "date": dateController.text,
      "fromCity": fromCityController.text,
      "toCity": toCityController.text,
      "peopleAmount": selectedPeopleAmount.toString(),
      "priceAmount": priceController.text,
      "token": globalToken ?? '',
    };

    var response = await http.post(
      Uri.parse('http://localhost:3000/savePost'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      _showPostCreationDialog();
    } else {
      print('Error creating post');
    }
  }

  void _showPostCreationDialog() {
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
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Widget buildTextFieldWithIcon(TextEditingController controller, String hintText, IconData icon, {int maxLines = 1, CrossAxisAlignment verticalAlignment = CrossAxisAlignment.center, bool isFirst = false, bool isLast = false}) {
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
            DropdownMenuItem<int?>(value: null, child: Text('People Amount', style: TextStyle(color: Colors.black.withOpacity(0.5)))),
            for (int i = 1; i <= 5; i++)
              DropdownMenuItem<int?>(value: i, child: Text(i.toString())),
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
  runApp(MaterialApp(home: PostCreationPage()));
}
