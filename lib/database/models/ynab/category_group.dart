import 'package:objectbox/objectbox.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';

@Entity()
class YnabCategoryGroup {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  String name;
  bool hidden;
  bool deleted;

  @Backlink('categoryGroup')
  final categories = ToMany<YnabCategory>();

  @Transient()
  List<YnabCategory> transientCategories = [];

  YnabCategoryGroup({
    required this.id,
    required this.name,
    required this.hidden,
    required this.deleted,
    this.transientCategories = const [],
  });

  void linkTransientCategories() {
    categories.clear();
    categories.addAll(transientCategories);
  }

  factory YnabCategoryGroup.fromJson(dynamic json) {
    return YnabCategoryGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      hidden: json['hidden'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      transientCategories:
          (json['categories'] as List<dynamic>? ?? []).map((category) => YnabCategory.fromJson(category)).toList(),
    );
  }
}
