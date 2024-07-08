import 'package:flutter/material.dart';
import 'package:opdsure/custom_ui/app_border_box.dart';

class AppDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final Widget? hint;
  const AppDropDown({required this.hint, required this.items, required this.onChanged, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBorderBox(
      myChild: DropdownButton(
        hint: hint,
        value: value,
        elevation: 6,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items,
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }
}
