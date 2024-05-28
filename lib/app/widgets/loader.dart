import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class Loader extends StatelessWidget {
  Loader({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitFoldingCube(color: CupertinoColors.activeBlue, size: 50.0),
          if (text != null) Gap(20),
          if (text != null) Text(text!, style: TextStyle(color: CupertinoColors.activeBlue))
        ]);
  }
}
