import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../services/EventPath.dart';

class TimeLineTileUI extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventChild;

  const TimeLineTileUI({
    Key? key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.green : Color(0xFF9FA8FF), // Muted complement for past/future
        ),
        indicatorStyle: IndicatorStyle(
          width: 40.0,
          color: isPast ? Colors.lightGreen : Color(0xFF9FA8FF), // Green for completed, blue tint for upcoming
          iconStyle: IconStyle(
            iconData: Icons.check_circle,
            color: isPast ? Colors.white : Colors.green, // White for clarity on green
          ),
        ),
        endChild: Container(
          child: EventPath(
            isPast: isPast,
            childWidget: eventChild,
          ),
        ),
      ),
    );
  }
}
