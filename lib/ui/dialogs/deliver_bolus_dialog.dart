import 'package:flutter/material.dart';

class DeliverBolusDialog extends StatelessWidget {
  const DeliverBolusDialog({
    super.key,
    required this.bolus,
    required this.onDeliver,
  });

  final num bolus;

  final Function onDeliver;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          'Do you want to deliver the following bolus from your pump?'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        height: 160,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "${bolus.toString()} Units",
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              child: const Text(
                'Deliver',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                onDeliver();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
