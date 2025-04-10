import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hci_air_quality/controllers/storage_controller.dart';
import 'package:hci_air_quality/services/locator_service.dart';

const DEVICE_NAME = "Air Quality - XIAO";
const SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const CO2_UUID = "beb5483a-36e1-4688-b7f5-ea07361b26a8";
const TVOC_UUID = "beb5483b-36e1-4688-b7f5-ea07361b26a8";
const BATTERY_UUID = "beb5483c-36e1-4688-b7f5-ea07361b26a8";
const QINDEX_UUID = "beb5483d-36e1-4688-b7f5-ea07361b26a8";

class Bluetooth extends ChangeNotifier {

  StreamSubscription<BluetoothConnectionState>? connectionSubscripion;

  StorageController storage = locator<StorageController>();
  final String saveFileName = "deviceRemoteId.txt";

  String? deviceRemoteId;
  BluetoothDevice? device;
  BluetoothCharacteristic? co2Characteristic;
  BluetoothCharacteristic? tvocCharacteristic;
  BluetoothCharacteristic? batteryCharacteristic;
  BluetoothCharacteristic? qIndexCharacteristic;

  //? Costruttore
  Bluetooth();

  bool get isConnected => device != null && device!.isConnected;

  Future<void> scanAndConnect() async {
    //? DEBUG, devo metterlo qui???

    //? Controllo di poter usare il bluetooth
    if (await FlutterBluePlus.isSupported == false) {
      debugPrint("Bluetooth not supported!");
      return;
    }

    //? Se ho già salvato un remoteId, lo utilizzo
    final String? saveDir = storage.saveDir;
    debugPrint("saveDir = $saveDir");
    if (saveDir != null) {
      File saveFile = File("$saveDir/$saveFileName");
      if (saveFile.existsSync()) {
        deviceRemoteId = saveFile.readAsStringSync();
      }
    }

    //? Azioni da fare durante lo scan dei device
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        for (ScanResult r in results) {
          debugPrint("AdvName = ${r.device.advName}");

          //? Trovo l'esatto MAC_48 del device (salvato in precedenza)
          if (deviceRemoteId != null &&
              deviceRemoteId == r.device.remoteId.toString()) {
            debugPrint("Remote ID in filesystem: $deviceRemoteId");
            connectToDevice(r.device);
            FlutterBluePlus.stopScan();
            break;
          }

          //? Trovo un device con il nome advertised corrispondente
          if ((r.device.advName != "") && (DEVICE_NAME == r.device.advName)) {
            debugPrint("Device trovato! ${r.device.advName}");
            connectToDevice(r.device);
            FlutterBluePlus.stopScan();
            break;
          }
        }
      }
    }, onError: (e) => debugPrint(e));

    //? Rimuovo la subscription quando ho fatto per evitare duplicati
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    //? Accendo il bluetooth se sono su android
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    //? Aspetto che il bluetooth sia acceso e i permessi concessi
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    //? Inizio lo scan con un timeout
    await FlutterBluePlus.startScan(
        //! withRemoteIds: [""],
        //! withServices: [Guid(SERVICE_UUID)],
        withNames: [DEVICE_NAME],
        timeout: const Duration(seconds: 10));

    //? Aspetto che lo scan termini
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  Future<void> connectToDevice(BluetoothDevice foundDevice) async {
    device = foundDevice;
    debugPrint("connectToDevice: ${device!.advName}");

    //? Creo la subscription per controllare lo stato della disconnesione
    connectionSubscripion = device!.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected){
        debugPrint("Disconnected from device");
        notifyListeners();
      }
    });

    try {
      //? Mi connetto al device e ne leggo servizi e caratteristiche
      await device!.connect();
      saveDeviceId(device!.remoteId.toString());
      await discoverServices();
    } catch (e) {
      debugPrint("Error connecting to device: $e");
    }
    
  }

  //? Trovo il servizio corretto e le 3 caratteristiche
  Future<void> discoverServices() async {
    if (device == null) return;
    List<BluetoothService> services = await device!.discoverServices();

    //? Salvo le characteristic di interesse nel corretto service
    for (BluetoothService s in services) {
      debugPrint("Service: ${s.uuid.toString()}");
      if (s.uuid.toString() == SERVICE_UUID) {
        for (BluetoothCharacteristic c in s.characteristics) {
          debugPrint("Characteristic: ${c.uuid.toString()}");
          if (c.uuid.toString() == CO2_UUID) {
            co2Characteristic = c;
          } else if (c.uuid.toString() == TVOC_UUID) {
            tvocCharacteristic = c;
          } else if (c.uuid.toString() == BATTERY_UUID) {
            batteryCharacteristic = c;
          } else if (c.uuid.toString() == QINDEX_UUID) {
            qIndexCharacteristic = c;
          }
        }
      }
    }
  }

  //? Funzioni asincrone per leggere i valori
  Future<int> readCo2Data() async {
    if (co2Characteristic == null) {
      debugPrint("co2Characteristic is null");
      return -1;
    }
    return await co2Characteristic!.read().then((value) => convertBytesToInt(value)).timeout(const Duration(seconds: 1), onTimeout: () => -1);
  }

  Future<int> readTvocData() async {
    if (tvocCharacteristic == null) {
      debugPrint("tvocCharacteristic is null");
      return -1;
    }
    return await tvocCharacteristic!.read().then((value) => convertBytesToInt(value)).timeout(const Duration(seconds: 1), onTimeout: () => -1);
  }

  Future<int> readBatteryData() async {
    if (batteryCharacteristic == null) {
      debugPrint("batteryCharacteristic is null");
      return -1;
    }
    return await batteryCharacteristic!.read().then((value) => convertBytesToInt(value)).timeout(const Duration(seconds: 1), onTimeout: () => -1);
  }

  Future<int> readQualityIndexData() async {
    if (qIndexCharacteristic == null) {
      debugPrint("qIndexCharacteristic is null");
      return -1;
    }
    return await qIndexCharacteristic!.read().then((value) => convertBytesToInt(value)).timeout(const Duration(seconds: 1), onTimeout: () => -1);
  }

  int convertBytesToInt(List<int> bytes) {
    List<String> binaryStrings = bytes.map((byte) {
      return byte.toRadixString(2).padLeft(8, '0');
    }).toList();
    String concatenatedBinary = binaryStrings.reversed.join();
    return int.parse(concatenatedBinary, radix: 2);
  }

  void saveDeviceId(String remoteId) {
    final String? saveDir = storage.saveDir;
    if (saveDir == null) return;
    File saveFile = File("$saveDir/$saveFileName");
    saveFile.writeAsStringSync(remoteId);
    debugPrint("remoteId witten to $saveFileName");
  }

  Future<int> disconnect() async {
    if ((device == null) || (! device!.isConnected)) return 1;
    try {
      debugPrint("Disconnecting from device...");
      await device!.disconnect();
      debugPrint("disconnect() finished");
    } catch (e) {
      debugPrint("Error disconnecting device: $e");
      return -1;
    } finally {
      connectionSubscripion?.cancel();
      connectionSubscripion = null;
      debugPrint("Disconnection successful");
    }
    return 0;
  }

}
