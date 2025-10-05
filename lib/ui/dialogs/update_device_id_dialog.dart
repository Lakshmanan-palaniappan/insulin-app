import 'package:flutter/material.dart';

import 'package:insulin/utils/utils.dart';

import 'package:insulin/ui/widgets/common/custom_text_field.dart';

class UpdateDeviceIdDialog extends StatelessWidget {
  UpdateDeviceIdDialog({
    super.key,
    required this.onDeviceIdSubmitted,
  });

  final Function(int? value) onDeviceIdSubmitted;
  final TextEditingController deviceIdController = TextEditingController();

  void onSaved() {
    int? deviceId = stringToInt(deviceIdController.text);
    onDeviceIdSubmitted(deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Device Id'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: CustomTextField(
        controller: deviceIdController,
        hintText: "Enter device ID",
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
