import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GenericRowRadio<T> extends StatelessWidget {
  final List<T> options;
  final T selectedOption;
  final void Function(T) onChanged;
  final String Function(T) displayText;

  const GenericRowRadio({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        return Row(
          children: [
            Radio<T>(
              value: option,
              groupValue: selectedOption,
              onChanged: (T? value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
            AutoSizeText(displayText(option)),
          ],
        );
      }).toList(),
    );
  }
}
