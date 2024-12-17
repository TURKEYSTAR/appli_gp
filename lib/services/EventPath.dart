import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPath extends StatelessWidget {
  final bool isPast;
  final childWidget;

  const EventPath({
    Key? key,
    required this.isPast,
    required this.childWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPast ? Colors.indigo.shade400 : Colors.indigo.shade100, // Darker blue for past, lighter blue for future
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(25.0),
      margin: EdgeInsets.all(20.0),
      child: childWidget,
    );
  }
}
