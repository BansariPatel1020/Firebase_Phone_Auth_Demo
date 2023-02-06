import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'index.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final botToastBuilder = BotToastInit();
    return MaterialApp(
      title: 'Firebase Phone Auth',
      navigatorKey: navigatorKey,
      builder: (context, child) {
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child ?? Container(),
        );
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      home: CupertinoTheme(
        data: MaterialBasedCupertinoThemeData(
          materialTheme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins',
          ),
        ),
        child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return const SplashScreen();
            }
          },
          future: getDefaultWidget(),
        ),
      ),
      onGenerateRoute: Routes.generateRoute,
      routes: <String, WidgetBuilder>{
        homeScreen: (BuildContext context) => const LoginScreen(),
      },
    );
  }

  Future<Widget> getDefaultWidget() async {
    Widget defaultWidget = const LoginScreen();
    var isLoggedIn = await HelperFunctions.getUserLoggedInSharedPreference();
    if (isLoggedIn) {
      defaultWidget = ProfilePage();
    } else {
      defaultWidget = const LoginScreen();
    }
    return defaultWidget;
  }
}
