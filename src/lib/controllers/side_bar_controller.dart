import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/device_controller.dart';
import 'package:hci_air_quality/services/locator_service.dart';

class SideBarController extends ChangeNotifier {
  DeviceController device_controller = locator<DeviceController>();

  bool isConnected() {
    return device_controller.bt.isConnected;
  }

  bool isBusy = false;

  get busy => isBusy;

  void toggleBusy() {
    isBusy = !isBusy;
    notifyListeners();
  }
}
