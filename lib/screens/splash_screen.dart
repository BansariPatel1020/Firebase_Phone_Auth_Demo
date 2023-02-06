import 'dart:async';
import 'package:flutter/material.dart';
import '../index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // startTime();
  }

  Future<Timer> startTime() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImagePath.logo, fit: BoxFit.fitWidth),
      ),
    );
  }
}
