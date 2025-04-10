import 'package:flutter/material.dart';

// Thanks, https://stackoverflow.com/questions/70146159/dynamic-filled-star-in-flutter

class BatteryIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  final double percentage;

  const BatteryIcon(
      {super.key,
      required this.icon,
      required this.size,
      required this.percentage});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, percentage, percentage],
          colors: [
            getBatteryColor(),
            getBatteryColor(),
            Colors.grey.withOpacity(.25)
          ],
        ).createShader(rect);
      },
      child: SizedBox(
        height: size,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon,
              size: size, color: Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }

  Color getBatteryColor() {
    if (percentage > 0.2) {
      return Colors.green;
    } else if (percentage > 0.1) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
