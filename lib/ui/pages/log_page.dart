import 'package:flutter/material.dart';
import 'package:insulin/providers/insulin_provider.dart';

import 'package:insulin/ui/pages/preset_bolus_page.dart';
import 'package:insulin/ui/pages/manual_bolus_page.dart';
import 'package:intl/intl.dart';

import '../../models/Log.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: InsulinProvider().getActivityLogs(),
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
                  DateTime at = DateTime.parse(a.endTime),
                      bt = DateTime.parse(b.endTime);
                  return at.isAfter(bt) ? 1 : -1;
                });
                return Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Text(
                          "Log History",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          padding: EdgeInsets.all(6),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            logs.length.toString(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Card.outlined(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                        "Activity type",
                                      ),
                                      Text(
                                        DateFormat('hh:mm dd/MM/yyyy').format(
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
                                              text: "${log.typeOfActivity}\n",
                                              style: const TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Units: ",
                                            ),
                                            TextSpan(
                                              text: log.units.toString(),
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
                                        DateFormat('hh:mm dd/MM/yyyy').format(
                                          DateTime.parse(
                                            log.endTime,
                                          ),
                                        ),
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
      ),
    );
  }
}
