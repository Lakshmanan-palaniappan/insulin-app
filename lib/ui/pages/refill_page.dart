import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:insulin/providers/insulin_provider.dart';
import 'package:insulin/providers/timer_provider.dart';
import 'package:insulin/ui/widgets/refill/count_down_timer.dart';

import '../../models/Log.dart';
import '../../utils/utils.dart';

class RefillPage extends StatefulWidget {
  const RefillPage({super.key});

  @override
  State<RefillPage> createState() => _RefillPageState();
}

class _RefillPageState extends State<RefillPage> {
  bool ismanualshow = false;
  double sliderval = 0;

  @override
  Widget build(BuildContext context) {
    TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    InsulinProvider insulinProvider =
        Provider.of<InsulinProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rewind"),
        actions: [
          FilledButton(
            onPressed: () {
              setState(() {
                ismanualshow = !ismanualshow;
              });
            },
            child: const Text(
              "Manual",
              style: TextStyle(fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 6),
          OutlinedButton(
            onPressed: () {
              timerProvider.startTimer();
              insulinProvider.turnOnRefill();
            },
            child: const Text(
              "Calibrate",
              style: TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 12)
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: ismanualshow,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Rewind\n",
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                TextSpan(
                                  text: "Units: ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: sliderval.toStringAsFixed(2),
                                ),
                              ],
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                ismanualshow = false;
                              });
                            },
                            child: Icon(Icons.close),
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: sliderval,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: sliderval.round().toString(),
                              onChanged: (double value) async {
                                setState(() {
                                  sliderval = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FilledButton(
                            onPressed: () async {
                              if (sliderval < 1) {
                                showAlertDialog(
                                  context: context,
                                  title: "Alert",
                                  message: "Please select at least 1 unit before rewinding.",
                                );
                                return;
                              }

                              if (insulinProvider.insulinData!.activeInsulin > 219) {
                                showAlertDialog(
                                  context: context,
                                  title: "Alert",
                                  message: "Cannot be rewinded",
                                );
                              } else {
                                timerProvider.startTimer();
                                insulinProvider.turnOnRewind(sliderval);
                              }
                            },
                            child: const Text(
                              "Manual",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<TimerProvider>(
                      builder: (context, timerProvider, child) {
                        return CountDownTimer(
                          text: timerProvider.counter.toString(),
                        );
                      },
                    ),
                    Container(
                      height: 185,
                      width: 185,
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: Lottie.asset(
                        'lib/assets/lottie/injection.json',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Instruction",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "INSTRUCTION 1:\n Remove the RESERVOIR and hit the\n start button to pull plunger",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
                const Text(
                  "INSTRUCTION 2: \n Insert the new loaded RESERVOIR and \n hit the Fill tube button to fill the gap \n between reservoir and needle. ",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
                const Text(
                  "INSTRUCTION 3: \n If you don't notice any droplet from needle \n then, press Till Tip button again. ",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: insulinProvider.getBasalLogs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Error:${snapshot.error.toString()}',
                          style: TextStyle(fontSize: 8, color: Colors.red),
                        );
                      }
                      if (snapshot.hasData) {
                        List<Log> logs = snapshot.data!;
                        logs.sort((a, b) {
                          DateTime at = DateTime.parse(a.startTime),
                              bt = DateTime.parse(b.startTime);
                          return at.isAfter(bt) ? 1 : -1;
                        });
                        return Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                Text(
                                  "History",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black),
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    logs.length.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                Log log = logs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Bolus",
                                              ),
                                              Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    log.startTime,
                                                  ),
                                                ),
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
                                                      style: const TextStyle(
                                                        fontSize: 25,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: selectof(
                                                          log.typeOfActivity, {
                                                        'Rewind': 'Rewound',
                                                        'Custom Refill':
                                                            'Custom Rewound',
                                                        'Bolus': 'delivered',
                                                      }),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "\nActive insulin: ",
                                                    ),
                                                    TextSpan(
                                                      text: log.activeInsulin
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                DateFormat('hh:mm').format(
                                                    DateTime.parse(
                                                        log.startTime)),
                                                style: TextStyle(
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
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: Row(
      //   children: [
      //     Spacer(),
      //     IgnorePointer(
      //       ignoring: true, // Disable press
      //       child: ElevatedButton(
      //         onPressed: () {},
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.grey, // Grey color
      //         ),
      //         child: const Text(
      //           "Manual Rewind",
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       ),
      //     ),
      //     SizedBox(width: 10),
      //     IgnorePointer(
      //       ignoring: true, // Disable press
      //       child: ElevatedButton(
      //         onPressed: () {},
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.grey, // Grey color
      //         ),
      //         child: const Text(
      //           "Fill tube",
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

    );
  }
}
