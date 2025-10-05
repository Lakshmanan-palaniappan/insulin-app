import 'package:flutter/material.dart';

import 'package:insulin/utils/utils.dart';

import 'package:insulin/ui/widgets/common/custom_text_field.dart';

class UpdateInsulinDialog extends StatelessWidget {
  UpdateInsulinDialog({
    super.key,
    required this.onSubmitted,
  });

  final Function(num? value) onSubmitted;
  final TextEditingController insulinTextController = TextEditingController();

  void onSaved() {
    num? insulinLevel = stringToNumber(insulinTextController.text);
    onSubmitted(insulinLevel);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insulin level'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: CustomTextField(
        controller: insulinTextController,
        hintText: "Enter insulin level in units",
      ),
      actions: <Widget>[
        FilledButton(
          child: const Text('Save'),
          onPressed: () {
            onSaved();
            Navigator.pop(context);
          },
        ),
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
