import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isNotValidate = false;
  bool _isHovering = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print('Server response: ${response.statusCode}');
      print('Response body: ${response.body}');
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let's register.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xAA1A1B1E),
                border: Border.all(color: Color(0xFF373A3F)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF373A3F)),
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                        errorText: _isNotValidate ? "enter email" : null,
                        hintText: "Email or Phone number",
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorText: _isNotValidate ? "Invalid password" : null,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF5C5F65),
                          ),
                        ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25,),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: _isHovering ? Colors.blue : Color(0xFF5C5F65),
                        fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
                        fontSize: _isHovering ? 18.0 : 16.0,
                      ),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: _isHovering ? Colors.blue : Colors.blue,
                        fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
                        fontSize: _isHovering ? 24.0 : 16.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: MaterialButton(
                onPressed: () {
                  registerUser();
                  if (!_isNotValidate) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                color: Color(0xAA3A5BDA),
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
