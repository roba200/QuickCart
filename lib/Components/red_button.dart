import 'package:flutter/material.dart';

class RedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const RedButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFDB3022),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
