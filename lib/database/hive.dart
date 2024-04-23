import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  Completer<void> waitForInit = Completer<void>();

  late Box<dynamic> auth;

  Future<void> init() async {
    await Hive.initFlutter();
    auth = await Hive.openBox('auth');
    waitForInit.complete();
  }

  Future<void> saveAuth(String accessToken, DateTime accessTokenExpiration) async {
    await auth.put('accessToken', accessToken);
    await auth.put('accessTokenExpiration', accessTokenExpiration);
  }
}
