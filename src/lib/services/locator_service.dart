import 'package:get_it/get_it.dart';
import 'package:hci_air_quality/controllers/device_controller.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/services/bluetooth_service.dart';
final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<StorageController>(StorageController());
  locator.registerSingleton<Bluetooth>(Bluetooth());
  locator.registerSingleton<DeviceController>(DeviceController());
}
