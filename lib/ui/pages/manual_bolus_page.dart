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
  double temp = 0;
  double sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manual bolus",
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

                  bolusTextController.text = sliderValue.toString();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: bolusTextController,
                        decoration: const InputDecoration(
                          label: Text("Dose"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Slider(
                        value: /*insulinProvider.insulinData!.isDelivering==0 ? temp : */sliderValue,
                        min: 0,
                        max: 10,
                        divisions: 20,
                        label: sliderValue.round().toString(),
                        onChanged: (double value) async {
                          setState(() {
                            sliderValue = value;
                          });
                          insulinProvider.changeBolusDosage(value);
                          bolusTextController.text = value.toString();
                        },
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 50,
                        child: StreamBuilder(
                            stream: insulinProvider.isloading(),
                            builder: (context, asyncSnapshot) {
                              return ElevatedButton(
                                onPressed: (asyncSnapshot.hasData && asyncSnapshot.data!)
                                    ? null
                                    : () {
                                  if (asyncSnapshot.hasData && !asyncSnapshot.data!) {
                                    if (insulinProvider.insulinData!.activeInsulin < 6) {
                                      showAlertDialog(
                                        context: context,
                                        title: "Alert",
                                        message:
                                        "Active insulin has already reached the limit.",
                                      );
                                    } else {
                                      num newBolus =
                                          stringToNumber(bolusTextController.text) ?? sliderValue;
                                      insulinProvider.saveBolusDosage(newBolus);
                                    }
                                  }
                                },
                                child: const Text(
                                  "Deliver",
                                  style: TextStyle(fontSize: 17),
                                ),
                              );

                            }),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                          future: insulinProvider.getBasalLogs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(
                                'Error:${snapshot.error.toString()}',
                                style:
                                    TextStyle(fontSize: 8, color: Colors.red),
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
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          logs.length.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
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
                                                    Text(
                                                      "Bolus",
                                                    ),
                                                    Text(
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(
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
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 25,
                                                            ),
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

                                                          TextSpan(
                                                            text: "\nActive insulin: ",
                                                          ),
                                                          TextSpan(
                                                            text: log.activeInsulin.toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      DateFormat('hh:mm')
                                                          .format(
                                                              DateTime.parse(log
                                                                  .startTime)),
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
