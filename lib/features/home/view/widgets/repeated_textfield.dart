import 'package:flutter/material.dart';

class kRepeatedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;

  final int? maxLines;
  const kRepeatedTextField({
    super.key,
    this.controller,
    this.validator,
    this.maxLines,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
