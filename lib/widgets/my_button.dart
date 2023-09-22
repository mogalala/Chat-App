import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.color, required this.title, required this.onPressed}) : super(key: key);
  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          minWidth: 200,
          height: 45,
          onPressed: onPressed,
          child: Text(title,
            style: const TextStyle(color: Colors.white, ),
          ),
        ),
      ),
    );
  }
}