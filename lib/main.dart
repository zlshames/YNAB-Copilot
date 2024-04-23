import 'package:flutter/cupertino.dart';
import 'package:ynab_copilot/app/screens/login_screen.dart';
import 'package:ynab_copilot/app/widgets/widgets.dart';
import 'package:ynab_copilot/globals.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  database.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        navigatorKey: navigatorKey,
        theme: const CupertinoThemeData(),
        // This initialization should be nearly instant, but we still want to show a loader
        home: FutureBuilder<void>(
          future: database.waitForInit.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const LoginScreen();
            } else {
              return genericLoader;
            }
          },
        ));
  }
}
