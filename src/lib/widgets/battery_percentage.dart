import 'package:flutter/material.dart';

class BatteryPercentage extends StatelessWidget {
  final double percentage;

  const BatteryPercentage({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          width: 45,
          height: 25,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.onSurface,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: (100 - percentage) *
              0.01 *
              45, // Adjust the width based on the percentage
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Text(
              percentage.toStringAsFixed(0) + "%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    percentage > 20 ? theme.colorScheme.onSurface : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
