import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:ynab_copilot/database/models/app_settings.dart';
import 'package:ynab_copilot/database/models/ynab/budget.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';
import 'package:ynab_copilot/database/models/ynab/subtransaction.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  Box<AppSettings> get appSettings => store.box<AppSettings>();

  Box<YnabBudget> get budgets => store.box<YnabBudget>();

  Box<YnabCategory> get categories => store.box<YnabCategory>();

  Box<YnabCategoryGroup> get categoryGroups => store.box<YnabCategoryGroup>();

  Box<YnabSubtransaction> get subtransactions => store.box<YnabSubtransaction>();

  Box<YnabTransaction> get transactions => store.box<YnabTransaction>();

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, "database");

    final store = await openStore(directory: dbPath);
    return ObjectBox._create(store);
  }

  dynamic getAppSetting(String key) {
    final setting = appSettings.query(AppSettings_.name.equals(key)).build().findFirst();
    return setting?.value;
  }
}
