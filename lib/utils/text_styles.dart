import 'package:flutter/material.dart';
import 'colors.dart';

TextStyle black16TextFieldStyle() {
  return TextStyle(
    color: black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

TextStyle customButtonTextStyle({Color? color, double? fontSize}) {
  return TextStyle(
    color: color ?? white,
    fontSize: fontSize ?? 16.0,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
  );
}

TextStyle appBarTitleText({Color? color, double? fontSize}) {
  return TextStyle(
    color: color ?? white,
    fontSize: fontSize ?? 16,
    fontWeight: FontWeight.w700,
  );
}

TextStyle customTextFormFieldTextStyle({Color? color}) {
  return TextStyle(
      fontSize: 14,
      color: color ?? black,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400);
}

TextStyle textFieldHintTextStyle({Color? color}) {
  return TextStyle(
    color: color ?? Colors.grey,
    fontSize: 14,
  );
}
