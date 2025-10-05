import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:insulin/models/preset_bolus.dart';

import 'package:insulin/providers/insulin_provider.dart';
import 'package:insulin/providers/preset_bolus_provider.dart';

import 'package:insulin/utils/utils.dart';

import 'package:insulin/ui/dialogs/deliver_bolus_dialog.dart';
import 'package:insulin/ui/dialogs/preset_bolus_edit_dialog.dart';

import 'package:insulin/ui/widgets/preset_bolus/bolus_tile.dart';

class PresetBolusPage extends StatelessWidget {
  const PresetBolusPage({super.key});

  @override
  Widget build(BuildContext context) {
    InsulinProvider insulinProvider =
        Provider.of<InsulinProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preset Bolus'),
      ),
      body: Consumer<PresetBolusProvider>(
        builder: (context, presetBolusProvider, child) {
          return ListView.builder(
            itemCount: presetBolusProvider.presetBolusList.length,
            itemBuilder: (context, index) {
              final item = presetBolusProvider.presetBolusList[index];
              return BolusTile(
                title: item.title,
                units: item.units,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeliverBolusDialog(
                      bolus: item.units,
                      onDeliver: () {
                        insulinProvider.saveBolusDosage(item.units);
                      },
                    ),
                  );
                },
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) => PresetBolusEditDialog(
                      bolusUnits: item.units,
                      bolusName: item.title,
                      onEdit: (name, units) {
                        PresetBolus newBolus = PresetBolus(
                          title: name,
                          units: stringToNumber(units) ?? item.units,
                        );
                        presetBolusProvider.updatePresetBolusItem(
                            index, newBolus);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newItem = PresetBolus(title: 'Bolus', units: 0.0);
          Provider.of<PresetBolusProvider>(context, listen: false)
              .addPresetBolusItem(newItem);
        },
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
