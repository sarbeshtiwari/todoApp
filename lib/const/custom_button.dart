import 'package:flutter/material.dart';
import 'package:todoapp/const/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;

  CustomButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.buttonColor),
      
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0, color: AppColors.text),
          ),
        ),
      ),
    );
  }
}
