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

  @override
  Widget build(BuildContext context) {
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
                filteredTrips = trips
                    .where((trip) => trip.toCity.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search City',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.black),
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(128, 0, 0,1),
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
);


        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DestinationListPage(),
  ));
}
