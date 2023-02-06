import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

class CustomRaisedButton extends StatefulWidget {
  final String? text;
  final Color? buttonColor;
  // final Color? disabledButtonColor;
  // final Color? disabledTextColor;
  final Color? textColor;
  final double? borderRadius;
  // final double? fontSize;
  final VoidCallback? onCustomButtonPressed;
  final double? buttonWidth;

  CustomRaisedButton({
    this.text,
    this.buttonColor,
    // this.disabledButtonColor,
    // this.disabledTextColor,
    this.borderRadius,
    // this.fontSize,
    this.textColor,
    this.onCustomButtonPressed,
    this.buttonWidth,
  });

  @override
  _CustomRaisedButton createState() => _CustomRaisedButton();
}

class _CustomRaisedButton extends State<CustomRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.buttonWidth ?? double.infinity,
      child: ElevatedButton(
        onPressed: widget.onCustomButtonPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 40),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            widget.buttonColor ?? pinkColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.text ?? '',
            style: customButtonTextStyle(color: widget.textColor),
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
        // ),
        // padding: EdgeInsets.all(widget.padding),
      ),
    );
  }
}
