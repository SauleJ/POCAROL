import 'package:flutter/material.dart';

class Post {
  final String description;
  final String date;
  final String fromCity;
  final String toCity;
  final int? peopleAmount; // Update type to int?
  final double priceAmount;

  Post({
    required this.description,
    required this.date,
    required this.fromCity,
    required this.toCity,
    required this.peopleAmount,
    required this.priceAmount,
  });
}

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  late TextEditingController descriptionController;
  late TextEditingController fromCityController;
  late TextEditingController toCityController;
  late TextEditingController dateController;
  int? selectedPeopleAmount; // Update type to int?
  late TextEditingController priceController;

  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    fromCityController = TextEditingController();
    toCityController = TextEditingController();
    dateController = TextEditingController();
    priceController = TextEditingController();
    posts = [];
  }

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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  ).copyWith(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 255, 255, 1))),
                  child: Icon(Icons.close, color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      posts.add(
                        Post(
                          description: descriptionController.text,
                          date: dateController.text,
                          fromCity: fromCityController.text,
                          toCity: toCityController.text,
                          peopleAmount: selectedPeopleAmount,
                          priceAmount: double.tryParse(priceController.text) ?? 0.0,
                        ),
                      );
                      fromCityController.clear();
                      toCityController.clear();
                      dateController.clear();
                      priceController.clear();
                      descriptionController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                  ).copyWith(backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(255, 255, 255, 1))),
                  child: Icon(Icons.check, color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(102, 94, 94, 0.174),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From City: ${posts[index].fromCity}'),
                                Text('To City: ${posts[index].toCity}'),
                                Text('Date: ${posts[index].date}'),
                                Text('People Amount: ${posts[index].peopleAmount}'),
                                Text('Price Amount: ${posts[index].priceAmount}'),
                                Text('Description: ${posts[index].description}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
