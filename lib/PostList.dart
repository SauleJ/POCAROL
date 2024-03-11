import 'package:flutter/material.dart';
import 'BottomNavigationBar.dart';

class Destination {
  final String fromCity;
  final String toCity;
  final String date;
  final int peopleAmount;
  final double priceAmount;

  Destination({
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.peopleAmount,
    required this.priceAmount,
  });
}

class DestinationListPage extends StatefulWidget {
  @override
  _DestinationListPageState createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage> {
  late List<Destination> trips;
  late List<Destination> filteredTrips;
  TextEditingController _fromCityController = TextEditingController();
  TextEditingController _toCityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    trips = [
      Destination(fromCity: 'Vilnius', toCity: 'Kaunas', date: '2024-07-01', peopleAmount: 3, priceAmount: 10),
      Destination(fromCity: 'Kaunas', toCity: 'Klaipėda', date: '2024-07-02', peopleAmount: 4, priceAmount: 20),
      Destination(fromCity: 'Klaipėda', toCity: 'Vilnius', date: '2024-07-03', peopleAmount: 2, priceAmount: 15),
    ];
    filteredTrips = List.from(trips);
  }

//---Filter button -BEGIN- ---//
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
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close, color: Colors.red),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                filteredTrips = trips.where((trip) {
                  bool fromCityCondition = _fromCityController.text.isEmpty ||
                      trip.fromCity.toLowerCase().contains(_fromCityController.text.toLowerCase());
                  bool toCityCondition = _toCityController.text.isEmpty ||
                      trip.toCity.toLowerCase().contains(_toCityController.text.toLowerCase());
                  bool dateCondition = _dateController.text.isEmpty ||
                      trip.date.toLowerCase().contains(_dateController.text.toLowerCase());
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
//---Filter button -END- ---//


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---Destination Search -BEGIN- ---//
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
                filteredTrips = trips
                    .where((trip) => trip.toCity.toLowerCase().contains(value.toLowerCase()))
                    .toList();
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
      //---Destination Search -END- ---//
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: ListView.builder(
        itemCount: filteredTrips.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color.fromRGBO(255, 255, 255, 1),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            //---Post List -BEGIN- ---//
            child: ListTile(
              title: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(102, 94, 94, 0.174),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Text('Destination: ${filteredTrips[index].toCity}'),
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.black),
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
                ],
              ),
              onTap: () {
                print('Selected destination: ${filteredTrips[index].toCity}');
              },
            ),
            //---Post List -END- ---//
          );
        },
      ),
      //---Post List -BEGIN- ---//
      bottomNavigationBar: MyBottomNavigationBar(),
      //---Post List -END- ---//
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DestinationListPage(),
  ));
}
