import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/app/screens/budget_selector_screen.dart';
import 'package:ynab_copilot/app/widgets/loader.dart';
import 'package:ynab_copilot/database/models/app_settings.dart';
import 'package:ynab_copilot/globals.dart';
import 'package:ynab_copilot/objectbox.g.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Completer<void> waitForAuth = Completer<void>();

  String? userId;

  @override
  void initState() {
    super.initState();
    loadAuth();
  }

  Future<void> loadAuth() async {
    final token = database.getAppSetting('accessToken') as String?;
    final expiration = database.getAppSetting('accessTokenExpiration') as String?;

    if (token == null || expiration == null) {
      return waitForAuth.complete();
    }

    ynab.setAuth(token, DateTime.fromMicrosecondsSinceEpoch(int.parse(expiration)));

    try {
      if (!ynab.authIsExpired) {
        userId = await ynab.getUserId();
      }
    } catch (e) {
      // If it fails, don't do anything
    }

    // If the user info is not null, navigate to the budget selector screen
    if (userId != null) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute<void>(builder: (context) => BudgetSelectorScreen()));
    }

    waitForAuth.complete();
  }

  Future<void> showFailure() async {
    return await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Failed to Authenticate'),
        content: const Text('We were unable to authenticate you. Please try again.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> authenticate() async {
    await ynab.startOauth();

    // Store the app settings
    if (!ynab.useDemoData) {
      final accessToken = AppSettings(name: 'accessToken', value: ynab.accessToken!);
      final accessTokenExpiration =
          AppSettings(name: 'accessTokenExpiration', value: ynab.accessTokenExpiration!.millisecondsSinceEpoch);
      database.appSettings.putMany([accessToken, accessTokenExpiration], mode: PutMode.put);
    }

    userId = await ynab.getUserId();

    // If the user info is not null, navigate to the budget selector screen
    if (userId != null) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute<void>(builder: (context) => BudgetSelectorScreen()));
      return;
    }

    showFailure();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitForAuth.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && userId == null) {
            // Return a "Continue with YNAB" button with a leading YNAB logo
            return CupertinoPageScaffold(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/ynab_logo.png', width: 100, height: 100),
                    const Gap(20),
                    CupertinoButton.filled(
                      onPressed: () {
                        authenticate();
                      },
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(CupertinoIcons.lock, color: CupertinoColors.white),
                        Gap(10),
                        const Text('Login with YNAB', style: TextStyle(color: CupertinoColors.white))
                      ]),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loader();
          }
        });
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen() : super();

//   @override
//   initState() {
//     super.initState();
//   }

//   Future<void> authenticate(BuildContext context) async {
//     await api.startOauth();
//     api.onNeedsReauthorization = () async {
//       final bool? returnVal = await onNeedsReauthorization(context: context);
//       if (returnVal == true) {
//         await api.startOauth();
//         return true;
//       } else {}

//       return false;
//     };

//     final user = await api.getUserInfo();
//   }

//   Future<bool?> onNeedsReauthorization({required BuildContext context}) async {
//     return await showCupertinoModalPopup<bool>(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: const Text('Please Reauthorize'),
//         content: const Text('It looks like you have been logged out. Please reauthorize.'),
//         actions: <CupertinoDialogAction>[
//           CupertinoDialogAction(
//             isDefaultAction: false,
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text('No'),
//           ),
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       key: const ValueKey("login_screen"),
//       child: Center(
//         child: CupertinoButton.filled(
//             onPressed: () {
//               authenticate(context);
//             },
//             child: const Text("Login")),
//       ),
//     );
//   }
// }
