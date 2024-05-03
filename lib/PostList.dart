import 'package:flutter/material.dart';
import 'BottomNavigationBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PostReview.dart';

// Define the Destination class
class Destination {
  final String id;
  final String createdBy;
  final String fromCity;
  final String toCity;
  final String date;
  final int peopleAmount;
  final double priceAmount;
  final String postComment;

  Destination({
    required this.id,
    required this.createdBy,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.peopleAmount,
    required this.priceAmount,
    required this.postComment,
  });
}

// Define the DestinationListPage widget
class DestinationListPage extends StatefulWidget {
  @override
  _DestinationListPageState createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage> {
  late Future<List<Destination>> futurePosts;
  List<Destination> allPosts = [];
  List<Destination> filteredTrips = [];

  TextEditingController _fromCityController = TextEditingController();
  TextEditingController _toCityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  // Fetch posts from API
  Future<List<Destination>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/getAllPosts'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        List<Destination> destinations = [];

        for (var post in jsonData) {
          final id = post['_id'] ?? post['id'];
          Destination destination = Destination(
            id: id,
            createdBy: post['createdBy'],
            fromCity: post['fromCity'],
            toCity: post['toCity'],
            date: post['date'],
            peopleAmount: post['peopleAmount'],
            priceAmount: post['priceAmount'],
            postComment: post['description'], 
          );

          destinations.add(destination);
        }

        setState(() {
          allPosts = destinations;
          filteredTrips = destinations;
        });

        return destinations;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to fetch posts');
    }
  }

  // Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(128, 0, 0, 1),
          title: Text('Filter', style: TextStyle(color: Colors.white)),
          content: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _fromCityController,
                    decoration: InputDecoration(labelText: 'From City'),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _toCityController,
                    decoration: InputDecoration(labelText: 'To City'),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Date'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _fromCityController.clear();
                _toCityController.clear();
                _dateController.clear();
                setState(() {
                  filteredTrips = allPosts;
                });
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, color: Colors.red),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  filteredTrips = filteredTrips.where((post) {
                    bool fromCityCondition = _fromCityController.text.isEmpty ||
                        post.fromCity.toLowerCase().contains(_fromCityController.text.toLowerCase());
                    bool toCityCondition = _toCityController.text.isEmpty ||
                        post.toCity.toLowerCase().contains(_toCityController.text.toLowerCase());
                    bool dateCondition = _dateController.text.isEmpty ||
                        post.date.toLowerCase().contains(_dateController.text.toLowerCase());
                    return fromCityCondition && toCityCondition && dateCondition;
                  }).toList();
                });
                Navigator.of(context).pop();
              },
              child: Icon(Icons.check, color: Colors.green),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Destination>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Placeholder for loading indicator
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filteredTrips = allPosts.where((trip) =>
                          trip.toCity.toLowerCase().contains(value.toLowerCase())).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search City',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_alt_rounded, color: Colors.black),
                      onPressed: _showFilterDialog,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Color.fromRGBO(128, 0, 0, 1),
            body: ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(102, 94, 94, 0.174),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text('Destination: ${filteredTrips[index].toCity}'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_city, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('${filteredTrips[index].fromCity}'),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('${filteredTrips[index].date}'),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('${filteredTrips[index].priceAmount}'),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text('${filteredTrips[index].peopleAmount}'),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      print('Selected destination: ${filteredTrips[index].toCity}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DestinationDetailPage(destination: filteredTrips[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            bottomNavigationBar: MyBottomNavigationBar(),
          );
        }
      },
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: DestinationListPage(),
  ));
}