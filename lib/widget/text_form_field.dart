import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.labelText,
      required this.maxLines,
      required this.onChanged});
  final String labelText;
  final int maxLines;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(labelText: labelText),
        // 複数行のテキスト入力
        keyboardType: TextInputType.multiline,
        // 最大3行
        maxLines: maxLines,
        onChanged: onChanged);
  }
}
