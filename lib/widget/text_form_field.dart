import 'package:flutter/material.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField(
      {super.key,
      required this.labelText,
      required this.maxLines,
      required this.onChanged});
  final String labelText;
  final int maxLines;
  final void Function(String)? onChanged;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(labelText: widget.labelText),
        // 複数行のテキスト入力
        keyboardType: TextInputType.multiline,
        // 最大3行
        maxLines: widget.maxLines,
        onChanged: widget.onChanged);
  }
}
