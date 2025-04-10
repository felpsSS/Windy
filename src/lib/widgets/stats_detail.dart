import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StatsDetail extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final double? average;
  final String mode;
  final String unit;

  const StatsDetail(
      {super.key,
      required this.mode,
      required this.min,
      required this.max,
      required this.value,
      this.average,
      required this.unit});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              const Text('Average value: '),
              Text(
                unit == 'quality index'
                    ? average!.floor().toString()
                    : average!.toStringAsFixed(1),
                style: theme.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                ' $unit',
              )
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text('$unit score in the last $mode:'),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: SfLinearGauge(
                isMirrored: true,
                maximum: max,
                markerPointers: [
                  LinearShapePointer(
                    value: average!,
                  )
                ],
                barPointers: [
                  LinearBarPointer(
                      value: max,
                      thickness: 10,
                      //Apply linear gradient
                      shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: unit == 'quality index'
                                  ? [Colors.red, Colors.green]
                                  : [Colors.green, Colors.red])
                          .createShader(bounds)),
                ],
              )),
          Align(
            alignment: Alignment.topLeft,
            child: Text(unit == 'quality index'
                ? suggestAction(100 - average! * 100 / max)
                : suggestAction(average! * 100 / max)),
          )
        ],
      ),
    );
  }
}

String suggestAction(double value) {
  if (value < 33) {
    return 'The average value is low. You have examined a good air quality.';
  } else if (value < 66) {
    return 'The average value is moderate. You should open your windows to let fresh air in.';
  } else if (value < 100) {
    return 'The average value is high. You should open your windows to let fresh air in.';
  }
  return 'The average strangly high. Probably some sensor error.';
}
