import 'package:flutter/material.dart';

bool isEmail(String text) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(text);
}

double getWidthDevice(BuildContext context, int percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeightDevice(BuildContext context, int percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}
