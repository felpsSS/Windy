import 'package:flutter/material.dart';

// Thanks, https://stackoverflow.com/questions/70146159/dynamic-filled-star-in-flutter

class RatingIcon extends StatelessWidget {
      final IconData icon;
      final double size;
      final Color iconColor;
      final double percentage;
    
      const RatingIcon({
        super.key,
        required this.icon,
        required this.size,
        required this.iconColor,
        required this.percentage
      });
    
      @override
      Widget build(BuildContext context) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect rect) {
            return LinearGradient(
              stops: [0, percentage, percentage],
              colors: [iconColor, iconColor, Colors.grey.withOpacity(.25)],
            ).createShader(rect);
          },
          child: SizedBox(
            width: size *5,
            height: size,
            child: Row(
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: Icon(icon, size: size, color: Theme.of(context).colorScheme.surface),
                ),
                SizedBox(
                  width: size,
                  height: size,
                  child: Icon(icon, size: size, color: Theme.of(context).colorScheme.surface),
                ),
                SizedBox(
                  width: size,
                  height: size,
                  child: Icon(icon, size: size, color: Theme.of(context).colorScheme.surface),
                ),
                SizedBox(
                  width: size,
                  height: size,
                  child: Icon(icon, size: size, color: Theme.of(context).colorScheme.surface),
                ),
                SizedBox(
                  width: size,
                  height: size,
                  child: Icon(icon, size: size, color: Theme.of(context).colorScheme.surface),
                ),
              ],
            ),
          ),
        );
      }
    }