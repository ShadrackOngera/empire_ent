import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String label;
  final bool obsecureText;

  const PrimaryTextField({
    super.key,
    required this.controller,
    this.hintText,
    required this.obsecureText,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
