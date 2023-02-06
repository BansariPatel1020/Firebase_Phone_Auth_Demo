import 'dart:async';
import 'package:flutter/material.dart';
import '../index.dart';

//Application level singleton class
class AppManager {
  AppManager._();
  static final AppManager instance = AppManager._();

  static SharedPreferences? sharedPreferences;
  String? firebaseToken;
  BuildContext? globalContext;

  /// Initializes shared preference instance
  Future initSharedPreference() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  final SharedPreferenceRepository sharedPreferenceRepository =
      SharedPreferenceRepository();
  Timer? timer;

  Future logout() async {
    await HelperFunctions.saveUserLoggedInSharedPreference(false);
    await HelperFunctions.saveUserMobileSharedPreference('');
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!, loginScreen, (route) => false);
  }
}
