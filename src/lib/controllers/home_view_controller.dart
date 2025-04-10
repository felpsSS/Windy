import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/device_controller.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/services/locator_service.dart';

class HomeViewController extends ChangeNotifier {
  bool isBusy = false;

  get busy => isBusy;

  void toggleBusy() {
    isBusy = !isBusy;
    notifyListeners();
  }

  //? Lista vuota crea errori di renderizzazione
  DeviceController deviceController = locator<DeviceController>();
  StorageController storageController = locator<StorageController>();

  bool isConnected() {
    return deviceController.bt.isConnected;
  }

  Future<List<Measure>?> getHistory() async {
    return storageController.history;
  }

  Future<void> fetchAirQualityData() async {
    toggleBusy();
    await deviceController.bluetoothLoop();
    storageController.averageBufferInHistory();
    storageController.reinitializeTimer();
    toggleBusy();
  }

  Future<int> scanBluetoothDevices() async {
    toggleBusy();
    var ret = await deviceController.scanBluetoothDevices();
    toggleBusy();
    return ret;
  }

  @override
  void dispose() {
    deviceController.dispose();
    storageController.dispose();
    super.dispose();
    debugPrint("HomeViewController disposed");
  }
}
