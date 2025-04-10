import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends ChangeNotifier {
  String? saveDir;
  final String saveDirName = "AirQualityApp";
  final String saveFileName = "history.json";

  List<Measure>? history;
  List<Measure> histBuffer = [];

  Timer? histTimer;

  SharedPreferences? prefs;

  StorageController() {
    SharedPreferences.getInstance().then((sp) {
      prefs = sp;
      if (prefs!.getBool('notifications') == null) {
        prefs!.setBool('notifications', true);
      }
      if (prefs!.getBool('sound') == null) {
        prefs!.setBool('sound', true);
      }
      if (prefs!.getInt('update_rate') == null) {
        prefs!.setInt('update_rate', 1);
      }
    }).then((_) {
      setup();
    });
  }

  void changeUpdateRate(int new_rate) {
    prefs?.setInt('update_rate', new_rate);
    reinitializeTimer();
  }

  void setup() {
    //? Storage permissions and directory setup
    setupStorage().then((_) {
      loadHistory();
      reinitializeTimer();
    });
  }

  void reinitializeTimer() {
    if (histTimer != null) histTimer!.cancel();
    histTimer =
        Timer.periodic(Duration(minutes: prefs!.getInt('update_rate')!), (Timer t) {
      averageBufferInHistory();
    });
  }

  Future<void> setupStorage() async {
    Directory dir = Directory("");
    if (Platform.isAndroid) {
      dir = await getApplicationSupportDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    if (dir.path == "") {
      debugPrint("UNABLE TO GET STORAGE DIR");
      return;
    }

    var dirPath = dir.path;
    saveDir = dirPath;
    await Directory(dirPath).create(recursive: true);
  }

  void averageBufferInHistory() {
    if (histBuffer.isEmpty) return;

    double avgCo2 = 0;
    double avgTvoc = 0;
    double avgOverallAirQualityIndex = 0;

    for (Measure m in histBuffer) {
      avgCo2 += m.co2;
      avgTvoc += m.tvoc;
      avgOverallAirQualityIndex += m.overallAirQualityIndex;
    }
    avgCo2 = (avgCo2 / histBuffer.length);
    avgTvoc = (avgTvoc / histBuffer.length);
    avgOverallAirQualityIndex = (avgOverallAirQualityIndex / histBuffer.length);

    Measure histMeasure = Measure(
        time: DateTime.now(),
        co2: avgCo2,
        tvoc: avgTvoc,
        overallAirQualityIndex: avgOverallAirQualityIndex);

    history!.add(histMeasure);
    saveHistory();

    histBuffer.clear();
    notifyListeners();
  }

  Future<List<Measure>> getHistory() async {
    return history ?? [];
  }

  void addMeasure(Measure measure) async {
    histBuffer.add(measure);
  }

  List<Measure> jsonToHistory(String historyString) {
    List<Measure> ret = [];
    for (Map<String, dynamic> obj in jsonDecode(historyString)) {
      ret.add(Measure.fromJson(obj));
    }
    return ret;
  }

  void saveHistory() {
    assert(saveDir != null);
    final File saveFile = File("$saveDir/$saveFileName");
    saveFile.writeAsString(jsonEncode(history));
  }

  void loadHistory() {
    assert(saveDir != null);
    final File saveFile = File("$saveDir/$saveFileName");
    if (!saveFile.existsSync()) {
      history = [];
      notifyListeners();
      return;
    }
    var historyString = saveFile.readAsStringSync();
    history = jsonToHistory(historyString);
    notifyListeners();
  }

  @override
  void dispose() {
    if (histTimer != null) histTimer!.cancel();
    super.dispose();
    debugPrint("StorageController disposed");
  }
}
