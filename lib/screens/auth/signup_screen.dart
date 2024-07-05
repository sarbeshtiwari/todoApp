import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/const/colors.dart';
import 'package:todoapp/const/custom_button.dart';
import 'package:todoapp/const/custom_textfield.dart';
import 'package:todoapp/screens/auth/controller/firebase_auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  bool _passwordsMatch = true; // State to track if passwords match
  final FirebaseAuthService _signupController =
      FirebaseAuthService(); // Instance of FirebaseController

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * .1, vertical: h * .1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonColor,
                ),
              ),
              SizedBox(height: h * .02),
              CustomTextField(
                controller: _nameController,
                hintText: 'Enter your name',
                labelText: 'Name',
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: h * .02),
              CustomTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                labelText: 'Email',
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: h * .02),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Enter your password',
                labelText: 'Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                    _validatePasswordMatch();
                  });
                },
              ),
              SizedBox(height: h * .02),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
                    _validatePasswordMatch();
                  });
                },
              ),
              SizedBox(height: h * .02),
              if (!_passwordsMatch)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Passwords do not match.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  if (_passwordsMatch) {
                    //firebase  working
                    setState(() {
                      _isLoading = true;
                    });
                    bool signedUp = await _signupController
                        .signUpWithEmailAndPassword(email, password, name);
                    setState(() {
                      _isLoading = false;
                    });
                    if (signedUp) {
                      Get.off(LoginScreen());
                      print('Sign up successful');
                    } else {
                      Get.snackbar('Failed', 'SignUP Failed');
                    }
                  }
                },
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Sign Up'),
              ),
              SizedBox(height: h * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Get.to(LoginScreen());
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validatePasswordMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }
}
