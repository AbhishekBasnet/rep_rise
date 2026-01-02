import 'package:flutter/cupertino.dart';

class ProfileWheelPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final Function(int) onChanged;

  const ProfileWheelPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final initialIndex = initialValue - minValue;
    return ListWheelScrollView.useDelegate(
      controller: FixedExtentScrollController(initialItem: initialIndex),
      itemExtent: 60,
      onSelectedItemChanged: (index) {
        final actualNumber = minValue + index;
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: maxValue - minValue + 1,
        builder: (context, index ) => Text("${minValue + index}"),
      ),
    );
  }
}
