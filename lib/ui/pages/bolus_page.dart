import 'package:flutter/material.dart';

import 'package:insulin/ui/pages/preset_bolus_page.dart';
import 'package:insulin/ui/pages/manual_bolus_page.dart';

class BolusPage extends StatelessWidget {
  const BolusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bolus"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                height: 70,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualBolusPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Manual bolus",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 300,
                height: 70,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PresetBolusPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Preset bolus",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
