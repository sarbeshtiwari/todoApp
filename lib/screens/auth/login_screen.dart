import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/const/colors.dart';
import 'package:todoapp/const/custom_button.dart';
import 'package:todoapp/const/custom_textfield.dart';
import 'package:todoapp/screens/auth/controller/firebase_auth_service.dart';
import 'package:todoapp/screens/auth/signup_screen.dart';
import 'package:todoapp/screens/home/home_screen.dart';
import 'package:todoapp/screens/initialScreen/initial_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String email = '';
  String password = '';
  final FirebaseAuthService _signinController =
      FirebaseAuthService(); // Instance of FirebaseController
  bool _isLoading = false;
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
            children: [
              Center(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Login to Continue",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.buttonColor,
                  ),
                ),
              ),
              SizedBox(height: h * .1),
              CustomTextField(
                controller: _email,
                hintText: 'Enter your email',
                labelText: 'Username',
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: h * .05),
              CustomTextField(
                controller: _password,
                hintText: 'Enter your password',
                labelText: 'Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(height: h * .1),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  bool logIn = await _signinController.signIn(email, password);
                  setState(() {
                    _isLoading = false;
                  });
                  print('Email: $email, Password: $password');
                  if (logIn) {
                    _signinController.storeUserId();
                    storeLoginState(true);
                    Get.off(HomeScreen());
                  } else {
                    Get.snackbar('Failed', 'LogIn Failed');
                  }
                },
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(text: 'Login'),
              ),
              SizedBox(height: h * .04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont't have an account?"),
                  TextButton(
                      onPressed: () {
                        Get.to(SignupScreen());
                      },
                      child: Text('Sign Up')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
