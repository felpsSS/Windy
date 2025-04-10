import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/views/homeView/rating.dart';
import 'package:hci_air_quality/widgets/pop_over.dart';

class AlternativeView extends StatefulWidget {
  final Measure? lastMeasure;

  const AlternativeView({
    super.key,
    required this.lastMeasure,
  });

  @override
  _AlternativeViewState createState() => _AlternativeViewState();
}

Size calculateTextSize({
  required String text,
  required TextStyle style,
  required BuildContext context,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  return textPainter.size;
}

class _AlternativeViewState extends State<AlternativeView> {
  OverlayEntry? _popoverOverlayEntry;

  void _showPopover(BuildContext context, String message, GlobalKey key) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _popoverOverlayEntry = _createPopoverOverlayEntry(
      context,
      message,
      position & size,
    );
    Overlay.of(context).insert(_popoverOverlayEntry!);
  }

  void _hidePopover() {
    _popoverOverlayEntry?.remove();
    _popoverOverlayEntry = null;
  }

  OverlayEntry _createPopoverOverlayEntry(
      BuildContext context, String message, Rect iconRect) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hidePopover,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: iconRect.top + iconRect.height + 5,
              child: Popover(
                message: message,
                onClose: _hidePopover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final infoIconKey = GlobalKey();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.lastMeasure != null
                    ? widget.lastMeasure!.overallAirQuality() >= 7
                        ? Icons.sentiment_very_satisfied
                        : widget.lastMeasure!.overallAirQuality() >= 4
                            ? Icons.sentiment_satisfied
                            : Icons.sentiment_dissatisfied
                    : Icons.sentiment_satisfied,
                size: 40,
                color: widget.lastMeasure != null
                    ? widget.lastMeasure!.overallAirQuality() >= 7
                        ? Colors.green
                        : widget.lastMeasure!.overallAirQuality() >= 4
                            ? Colors.yellow
                            : Colors.red
                    : Colors.yellow,
              ),
              const SizedBox(width: 8),
              Text(
                widget.lastMeasure != null
                    ? widget.lastMeasure!.overallAirQuality() >= 7
                        ? 'Good Air Quality'
                        : widget.lastMeasure!.overallAirQuality() >= 4
                            ? 'Moderate Air Quality'
                            : 'Poor Air Quality'
                    : 'No Data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.lastMeasure != null
                      ? widget.lastMeasure!.overallAirQuality() >= 7
                          ? Colors.green
                          : widget.lastMeasure!.overallAirQuality() >= 4
                              ? Colors.yellow
                              : Colors.red
                      : Colors.yellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.lastMeasure != null ? widget.lastMeasure!.overallAirQuality() : "-"}/10',
                style: theme.textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              RatingIcon(
                  icon: Icons.star_rate,
                  size: 30,
                  iconColor: Colors.yellow,
                  percentage: widget.lastMeasure != null
                      ? widget.lastMeasure!.overallAirQuality() / 10
                      : 0.0),
              const SizedBox(width: 4),
              GestureDetector(
                key: infoIconKey,
                onTap: () => _showPopover(
                  context,
                  'This is the overall air quality score out of 10.',
                  infoIconKey,
                ),
                child: const Icon(Icons.info_outline, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * .1),
              const Text('CO2:')
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              value: widget.lastMeasure != null
                  ? widget.lastMeasure!.co2 / 5000
                  : 0.0,
            ),
          ),
          Row(
            children: [
              SizedBox(
                  width: max(
                      20,
                      min(
                          MediaQuery.of(context).size.width * .73 + 20,
                          20 +
                              MediaQuery.of(context).size.width *
                                  0.76 *
                                  (widget.lastMeasure != null
                                      ? widget.lastMeasure!.co2 / 5000
                                      : 0.0)))),
              Text(
                '${widget.lastMeasure != null ? widget.lastMeasure!.co2.toStringAsFixed(1) : "-"} ppm',
                style: theme.textTheme.bodyMedium,
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * .1),
              const Text('TVOC:')
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              value: widget.lastMeasure != null
                  ? widget.lastMeasure!.tvoc / 1200
                  : 0.0,
            ),
          ),
          Row(
            children: [
              SizedBox(
                  width: max(
                      20,
                      min(
                          MediaQuery.of(context).size.width * .73 + 20,
                          20 +
                              MediaQuery.of(context).size.width *
                                  0.76 *
                                  (widget.lastMeasure != null
                                      ? widget.lastMeasure!.tvoc / 1200
                                      : 0.0)))),
              Text(
                '${widget.lastMeasure != null ? widget.lastMeasure!.tvoc.toStringAsFixed(1) : "-"} ppb',
                style: theme.textTheme.bodyMedium,
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.lastMeasure != null
                  ? 'Last update: ${widget.lastMeasure!.time.day.toString().padLeft(2, '0')}/${widget.lastMeasure!.time.month.toString().padLeft(2, '0')} ${widget.lastMeasure!.time.hour.toString().padLeft(2, '0')}:${widget.lastMeasure!.time.minute.toString().padLeft(2, '0')}'
                  : 'Last update: never'),
            ],
          )
        ],
      ),
    );
  }
}
