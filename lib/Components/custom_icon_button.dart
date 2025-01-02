import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String url;
  final Function()? onPressed;
  const CustomIconButton(
      {super.key, required this.url, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(15),
        child: Image.asset(
          url,
        ),
        height: 64,
        width: 92,
      ),
      onPressed: onPressed,
    );
  }
}
