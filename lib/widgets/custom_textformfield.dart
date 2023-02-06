import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../index.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hint;
  final Color? hintColor;
  final Color? textColor;
  final TextEditingController controller;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final bool? showPasswordToggleIcon;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final TextInputFormatter? textInputFormatter;
  final TextCapitalization? textCapitalization;
  final Key? textFieldKey;
  final String? label;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final int? maxLine;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  // final bool? readOnly;

  CustomTextFormField({
    this.hint,
    this.keyboardType,
    this.enabled = true,
    this.showPasswordToggleIcon,
    this.onSubmitted,
    this.textInputAction = TextInputAction.newline,
    this.maxLine,
    this.hintColor,
    this.textColor,
    this.textInputFormatter,
    this.textCapitalization,
    this.textFieldKey,
    this.label,
    this.textStyle,
    this.labelStyle,
    required this.controller,
    this.obscureText = false,
    this.validator,
    // this.readOnly,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool hideText = false;

  @override
  void initState() {
    super.initState();
    hideText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.textStyle ??
          customTextFormFieldTextStyle(
            color: widget.textColor,
          ),
      enabled: widget.enabled,
      cursorColor: cursorColor,
      maxLines: widget.maxLine,
      // expands: widget.maxLines == null ? true : false,
      autofocus: false,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      controller: widget.controller,
      obscureText: hideText,
      validator: widget.validator,
      // readOnly: widget.readOnly ?? false,
      inputFormatters: [
        widget.textInputFormatter ??
            FilteringTextInputFormatter.singleLineFormatter
      ],
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        hintStyle:
            textFieldHintTextStyle(color: widget.hintColor ?? generalHintColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusBorderColor,
            width: 2.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: enableBorderColor, width: 2.0),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: enableBorderColor, width: 2.0),
        ),
        labelText: widget.label,
        labelStyle: widget.labelStyle ?? textFieldHintTextStyle(),
        suffixIcon: widget.showPasswordToggleIcon == true
            ? hideText == true
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_off,
                      color: blueGrey,
                    ),
                    onPressed: () {
                      setState(() => hideText = !hideText);
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.visibility,
                      color: iconFillColor,
                    ),
                    onPressed: () {
                      setState(() => hideText = !hideText);
                    },
                  )
            : null,
      ),
    );
  }
}
