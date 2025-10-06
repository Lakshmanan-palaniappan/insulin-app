import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:insulin/providers/insulin_provider.dart';


class PumpDetailsCard extends StatelessWidget {
  const PumpDetailsCard({
    required this.onUpdate,
    super.key,
  });

  final Function() onUpdate;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Insulin Pump",
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Consumer<InsulinProvider>(
                  builder: (context, insulinProvider, child) {
                    final insulinData = insulinProvider.insulinData;
                    return insulinData == null
                        ? const CircularProgressIndicator()
                        : Text(
                            "${insulinData.activeInsulin}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                  },
                ),
                const Text(
                  " Units",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                FilledButton(
                  onPressed: onUpdate,
                  child: const Text("Update"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
