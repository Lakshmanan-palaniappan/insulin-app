import 'package:flutter/material.dart';

class BolusTile extends StatelessWidget {
  const BolusTile({
    super.key,
    required this.title,
    required this.units,
    required this.onTap,
    required this.onEdit,
  });

  final String title;
  final num units;
  final Function() onTap;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // deliverBolus(breakFastBolus),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$units",
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          " Units",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 70),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      onPressed: onEdit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
