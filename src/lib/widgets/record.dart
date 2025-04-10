import 'package:flutter/material.dart';

import 'package:hci_air_quality/models/measure.dart';

class Record extends StatelessWidget {
  final Measure measure;
  const Record({super.key, required this.measure});

  @override
  @override
  Widget build(BuildContext context) {
    DateTime localTime = measure.time.toLocal();

    String month = localTime.month.toString().padLeft(2, '0');
    String day = localTime.day.toString().padLeft(2, '0');
    String hour = localTime.hour.toString().padLeft(2, '0');
    String minute = localTime.minute.toString().padLeft(2, '0');

    return Card(
      child: ListTile(
          title: Row(children: [
            const Text('Overall: '),
            Text(
              '${measure.overallAirQuality().toStringAsFixed(0)}/10',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text('$month/$day $hour:$minute'),
          ]),
          subtitle: Text(
              'CO2: ${measure.co2.toStringAsFixed(1)} ppm, TVOC: ${measure.tvoc.toStringAsFixed(1)} ppb')),
    );
  }
}
