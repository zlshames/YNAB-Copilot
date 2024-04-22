import 'package:flutter/cupertino.dart';
import 'package:ynab_copilot/api/ynab/ynab_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen() : super();

  Future<void> authenticate(BuildContext context) async {
    print("1");
    YnabApi api = YnabApi(clientId: "iajhbugwTazMBrH4xN8Uw11cm-hoAHgsqAwPl-rWNl4", callbackUrlScheme: "ynab-copilot");
    api.accessToken = "xxx";
    print("2");
    api.onNeedsReauthorization = () async {
      print("3");
      await onNeedsReauthorization(
          context: context,
          onYes: () async {
            await api.startOauth();
          },
          onNo: () {
            print("User declined reauthorization");
          });
    };

    final user = await api.getUserInfo();
    print(user);
  }

  Future<void> onNeedsReauthorization({required BuildContext context, Function()? onYes, Function()? onNo}) async {
    return await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Please Reauthorize'),
        content: const Text('It looks like you have been logged out. Please reauthorize.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: () {
              Navigator.of(context).pop();
              if (onNo != null) {
                onNo();
              }
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              if (onYes != null) {
                onYes();
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      key: const ValueKey("login_screen"),
      child: Center(
        child: CupertinoButton.filled(
            onPressed: () {
              authenticate(context);
            },
            child: const Text("Login")),
      ),
    );
  }
}
