import 'package:flutter/material.dart';

class ChartColorsLegend extends StatelessWidget {
  const ChartColorsLegend({super.key, required this.length, required this.indexSelected, required this.listColor, required this.onSelect});

  final int length;
  final int? indexSelected;
  final Color Function(int) listColor;
  final void Function(int?) onSelect;

  @override
  Widget build(BuildContext context) {
    legendListLabel(int i, int length) {
      final negativeIndex = length-1 - i;
      switch (negativeIndex) {
        case 0: return "Current cycle";
        case 1: return "Last cycle";
        case 2: return "2nd last cycle";
        case 3: return "3rd last cycle";
        default: return "${negativeIndex}th last cycle";
      }
    }

    return Wrap(
      spacing: 3,
      direction: Axis.vertical,
      children: [
        for (var i = 0; i < length; i++) InkWell(
          onTap: () => onSelect(indexSelected == i ? null : i),
          borderRadius: BorderRadius.circular((25+10)/2),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listColor(i),
                  ),
                  child: (indexSelected == i ? const Icon(Icons.clear, color: Colors.white, size: 15) : null),
                ),
                const SizedBox(width: 5),
                Text(
                  legendListLabel(i, length),
                  //style: TextStyle(decoration: indexSelected == i ? TextDecoration.underline : TextDecoration.none),
                  style: TextStyle(fontWeight: indexSelected == i ? FontWeight.w600 : FontWeight.normal),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ].reversed.toList(),
    );
  }
}