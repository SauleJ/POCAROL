import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: 450,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "We promise that you'll have the most \nfuss-free time with us ever.",
                    style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                        height: 1.4,
                        fontSize: 20),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(190, 14, 14, 1),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
