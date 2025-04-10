import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Measure {
  final DateTime time;
  final double co2; //pp milione
  final double tvoc;  //pp miliardo
  final double overallAirQualityIndex;

  Measure({required this.time, required this.co2, required this.tvoc, required this.overallAirQualityIndex});

  factory Measure.fromJson(Map<String, dynamic> json) {
    return Measure(
        time: DateTime.parse(json['time']),
        co2: json['co2'],
        tvoc: json['tvoc'],
        overallAirQualityIndex: json.containsKey('overallAirQualityIndex') ? json['overallAirQualityIndex'] : 0.0
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'co2': co2,
      'tvoc': tvoc,
      'overallAirQualityIndex': overallAirQualityIndex,
    };
  }

  Map<String, double> singleAirQualityIndices() {
    double co2Index = max((400 - co2) / 178 + 10, 0);
    double tvocIndex = max((1100 - tvoc) / 110, 0);
    return {'CO2': co2Index, 'TVOC': tvocIndex};
  }

  int overallAirQuality() {
    return overallAirQualityIndex.floor();
  }

  List<PieChartSectionData> createPieChartSection() {
    Map<String, double> aq = singleAirQualityIndices();

    PieChartSectionData pieCo2 = PieChartSectionData(
      value: 10 - aq['CO2']!,
      radius: 70,
      color: const Color.fromARGB(255, 7, 87, 4),
      title: 'CO2',
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    );

    PieChartSectionData pieTVOC = PieChartSectionData(
      value: 10 - aq['TVOC']!,
      radius: 50,
      color: const Color.fromARGB(179, 10, 179, 52),
      title: 'TVOC',
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
    );

    return [pieCo2, pieTVOC];
  }
}
