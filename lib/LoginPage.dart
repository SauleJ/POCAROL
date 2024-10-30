import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'PostList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? globalToken; // Keeping the global token as requested

class AuthService {
  Future<String?> loginUser(String email, String password) async {
    var loginData = {
      "email": email,
      "password": password
    };

    var response = await http.post(
      Uri.parse('http://localhost:3000/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isNotValidate = false;
  bool _isHovering = false;
  final AuthService _authService = AuthService();

  bool _validateEmail(String value) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(value);
  }

  Future<void> _attemptLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (_validateEmail(email) && password.isNotEmpty) {
      try {
        globalToken = await _authService.loginUser(email, password);
        print('Login successful, Token: $globalToken');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DestinationListPage()),
        );
      } catch (e) {
        print(e); // Handle error (e.g., show a message to the user)
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  TextStyle getTextStyle() {
    return TextStyle(
      color: Colors.blue,
      fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
      fontSize: _isHovering ? 24.0 : 16.0,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xFF5C5F65)),
        hintText: hintText,
        suffixIcon: isPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  Icons.remove_red_eye,
                  color: Color(0xFF5C5F65),
                ),
              )
            : null,
      ),
    );
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
              "Let's sign you in.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xAA1A1B1E),
                border: Border.all(color: Color(0xFF373A3F)),
              ),
              child: Column(
                children: <Widget>[
                  _buildTextField(
                    controller: emailController,
                    hintText: "Email or Phone number",
                  ),
                  _buildTextField(
                    controller: passwordController,
                    hintText: "Password",
                    isPassword: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
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
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: getTextStyle(),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Register",
                      style: getTextStyle(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MaterialButton(
                onPressed: _attemptLogin,
                color: Color(0xAA3A5BDA),
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Login",
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
