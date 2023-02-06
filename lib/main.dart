import 'package:flutter/material.dart';
import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppManager.instance.initSharedPreference();

  await Firebase.initializeApp();
  runApp(MyApp());
}
