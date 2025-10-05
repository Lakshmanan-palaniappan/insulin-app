import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insulin/providers/insulin_provider.dart';
import 'package:insulin/utils/utils.dart';
import 'package:insulin/ui/widgets/common/warning_container.dart';

class BasalPage extends StatelessWidget {
  BasalPage({super.key});

  final TextEditingController basalTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Basal Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            const WarningContainer(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<InsulinProvider>(
                builder: (context, insulinProvider, child) {
                  double sliderValue =
                      insulinProvider.insulinData!.basalRate.toDouble() % 4;
                  basalTextController.text = sliderValue.toString();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: basalTextController,
                        decoration: const InputDecoration(
                          label: Text("Units per hour"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Slider(
                        value: sliderValue,
                        max: 4,
                        divisions: 20,
                        label: sliderValue.round().toString(),
                        onChanged: (double value) async {
                          insulinProvider.changeBasalRate(value);
                          basalTextController.text = value.toString();
                        },
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            num newBasalRate =
                                stringToNumber(basalTextController.text) ??
                                    sliderValue;
                            insulinProvider.saveBasalRate(newBasalRate);
                          },
                          child: const Text(
                            "Update",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        "Rate (U/Hr) : $sliderValue",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "24 Hr Total : ${(sliderValue * 24).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
