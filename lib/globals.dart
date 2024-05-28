import 'package:ynab_copilot/api/ynab/ynab_api.dart';
import 'package:ynab_copilot/database/provider.dart';

late ObjectBox database;

YnabApi ynab = YnabApi(
    clientId: "iajhbugwTazMBrH4xN8Uw11cm-hoAHgsqAwPl-rWNl4", callbackUrlScheme: "ynab-copilot", useDemoData: false);
