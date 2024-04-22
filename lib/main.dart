import 'package:flutter/cupertino.dart';
import 'package:ynab_copilot/app/screens/login_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      navigatorKey: navigatorKey,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: LoginScreen(),
    );
  }
}
