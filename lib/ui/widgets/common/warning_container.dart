import 'package:flutter/material.dart';

class WarningContainer extends StatelessWidget {
  const WarningContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Card.filled(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Container(
          padding: const EdgeInsets.all(30),      
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 28,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'WARNING',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Dosage must be suggested by doctor and manual dosage might cause severe health issue',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
