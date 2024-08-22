import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final String text;
  bool? isFunction;
  bool? isEquel;
  Function()? function;
  NumberButton(
      {super.key,
      required this.text,
      this.isFunction = false,
      this.function,
      this.isEquel = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEquel!
            ? Colors.amber
            : isFunction!
                ? Colors.teal.shade300
                : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 25,
            color: isEquel!
                ? Colors.black
                : isFunction!
                    ? Colors.amber
                    : Colors.black),
      ),
    );
  }
}
