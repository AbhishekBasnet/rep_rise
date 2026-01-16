import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/theme/app_theme.dart';

class ProfileWheelPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final int step;
  final String unit;
  final Function(int) onChanged;

  const ProfileWheelPicker({
    super.key,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,

    this.step = 1,
  });

  @override
  State<ProfileWheelPicker> createState() => _ProfileWheelPickerState();
}

class _ProfileWheelPickerState extends State<ProfileWheelPicker> {
  late FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = (widget.initialValue - widget.minValue) ~/ widget.step;

    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 80;
    final int childCount = ((widget.maxValue - widget.minValue) ~/ widget.step) + 1;

    return Stack(
      alignment: AlignmentGeometry.center,

      children: [
        Container(
          height: itemHeight,
          margin: const EdgeInsetsGeometry.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.purple, width: 1.0),
              bottom: BorderSide(color: AppTheme.purple, width: 1.0),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            Text(widget.unit, style: AppTheme.profileSetupWheelUnitSelected),
          ],
        ),
        ListWheelScrollView.useDelegate(
          controller: _controller,
          itemExtent: itemHeight,
          perspective: 0.005,
          diameterRatio: 3,
          magnification: 1.2,
          useMagnifier: true,
          overAndUnderCenterOpacity: 0.8,
          physics: FixedExtentScrollPhysics(),

          onSelectedItemChanged: (index) {
            setState(() {
              _selectedIndex=index;
            });
            final actualNumber = widget.minValue + (index * widget.step);
            widget.onChanged(actualNumber);
          },

          childDelegate: ListWheelChildBuilderDelegate(
            childCount: childCount,
            builder: (context, index) {
              final bool isSelected = index == _selectedIndex;
              return Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: isSelected
                      ? AppTheme.profileSetupWheelNumberSelected
                      : AppTheme.profileSetupWheelNumberUnselected,
                  child: Text(
                    "${widget.minValue + (index * widget.step)}",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
