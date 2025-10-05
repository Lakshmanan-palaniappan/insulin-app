import 'package:flutter/material.dart';
import 'package:insulin/models/preset_bolus.dart';
import 'package:insulin/services/local_database_services.dart';

class PresetBolusProvider with ChangeNotifier {
  List<PresetBolus> _presetBolusList = [];
  late LocalDatabaseServices _localDatabaseServices;

  PresetBolusProvider() {
    _localDatabaseServices = LocalDatabaseServices();
    _loadPresetBolusList();
  }

  List<PresetBolus> get presetBolusList => _presetBolusList;

  void _loadPresetBolusList() async {
    final List<String> storedList =
        await _localDatabaseServices.getPresetBolusList();

    _presetBolusList = storedList.map(
      (item) {
        final splitItem = item.split(',');
        return PresetBolus(
          title: splitItem[0],
          units: double.parse(splitItem[1]),
        );
      },
    ).toList();

    notifyListeners();
  }

  void addPresetBolusItem(PresetBolus item) {
    _presetBolusList.add(item);
    _savePresetBolusList();
    notifyListeners();
  }

  void updatePresetBolusItem(int index, PresetBolus newItem) {
    _presetBolusList[index] = newItem;
    _savePresetBolusList();
    notifyListeners();
  }

  void _savePresetBolusList() async {
    final List<String> storedList = _presetBolusList.map((item) {
      return '${item.title},${item.units}';
    }).toList();
    print(storedList.toString());
    _localDatabaseServices.savePresetBolusList(storedList);
  }
}
