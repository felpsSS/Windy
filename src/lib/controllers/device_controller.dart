import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/services/bluetooth_service.dart';
import 'package:hci_air_quality/services/locator_service.dart';

class DeviceController extends ChangeNotifier {
  //? Lista vuota crea errori di renderizzazione
  late Measure currentMeasure;

  late double batteryPercentage = 1;

  //? Setting del Timer per il loop di lettura dal device
  Timer? timer;
  final int timerIntervalSec = 5;

  StorageController storage = locator<StorageController>();
  Bluetooth bt = locator<Bluetooth>();

  bool isBusy = false;

  get busy => isBusy;

  void toggleBusy() {
    isBusy = !isBusy;
    notifyListeners();
  }

  Future<bool> fetchBatteryPercentage() async {
    toggleBusy();
    toggleBusy();
    return true;
  }

  Future<bool> fetchBluetoothConnection() async {
    toggleBusy();
    var ret = true;
    if (bt.device == null) ret = false;
    if (!bt.device!.isConnected) ret = false;
    toggleBusy();
    return ret;
  }

  Future<int> scanBluetoothDevices() async {
    toggleBusy();

    await bt.scanAndConnect();
    debugPrint("scanAndConnect() EXITED");

    if (bt.device == null) {
      toggleBusy();
      return -1;
    } else {
      toggleBusy();
      startBluetoothLoop();
      return 0;
    }
  }

  void startBluetoothLoop() {
    timer = Timer.periodic(Duration(seconds: timerIntervalSec), (Timer t) {
      bluetoothLoop();
    });
  }

  //? Funzione eseguita ogni timerIntervalSec secondi
  Future<void> bluetoothLoop() async {
    //debugPrint("bluetoothLoop: ${DateTime.now().toString()}");
    var co2 = await bt.readCo2Data();
    var tvoc = await bt.readTvocData();
    var battery = await bt.readBatteryData();
    var qIndex = await bt.readQualityIndexData();

    if (co2 == -1 || tvoc == -1 || battery == -1 || qIndex == -1) {
      return;
    }

    // Random r = Random();
    // double co2 = 5000 * r.nextDouble();
    // double tvoc = 1200 * r.nextDouble();
    // double qIndex = max((400 - co2) / 178 + 10, 0) * .5 +
    //     max((1100 - tvoc) / 110, 0) * .5;

    // double battery = 100 * r.nextDouble();

    Measure newMeasure = Measure(
      time: DateTime.now(),
      co2: co2.toDouble(),
      tvoc: tvoc.toDouble(),
      overallAirQualityIndex: qIndex.toDouble(),
    );

    storage.addMeasure(newMeasure);
    batteryPercentage = battery.toDouble() / 100;

    if (storage.history != null) {
      int alert = calcAlert(storage.history!
                .where((m) => m.time.isAfter(
                    DateTime.now().subtract(const Duration(hours: 24))))
                .toList(), newMeasure);

      if (alert == 1 && canAlert(storage.prefs?.getString('last_alert'))) {
        storage.prefs?.setString('last_alert', DateTime.now().toIso8601String());
        launchNotification("⚠️⚠️ BAD AIR QUALITY!!! ⚠️⚠️",
            "Run if you can, without breathing...");
      } else if (alert == 2 &&
          canAlert(storage.prefs?.getString('last_reassurance'))) {
        storage.prefs?.setString('last_reassurance', DateTime.now().toIso8601String());
        launchNotification("Really good air quality 👍👍",
            "Enjoy the fresh air!");
      }
    }

    notifyListeners();
  }

  bool canAlert(String? last) {
    if (last == null) {
      return true;
    }
    return DateTime.parse(last)
        .isBefore(DateTime.now().subtract(const Duration(hours: 24)));
  }

  int calcAlert(List<Measure> interval, Measure last) {
    double aq = 0;
    for (Measure m in interval) {
      aq += m.overallAirQualityIndex;
    }
    aq = aq / interval.length;
    if (last.overallAirQualityIndex < (aq / 2)) {
      return 1;
    } else if (last.overallAirQualityIndex >= (aq + 10) / 2) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    bt.disconnect().then((status) {
      if (status == 0){
        debugPrint("Bluetooth disconnected");
      } else if (status == -1){
        debugPrint("Disconnect error");
      } else {
        debugPrint("Nothing to disconnect");
      }
    }).whenComplete(() {
      debugPrint("DeviceController disposed");
      super.dispose();
    });
  }
}

void launchNotification(String title, String body) async {
  StorageController storage = locator<StorageController>();
  if (storage.prefs?.getBool('notifications')??false) {
    if (storage.prefs?.getBool('sound')??false) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'sound_channel',
          actionType: ActionType.Default,
          title: title,
          body: body,
        ),
      );
    } else {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          actionType: ActionType.Default,
          title: title,
          body: body,
        ),
      );
    }
  }
}
