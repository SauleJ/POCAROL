import 'package:flutter/material.dart';

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
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    buildTextFieldWithIcon(
                      fromCityController,
                      'From',
                      Icons.location_on,
                      isFirst: true,
                    ),
                    SizedBox(height: 16.0),
                    buildTextFieldWithIcon(
                      toCityController,
                      'To',
                      Icons.location_on,
                    ),
                    SizedBox(height: 16.0),
                    buildTextFieldWithIcon(
                      dateController,
                      'Date',
                      Icons.date_range,
                    ),
                    SizedBox(height: 16.0),
                    buildPeopleAmountDropdown(),
                    SizedBox(height: 16.0),
                    buildTextFieldWithIcon(
                      priceController,
                      'Price',
                      Icons.attach_money,
                    ),
                    SizedBox(height: 16.0),
                    buildTextFieldWithIcon(
                      descriptionController,
                      'Description',
                      Icons.description,
                      maxLines: 4,
                      verticalAlignment: CrossAxisAlignment.start,
                      isLast: true,
                    ),
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
                          backgroundColor: Colors.red,
                        ),
                        child: Icon(Icons.close),
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
                          if (_validateMandatoryFields()) {
                            // Perform post creation action here
                            _createPost();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Icon(Icons.check),
                      ),
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
              child:
                  Text('People Amount', style: TextStyle(color: Colors.black.withOpacity(0.5))),
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

  bool _validateMandatoryFields() {
    return fromCityController.text.isNotEmpty &&
        toCityController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        priceController.text.isNotEmpty;
  }

  void _createPost() {
    // Perform post creation action here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post created successfully'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    fromCityController.dispose();
    toCityController.dispose();
    dateController.dispose();
    priceController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: PostCreationPage(),
  ));
}
