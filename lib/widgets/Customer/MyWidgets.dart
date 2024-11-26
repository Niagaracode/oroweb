
import 'package:flutter/material.dart';

Widget csText({ required String text, TextStyle? style, TextAlign? textAlign, TextOverflow? overflow, int? maxLines,})
{
  return Text(
    text,
    style: style ?? const TextStyle(color: Colors.black),
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
  );
}