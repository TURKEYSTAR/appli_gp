import 'package:flutter/material.dart';

class TransportWidget extends StatelessWidget {
  final IconData? data;
  final String? label;
  final String? selectedTransportMode;
  final Function(String)? onSelected;

  const TransportWidget({
    Key? key,
    this.data,
    this.label,
    this.selectedTransportMode,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedTransportMode == label;

    return GestureDetector(
      onTap: () {
        if (onSelected != null) {
          onSelected!(label!); // Notifier la sélection
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              data,
              color: isSelected ? Colors.black : Colors.black,
              size: 30,
            ),
            SizedBox(height: 5),
            Text(
              label ?? '',
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
