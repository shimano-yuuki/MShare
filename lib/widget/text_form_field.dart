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
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        // 複数行のテキスト入力
        keyboardType: TextInputType.multiline,
        // 最大3行
        maxLines: widget.maxLines,
        onChanged: widget.onChanged);
  }
}
