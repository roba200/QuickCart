import 'package:e_commerce_app/Consts/colors.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String hintText;
  const InputField(
      {super.key,
      required this.labelText,
      required this.obscureText,
      required this.controller,
      required this.hintText,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            floatingLabelStyle: TextStyle(color: red),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: red),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border: null),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
