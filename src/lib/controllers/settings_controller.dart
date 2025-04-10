import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/services/locator_service.dart';

class SettingController extends ChangeNotifier {
  bool isBusy = false;

  get busy => isBusy;

  void toggleBusy() {
    isBusy = !isBusy;
    notifyListeners();
  }

  StorageController storage = locator<StorageController>();
}
