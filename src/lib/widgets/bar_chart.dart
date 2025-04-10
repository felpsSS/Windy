import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/widgets/stats_detail.dart';

var settings = {
  '10 min': {
    'delay': 600,
    'textFormatter': formatMinText,
  },
  '1 hour': {
    'delay': 3600,
    'textFormatter': formatHourText,
  },
  '1 day': {
    'delay': 3600 * 24,
    'textFormatter': formatDayText,
  },
  '1 week': {
    'delay': 3600 * 24 * 7,
    'textFormatter': weekTextFormat,
  },
};

const double co2Min = 0;
const double co2Max = 5000; // Example max value for CO2
const double tvocMin = 0;
const double tvocMax = 1200; // Example max value for TVOC
const double aqMin = 0;
const double aqMax = 10;

class CustomBarChart extends StatefulWidget {
  final List<Measure> history;
  final String mode;
  const CustomBarChart({super.key, required this.history, required this.mode});

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  List<String> modes = [
    '10 min',
    '1 hour',
    '1 day',
    '1 week',
  ];
  List<String> times = [
    '70 mins',
    '7 hours',
    '7 days',
    '7 weeks',
  ];
  int index = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Metrics Information'),
                          content: const Text(
                              'Making use of the companion device, this application uses two sensor metrics, from which it calculates an overall air quality index.\r\n\r\nCO2: contrary to popular belief, it is a common indoor air pollutant.\r\nTVOC: Total Volatile Organic Compounds, emitted as gases from certain solids or liquids.\r\n\r\nMeasures are given in parts per million (ppm) and parts per billion (ppb).'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info)),
              Text(getGraphHeader(), style: theme.textTheme.headlineSmall),
              const Spacer(),
              DropdownButton(
                items: modes.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    index = modes.indexOf(value!);
                  });
                },
                value: modes[index],
              ),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            (widget.mode != 'aq'
                ? widget.mode != 'tvoc' ? const Text('ppm (lower is better)',
                    style: TextStyle(fontWeight: FontWeight.bold)) :
                const Text('ppb (lower is better)', style: TextStyle(fontWeight: FontWeight.bold))
                : const Text('quality (higher is better)',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: BarChart(
              barData(widget.history, widget.mode, modes[index], context),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: isExpanded ? 155.0 : 0.0,
          width: double.infinity,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: isExpanded ? 1.0 : 0.0,
              child: Card(
                color: theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatsDetail(
                    mode: times[index],
                    min: widget.mode == 'co2'
                        ? co2Min
                        : (widget.mode == 'aq')
                            ? aqMin
                            : tvocMin,
                    max: widget.mode == 'co2'
                        ? co2Max
                        : (widget.mode == 'aq')
                            ? aqMax
                            : tvocMax,
                    average: getBarGroupsAverage(widget.history, widget.mode, (settings[modes[index]]!['delay'] as int), 7),
                    value: widget.history.isNotEmpty
                        ? getHistoryValue(widget.mode, widget.history.last)
                        : 0.0,
                    unit: widget.mode == 'aq' ? 'quality index' : widget.mode == 'tvoc' ? 'ppb' : 'ppm',
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon:
                  Icon(isExpanded ? Icons.cancel_outlined : Icons.query_stats),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/records');
              },
              icon: const Icon(Icons.manage_search),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        )
      ],
    );
  }

  String getGraphHeader() {
    return widget.mode == 'co2'
        ? 'CO2'
        : (widget.mode == 'aq')
            ? 'Air Quality'
            : 'TVOC';
  }
}

BarChartData barData(List<Measure> history, mode, timeMode, context) {
  return BarChartData(
    barTouchData: BarTouchData(enabled: false),
    gridData: const FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: createBottomTitleWidgets(
              settings[timeMode]!['delay'] as int,
              settings[timeMode]!['textFormatter']),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          // interval: history.isEmpty? 1 : history
          //         .map((value) => mode == 'aq'
          //             ? value.overallAirQuality().toDouble()
          //             : mode == 'tvoc'
          //                 ? value.tvoc
          //                 : value.co2)
          //         .reduce(max) / 5,
          interval: mode == 'aq' ? 2 : mode == 'tvoc' ? 200 : 1000,
          getTitlesWidget: mode != 'aq'
              ? leftTitleWidgets
              : leftTitleAQWidgets,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    barGroups:
        getBarGroups(history, mode, settings[timeMode]!['delay'] as int, 7, context),
  );
}

Widget leftTitleAQWidgets(double value, TitleMeta meta) {
  return Text((value).toInt().toString(), textAlign: TextAlign.left);
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  if (value <= 0.00001) {
    return const Text('0', textAlign: TextAlign.left);
  } else if (value < 1000) {
    return Text(value.toInt().toString(), textAlign: TextAlign.left);
  }
  return Text('${(value / 1000).toStringAsFixed(1)}k', textAlign: TextAlign.left);
}

