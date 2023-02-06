import 'package:flutter/material.dart';
import 'index.dart';

const String homeScreen = '/home';
const String loginScreen = '/login';
const String otpScreen = '/Otp';
const String profileScreen = '/profileScreen';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otpScreen:
        return MaterialPageRoute(
            builder: (_) =>
                OtpScreen(arguments: settings.arguments as OtpScreenArguments));
      case profileScreen:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
