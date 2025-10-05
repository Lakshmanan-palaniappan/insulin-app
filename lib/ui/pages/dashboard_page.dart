import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'package:insulin/providers/insulin_provider.dart';

import 'package:insulin/ui/pages/bolus_page.dart';
import 'package:insulin/ui/pages/refill_page.dart';
import 'package:insulin/ui/pages/basal_page.dart';

import 'package:insulin/ui/widgets/dashboard/device_id_card.dart';
import 'package:insulin/ui/widgets/dashboard/greeting_card.dart';
import 'package:insulin/ui/widgets/dashboard/pump_details_card.dart';
import 'package:insulin/ui/widgets/dashboard/custom_button.dart';
import 'package:insulin/ui/widgets/dashboard/dark_mode_button.dart';

import 'package:insulin/ui/dialogs/update_device_id_dialog.dart';
import 'package:insulin/ui/dialogs/update_insulin_dialog.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    InsulinProvider insulinProvider =
        Provider.of<InsulinProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Home"),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data!.version}+(${snapshot.data!.buildNumber})',style: TextStyle(fontSize: 15),);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        leading: const Icon(Icons.notes),
        actions: const [
          DarkModeButton()
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const GreetingCard(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Access",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 4),
                    Divider(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomButton(
                      label: "Basal",
                      lottie: Lottie.asset("lib/assets/lottie/analytics.json"),
                      page: BasalPage(),
                    ),
                    CustomButton(
                      label: "Bolus",
                      lottie: Lottie.asset("lib/assets/lottie/add.json"),
                      page: const BolusPage(),
                    ),
                    CustomButton(
                      label: "Rewind",
                      lottie: Lottie.asset("lib/assets/lottie/refill.json"),
                      page: const RefillPage(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PumpDetailsCard(
                onUpdate: () {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateInsulinDialog(
                      onSubmitted: (insulinLevel) {
                        num newInsulinLevel = insulinLevel ??
                            insulinProvider.insulinData!.activeInsulin;
                        insulinProvider.updateInsulinLevel(newInsulinLevel);
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              DeviceIdCard(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateDeviceIdDialog(
                      onDeviceIdSubmitted: (deviceID) {
                        int newDeviceId = deviceID ?? insulinProvider.deviceId;
                        insulinProvider.updateDeviceId(newDeviceId);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
