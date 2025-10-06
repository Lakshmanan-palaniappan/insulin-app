import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:insulin/providers/insulin_provider.dart';
import 'package:insulin/utils/utils.dart';
import 'package:insulin/ui/widgets/common/warning_container.dart';
import '../../models/Log.dart';

class ManualBolusPage extends StatefulWidget {
  const ManualBolusPage({super.key});
  @override
  State<ManualBolusPage> createState() => _ManualBolusPageState();
}

class _ManualBolusPageState extends State<ManualBolusPage> {
  TextEditingController bolusTextController = TextEditingController();
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manual bolus"),
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
                  bolusTextController.text = sliderValue.toStringAsFixed(0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: bolusTextController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          label: Text("Dose"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Slider(
                        value: sliderValue,
                        min: 0,
                        max: 10,
                        divisions: 10, // 0, 1, 2, ... 10
                        label: sliderValue.round().toString(),
                        onChanged: (double value) async {
                          setState(() {
                            sliderValue = value;
                            bolusTextController.text =
                                value.round().toString();
                          });
                          insulinProvider.changeBolusDosage(value.roundToDouble());
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        height: 50,
                        child: StreamBuilder(
                          stream: insulinProvider.isloading(),
                          builder: (context, asyncSnapshot) {
                            final isLoading = asyncSnapshot.hasData && asyncSnapshot.data!;
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (sliderValue < 1) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Invalid Bolus Value"),
                                      content: const Text(
                                          "Please select a bolus value of at least 1."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                if (insulinProvider.insulinData!.activeInsulin < 6) {
                                  showAlertDialog(
                                    context: context,
                                    title: "Alert",
                                    message:
                                    "Active insulin has already reached the limit. ",
                                  );
                                } else {
                                  num newBolus =
                                      stringToNumber(bolusTextController.text) ??
                                          sliderValue.round();
                                  insulinProvider.saveBolusDosage(newBolus);
                                }
                              },
                              child: const Text(
                                "Deliver",
                                style: TextStyle(fontSize: 17),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Bolus History Section
                      FutureBuilder(
                        future: insulinProvider.getBasalLogs(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error.toString()}',
                              style: const TextStyle(
                                  fontSize: 8, color: Colors.red),
                            );
                          }

                          if (snapshot.hasData) {
                            List<Log> logs = snapshot.data!;
                            logs.sort((a, b) {
                              DateTime at = DateTime.parse(a.startTime);
                              DateTime bt = DateTime.parse(b.startTime);
                              return at.isAfter(bt) ? 1 : -1;
                            });

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    const Text(
                                      "History",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black),
                                      padding: const EdgeInsets.all(6),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        logs.length.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: logs.length,
                                  itemBuilder: (context, index) {
                                    Log log = logs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Card.outlined(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          width: double.maxFinite,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  const Text("Bolus"),
                                                  Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                        log.startTime)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                          "${log.units} units ",
                                                          style:
                                                          const TextStyle(
                                                              fontSize: 25),
                                                        ),
                                                        TextSpan(
                                                          text: selectof(
                                                              log.typeOfActivity,
                                                              {
                                                                'Rewind':
                                                                'Rewound',
                                                                'Custom Refill':
                                                                'Custom Rewound',
                                                                'Bolus':
                                                                'delivered',
                                                              }),
                                                        ),
                                                        const TextSpan(
                                                            text:
                                                            "\nActive insulin: "),
                                                        TextSpan(
                                                            text: log
                                                                .activeInsulin
                                                                .toString()),
                                                      ],
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    DateFormat('hh:mm').format(
                                                        DateTime.parse(
                                                            log.startTime)),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w900),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }

                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
