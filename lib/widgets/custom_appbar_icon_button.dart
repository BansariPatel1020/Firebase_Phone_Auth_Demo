import 'package:flutter/material.dart';
import '../index.dart';

class CustomAppBarIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomAppBarIconButton({
    super.key,
    this.icon = Icons.exit_to_app,
    required this.onPressed,
  });

  @override
  _CustomAppBarIconButtonState createState() => _CustomAppBarIconButtonState();
}

class _CustomAppBarIconButtonState extends State<CustomAppBarIconButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appBarIconButtonSize,
      child: IconButton(
        icon: Icon(widget.icon),
        color: white,
        onPressed: widget.onPressed,
        iconSize: 25,
      ),
    );
  }
}
