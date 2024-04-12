import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final bool whiteOnLightTheme;
  final bool customBlueColor;
  final double fontSize;
  final int maxLines;
  final int minLines;
  final TextOverflow overflow;
  final Color color;
  final TextAlign textAlign;

  const PrimaryText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 14,
    this.whiteOnLightTheme = false,
    this.customBlueColor = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.overflow = TextOverflow.ellipsis,
    required this.color,
    this.textAlign = TextAlign.justify,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: whiteOnLightTheme ? Colors.white : color,
      ),
    );
  }
}
