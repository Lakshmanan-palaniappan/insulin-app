import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:insulin/providers/insulin_provider.dart';

import 'package:insulin/ui/pages/dashboard_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<InsulinProvider>().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return const DashboardPage();
      },
    );
  }
}
