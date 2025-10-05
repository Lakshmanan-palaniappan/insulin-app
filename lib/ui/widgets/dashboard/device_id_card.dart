import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:insulin/providers/insulin_provider.dart';

import '../../pages/log_page.dart';

class DeviceIdCard extends StatelessWidget {
  const DeviceIdCard({
    super.key,
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Consumer<InsulinProvider>(
          builder: (context, deviceIdProvider, child) {
            final deviceId = deviceIdProvider.deviceId;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text("Device Id"),
                        const SizedBox(height: 8),
                        Text(
                          "$deviceId",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: (){
                        deviceIdProvider.pingIsActive();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: deviceIdProvider.insulinData!.wifistatus==0 ? Colors.redAccent : Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        //width: MediaQuery.of(context).size.width * 0.3,
                        //height: 40,
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Text(
                              deviceIdProvider.insulinData!.wifistatus==0 ? 'Disconnected' : 'Connected',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.lightbulb_rounded,color: deviceIdProvider.insulinData!.wifistatus==0 ? Colors.redAccent : Colors.green,),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: onPressed,
                      child: const Text("Change Device Id"),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogPage()));
                      },
                      child: const Text("Log"),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