formatMinText(now, value, delay) {
  DateTime toShow = now.subtract(Duration(seconds: value.toInt() * delay));
  return Text(
      '${toShow.hour.toString().padLeft(2, '0')}:${toShow.minute.toString().padLeft(2, '0')}');
}

formatHourText(now, value, delay) {
  DateTime toShow = now.subtract(Duration(seconds: value.toInt() * delay));
  return Text(toShow.hour.toString().padLeft(2, '0'));
}

formatDayText(now, value, delay) {
  DateTime toShow = now.subtract(Duration(seconds: value.toInt() * delay));
  switch (toShow.weekday) {
    case 1:
      return const Text('Mon');
    case 2:
      return const Text('Tue');
    case 3:
      return const Text('Wed');
    case 4:
      return const Text('Thu');
    case 5:
      return const Text('Fri');
    case 6:
      return const Text('Sat');
    case 7:
      return const Text('Sun');
  }
}

weekTextFormat(now, value, delay) {
  DateTime toShow = now.subtract(Duration(seconds: value.toInt() * delay));
  return Text(
      '${toShow.day.toString().padLeft(2, '0')}/${toShow.month.toString().padLeft(2, '0')}');
}

createBottomTitleWidgets(int delay, textFormatter) {
  DateTime now = DateTime.now();
  int secondsSinceEpoch = now.millisecondsSinceEpoch ~/ 1000;
  secondsSinceEpoch = secondsSinceEpoch - secondsSinceEpoch % delay;
  now = DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  return (double value, TitleMeta meta) {
    Widget text = textFormatter(now, value, delay);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  };
}

double getHistoryValue(mode, element) {
  return mode == 'co2'
      ? element.co2
      : mode == 'aq'
          ? element.overallAirQuality().toDouble()
          : element.tvoc;
}

double getBarGroupsAverage(
  history,
  mode,
  delay,
  bars
) {
  int maxPastTime = delay * bars;
  DateTime now = DateTime.now();
  int offset = ((now.millisecondsSinceEpoch ~/ 1000) % delay).toInt();
  maxPastTime += offset;

  AveragingGadget meanComputer = AveragingGadget(now.add(Duration(seconds: offset)), 0, 0);

  for (int i = history.length - 1; i >= 0; i--) {
    if (meanComputer.checkDelay(history[i].time, maxPastTime)) {
      break;
    }
    meanComputer.add(getHistoryValue(mode, history[i]));
    meanComputer.increase();
  }
  return meanComputer.count > 0 ? meanComputer.mean : 0;
}

List<BarChartGroupData> getBarGroups(
    List<Measure> history, mode, int delay, bars, context) {
  List<AveragingGadget> spots = [];

  DateTime now = DateTime.now();
  int offset = ((now.millisecondsSinceEpoch ~/ 1000) % delay).toInt();
  now = now.add(Duration(seconds: offset));

  for (int i = 0; i < bars; i++) {
    spots.add(
        AveragingGadget(now.subtract(Duration(seconds: (delay * i))), 0, 0));
  }

  int i = history.length - 1;
  int currSpot = 0;
  while (i >= 0 && currSpot < spots.length) {
    if (!spots[currSpot].checkDelay(history[i].time, delay)) {
      spots[currSpot].add(getHistoryValue(mode, history[i]));
      spots[currSpot].increase();
      i--;
    } else {
      currSpot++;
    }
  }

  i = bars;
  return spots.reversed
      .map((e) {
        double v = e.count > 0 ? e.running / e.count : 0;
        return BarChartGroupData(
            x: --i,
            barRods: [
              BarChartRodData(
                toY: v,
                color: getBarColor(10 - (mode == 'aq' ? v: (mode == 'tvoc' ? ((1100 - v) / 110) : ((400 - v) / 178 + 10))), 10), // Colors.green,
                width: 8,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: mode == 'aq' ? aqMax : mode == 'tvoc' ? tvocMax : co2Max,
                  //color: Colors.grey.withOpacity(0.1),
                  color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(.1),
                ),
              ),
            ],
          );
        }
      ).toList();
}

Color getBarColor(double value, double max) {
  if (value < max / 3) {
    return Colors.green;
  } else if (value < 2 * max / 3) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

class AveragingGadget {
  late int count = 0;
  late double running = 0;
  late DateTime time;

  AveragingGadget(this.time, this.running, this.count);

  void increase() {
    count++;
  }

  void add(double value) {
    running += value;
  }

  void clear() {
    count = 0;
    running = 0;
  }

  double get mean => running / count;

  bool checkDelay(DateTime time, int delay) {
    return this.time.difference(time).inSeconds > delay;
  }
}
