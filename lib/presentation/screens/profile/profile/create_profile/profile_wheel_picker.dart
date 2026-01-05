import 'package:flutter/cupertino.dart';

class ProfileWheelPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final int step;
  final Function(int) onChanged;

  const ProfileWheelPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    final int childCount = ((maxValue - minValue) ~/ step) + 1;

    final initialIndex = (initialValue - minValue) ~/ step;
    return ListWheelScrollView.useDelegate(
      controller: FixedExtentScrollController(initialItem: initialIndex),
      physics: const FixedExtentScrollPhysics(),
      itemExtent: 60,
      onSelectedItemChanged: (index) {
        final actualNumber = minValue + (index * step);
        onChanged(actualNumber);
      },

      childDelegate: ListWheelChildBuilderDelegate(
        childCount: childCount,
        builder: (context, index) => Text("${minValue + (index * step)}"),
      ),
    );
  }
}
