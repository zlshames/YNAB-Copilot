import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ynab_copilot/app/screens/login_screen.dart';
import 'package:ynab_copilot/database/provider.dart';
import 'package:ynab_copilot/globals.dart' as globals;

final navigatorKey = GlobalKey<NavigatorState>();
late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  // Create the box, and store it in a global variable
  globals.database = await ObjectBox.create();

  // Run the app
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CupertinoTheme.of(context).barBackgroundColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return CupertinoApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: const CupertinoThemeData(),
        // This initialization should be nearly instant, but we still want to show a loader
        home: const LoginScreen());
  }
}
