import 'package:flutter/material.dart';

class CountDownTimer extends StatelessWidget {
  const CountDownTimer({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 85,
            fontWeight: FontWeight.bold,
            
          ),
        ),
        const Text(
          "Sec left",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            
          ),
        ),
      ],
    );
  }
}
