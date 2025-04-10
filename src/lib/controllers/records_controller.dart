import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/services/locator_service.dart';

class RecordsController extends ChangeNotifier {
  StorageController storage = locator<StorageController>();
  bool isBusy = false;

  get busy => isBusy;

  void toggleBusy() {
    isBusy = !isBusy;
    notifyListeners();
  }

  Future<List<Measure>> getHistory() async {
    return storage.getHistory();
  }
}
