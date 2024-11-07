import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

// Entry point of the application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Registration',
        home: RegisterPage()
    );
  }
}

// AuthService class handles authentication logic
class AuthService {
  Future<bool> registerUser(Map<String, dynamic> regBody) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle different status codes as needed
        return false;
      }
    } catch (e) {
      // Log error
      print('Error registering user: $e');
      return false;
    }
  }

  bool validateEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }
}

// RegisterViewModel class handles the state and logic for the registration page
class RegisterViewModel {
  final AuthService _authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isRepeatPasswordVisible = false;
  bool isHovering = false;

  bool validateEmail() {
    return _authService.validateEmail(emailController.text);
  }

  Future<bool> registerUser() async {
    var regBody = {
      "name": nameController.text,
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };

    return await _authService.registerUser(regBody);
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  void toggleRepeatPasswordVisibility() {
    isRepeatPasswordVisible = !isRepeatPasswordVisible;
  }

  void setHovering(bool value) {
    isHovering = value;
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    repeatPasswordController.dispose();
  }
}

// Constants for colors and dimensions
class AppColors {
  static const primaryColor = Color.fromRGBO(128, 0, 0, 1);
  static const secondaryColor = Color(0xAA1A1B1E);
  static const accentColor = Color(0xAA3A5BDA);
  static const borderColor = Color(0xFF373A3F);
  static const hintTextColor = Color(0xFF5C5F65);
}

class AppDimensions {
  static const double padding = 16.0;
  static const double fontSizeLarge = 30.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeSmall = 16.0;
}

// RegisterPage class is the UI for the registration screen
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterViewModel viewModel = RegisterViewModel();

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content.isNotEmpty ? Text(content) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  TextStyle _getTextStyle(bool isHovering) {
    return isHovering
        ? TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontSizeMedium,
          )
        : TextStyle(
            color: AppColors.hintTextColor,
            fontWeight: FontWeight.normal,
            fontSize: AppDimensions.fontSizeSmall,
          );
  }

  Widget _buildHeader() {
    return Text(
      "Let's register.",
      style: TextStyle(
        color: Colors.white,
        fontSize: AppDimensions.fontSizeLarge,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextFields() {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.secondaryColor,
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: <Widget>[
          CustomTextField(
            controller: viewModel.nameController,
            hintText: "Name",
          ),
          CustomTextField(
            controller: viewModel.usernameController,
            hintText: "Username",
          ),
          CustomTextField(
            controller: viewModel.emailController,
            hintText: "Email or Phone number",
          ),
          CustomTextField(
            controller: viewModel.passwordController,
            hintText: "Password",
            obscureText: !viewModel.isPasswordVisible,
            togglePasswordVisibility: () {
              setState(() {
                viewModel.togglePasswordVisibility();
              });
            },
          ),
          CustomTextField(
            controller: viewModel.repeatPasswordController,
            hintText: "Repeat Password",
            obscureText: !viewModel.isRepeatPasswordVisible,
            togglePasswordVisibility: () {
              setState(() {
                viewModel.toggleRepeatPasswordVisibility();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          viewModel.setHovering(true);
        });
      },
      onExit: (_) {
        setState(() {
          viewModel.setHovering(false);
        });
      },
      child: GestureDetector(
        onTap: () {
          // Navigate to login page
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
              style: _getTextStyle(viewModel.isHovering),
            ),
            SizedBox(width: 6),
            Text(
              "Login",
              style: _getTextStyle(viewModel.isHovering),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: () async {
          if (viewModel.validateEmail() &&
              viewModel.passwordController.text.isNotEmpty &&
              viewModel.nameController.text.isNotEmpty &&
              viewModel.usernameController.text.isNotEmpty &&
              viewModel.repeatPasswordController.text.isNotEmpty) {
            if (viewModel.passwordController.text ==
                viewModel.repeatPasswordController.text) {
              bool success = await viewModel.registerUser();
              if (success) {
                // Navigate to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else {
                _showDialog(
                    context, "Registration Failed", "Please try again.");
              }
            } else {
              _showDialog(context, "Passwords do not match",
                  "Please make sure both passwords match.");
            }
          } else {
            _showDialog(context, "Please fill all fields", "");
          }
        },
        color: AppColors.accentColor,
        padding: EdgeInsets.all(AppDimensions.padding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(
              color: Colors.white.withOpacity(.7),
              fontSize: AppDimensions.fontSizeSmall,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildHeader(),
              SizedBox(height: 30),
              _buildTextFields(),
              SizedBox(height: 25),
              _buildLoginRedirect(context),
              SizedBox(height: 20),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomTextField widget function
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback? togglePasswordVisibility;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: AppColors.hintTextColor),
          hintText: hintText,
          suffixIcon: togglePasswordVisibility != null
              ? InkWell(
                  onTap: togglePasswordVisibility,
                  child: Icon(
                    Icons.remove_red_eye,
                    color: AppColors.hintTextColor,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// Placeholder for LoginPage
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder implementation
    return Scaffold(
      body: Center(child: Text('Login Page')),
    );
  }
}
