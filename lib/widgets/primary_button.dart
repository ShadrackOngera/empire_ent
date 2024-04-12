import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  const PrimaryButton({
    super.key,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
