import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart' show StyleColors;

class FilterColorText extends StatelessWidget {
  const FilterColorText(
      {super.key,
      required this.color,
      required this.value,
      this.isSelected = false});
  final Color? color;
  final String? value;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: StyleColors.boarderColor,
          radius: 12,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: CircleAvatar(
              backgroundColor: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value ?? 'Black',
            style: TextStyle(
                color: StyleColors.lukhuDark1,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
        if (isSelected)
          Icon(
            Icons.check,
            color: getFontColorForBackground(color!),
            size: 20,
          ),
      ],
    );
  }

  Color getFontColorForBackground(Color background) {
    return (background.computeLuminance() > 0.179)
        ? Colors.black
        : Colors.white;
  }
}
