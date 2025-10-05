import 'package:flutter/material.dart';
import 'package:insulin/ui/widgets/common/custom_text_field.dart';

class PresetBolusEditDialog extends StatelessWidget {
  PresetBolusEditDialog({
    super.key,
    required this.bolusUnits,
    required this.bolusName,
    required this.onEdit,
  });

  final num bolusUnits;
  final String bolusName;
  final Function(String name, String units) onEdit;

  final TextEditingController bolusUnitsController = TextEditingController();
  final TextEditingController bolusNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bolusNameController.text = bolusName;
    bolusUnitsController.text = bolusUnits.toString();
    return AlertDialog(
      title: const Text(
        "Edit",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          CustomTextField(
            controller: bolusNameController,
            hintText: 'Name',
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: bolusUnitsController,
            hintText: 'Bolus',
          ),
        ],
      ),
      actions: <Widget>[
        FilledButton(
          onPressed: () {
            onEdit(bolusNameController.text, bolusUnitsController.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
