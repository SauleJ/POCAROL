import 'package:flutter/material.dart';

class Destination {
  final String name;
  final String information;

  Destination(this.name, this.information);
}

class _MainPageState extends State<MainPage> {
  bool isDark = false;

  late List<String> cityNames;
  late List<Destination> destinations;
  List<Destination> filteredDestinations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cityNames = [
      "Vilnius",
      "Kaunas",
      "Klaipėda",
      "Šiauliai",
      "Panevėžys",
      "Alytus",
      "Marijampolė",
      "Mažeikiai",
      "Jonava",
      "Utena",
      "Telšiai",
      "Visaginas",
      "Tauragė",
      "Ukmergė",
      "Plungė",
      "Kretinga",
      "Palanga",
      "Radviliškis",
      "Druskininkai",
      "Biržai",
    ];

    destinations = List.generate(
      20,
      (index) => Destination(
        index < cityNames.length ? cityNames[index] : 'Destination $index',
        index < cityNames.length
            ? 'Information about ${cityNames[index]}'
            : 'Some information about Destination $index',
      ),
    );

    filteredDestinations = List.from(destinations);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(title: const Text('Choose your destination')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for your destination',
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value == null || value.isEmpty) {
                          filteredDestinations = List.from(destinations);
                        } else {
                          filteredDestinations = destinations
                              .where((destination) => destination.name.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                  );
                },
                suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(cityNames.length, (int index) {
                    final String cityName = cityNames[index];
                    return ListTile(
                      title: Text(cityName),
                      onTap: () {
                        setState(() {
                          _searchController.text = cityName;
                          filteredDestinations = destinations
                              .where((destination) => destination.name.toLowerCase() == cityName.toLowerCase())
                              .toList();
                        });
                      },
                    );
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDestinations.length,
                itemBuilder: (BuildContext context, int index) {
                  Destination destination = filteredDestinations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(destination.name),
                      subtitle: Text(destination.information),
                      onTap: () {
                        // Handle item tap
                        print('Selected destination: ${destination.name}');
                      },
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
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
