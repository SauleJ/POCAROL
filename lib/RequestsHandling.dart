import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class RequestsHandling extends StatefulWidget {
  const RequestsHandling({Key? key}) : super(key: key);

  @override
  _RequestsHandlingState createState() => _RequestsHandlingState();
}

class _RequestsHandlingState extends State<RequestsHandling> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isAccepted = false;
  bool _isRejected = false;

  List<DataModel> dataList = [
    DataModel(
      imageUrl: 'assets/images/profile1.jpg',
      username: 'WarriorQueen69',
      firstName: 'Ciri',
      lastName: 'Fiona',
      carNumber: 'ABC123',
      rating: 4.5,
    ),
    DataModel(
      imageUrl: 'assets/images/profile2.jpg',
      username: 'WhiteWolf123',
      firstName: 'Geralt',
      lastName: 'of Rivia',
      carNumber: 'XYZ789',
      rating: 4.2,
    ),
    DataModel(
      imageUrl: 'assets/images/profile3.jpg',
      username: 'RoachLover',
      firstName: 'Dandelion',
      lastName: 'Puff',
      carNumber: 'DEF456',
      rating: 4.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  print('Go back');
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: const Text(
                  "Choose Your travel buddy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: dataList.length,
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return carouselView(index);
                    },
                  ),
                  if (_isAccepted)
                    Center(
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
                            Text('Added to trip', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  if (_isRejected)
                    Center(
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel_outlined, color: Colors.red, size: 100),
                            Text('Rejected', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isAccepted = true;
                      _isRejected = false;
                    });
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        _isAccepted = false;
                      });
                    });
                    print('Accepted');
                  },
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRejected = true;
                      _isAccepted = false;
                    });
                    Timer(Duration(seconds: 2), () {
                      setState(() {
                        _isRejected = false;
                      });
                    });
                    print('Rejected');
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(Icons.arrow_back),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Icon(Icons.arrow_forward),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
          print("value $value index $index");
        }
        return Transform.rotate(
          angle: pi * value,
          child: carouselCard(dataList[index]),
        );
      },
    );
  }

  Widget carouselCard(DataModel data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: AspectRatio(
        aspectRatio: 0.4,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: GestureDetector(
                  onTap: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity, // Set width to match screen width
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${data.firstName} ${data.lastName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Username: ${data.username}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Car Number: ${data.carNumber}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Rating: ${data.rating}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              // Add more information here about the traveler and the user rating
            ],
          ),
        ),
      );
    },
  );
},

                  child: Image.asset(
                    data.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 20, // Adjusted width to match the image
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.firstName} ${data.lastName}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\Rating: ${data.rating}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataModel {
  final String imageUrl;
  final String username;
  final String firstName;
  final String lastName;
  final String carNumber;
  final double rating;

  DataModel({
    required this.imageUrl,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.carNumber,
    required this.rating,
  });
}
