import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:objectbox/objectbox.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';
import 'package:ynab_copilot/utils/color_utils.dart';
import 'package:ynab_copilot/utils/ui_utils.dart';

class CategoryCompletion {
  final double percentage;
  final Color color;

  CategoryCompletion(this.percentage, this.color);
}

@Entity()
class YnabCategory {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  final categoryGroup = ToOne<YnabCategoryGroup>();

  String name;
  bool hidden;
  String? originalCategoryGroupId;
  String? note;
  int budgeted;
  int activity;
  int balance;
  String? goalType;
  String? goalDay;
  int? goalCadence;
  int? goalCadenceFrequency;
  String? goalCreationMonth;
  int goalTarget;
  String? goalTargetMonth;
  int? goalPercentageComplete;
  int? goalMonthsToBudget;
  int? goalUnderFunded;
  int? goalOverallFunded;
  int? goalOverallLeft;
  bool deleted;

  @Transient()
  double get budgetedDollars => double.parse((budgeted / 1000).toStringAsFixed(2));

  @Transient()
  double get activityDollars => double.parse((activity / 1000).toStringAsFixed(2));

  @Transient()
  double get balanceDollars => double.parse((balance / 1000).toStringAsFixed(2));

  @Transient()
  CategoryCompletion get completion {
    // First, check the goal percentage
    if (goalPercentageComplete != null) {
      final percentage = goalPercentageComplete! / 100;
      if (percentage < 0.5) {
        return CategoryCompletion(percentage, CupertinoColors.systemRed);
      } else if (percentage < 1) {
        return CategoryCompletion(percentage, CupertinoColors.systemYellow);
      } else {
        return CategoryCompletion(goalPercentageComplete! / 100, CupertinoColors.systemGreen);
      }
    }

    // If there's no goal percentage, check if the goal is funded
    if (goalOverallFunded != null && goalOverallLeft != null) {
      final funded = goalOverallFunded!;
      final left = goalOverallLeft!;
      if (funded < left) {
        return CategoryCompletion(funded / left, CupertinoColors.systemYellow);
      } else {
        return CategoryCompletion(1, CupertinoColors.systemGreen);
      }
    }

    // If there's no goal, return 1 if the balance is negative
    if (balance < 0) {
      return CategoryCompletion(1, CupertinoColors.systemRed);
    }

    // If we have a positive balance, use the activity to determine the completion
    // Value is activity / budgeted
    var activity = this.activity * -1;
    if (activity < 0) {
      activity = 0;
    }

    if (budgeted == 0) {
      return CategoryCompletion(0, CupertinoColors.systemGrey);
    }

    return CategoryCompletion(activity / budgeted, CupertinoColors.systemGreen);
  }

  @Transient()
  String? get nameToEmoji {
    for (var entry in nameToEmojiMap.entries) {
      final opts = name.toLowerCase().split(' ');
      if (opts.contains(entry.key) || opts.contains('${entry.key}s')) {
        return entry.value;
      }
    }

    return null;
  }

  @Transient()
  Color get color {
    return generateColor(id);
  }

  Widget getIcon({double size = 18}) {
    final emoji = nameToEmoji;
    if (emoji != null) {
      return Text(emoji, style: TextStyle(fontSize: size));
    }

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      width: size,
      height: size,
    );
  }

  YnabCategory({
    required this.id,
    required this.name,
    this.hidden = false,
    this.originalCategoryGroupId,
    this.note,
    this.budgeted = 0,
    this.activity = 0,
    this.balance = 0,
    this.goalType,
    this.goalDay,
    this.goalCadence,
    this.goalCadenceFrequency,
    this.goalCreationMonth,
    this.goalTarget = 0,
    this.goalTargetMonth,
    this.goalPercentageComplete,
    this.goalMonthsToBudget,
    this.goalUnderFunded,
    this.goalOverallFunded,
    this.goalOverallLeft,
    this.deleted = false,
  });

  factory YnabCategory.fromJson(dynamic json) {
    return YnabCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      hidden: json['hidden'] as bool? ?? false,
      originalCategoryGroupId: json['original_category_group_id'] as String?,
      note: json['note'] as String?,
      budgeted: json['budgeted'] as int? ?? 0,
      activity: json['activity'] as int? ?? 0,
      balance: json['balance'] as int? ?? 0,
      goalType: json['goal_type'] as String?,
      goalDay: json['goal_day'] as String?,
      goalCadence: json['goal_cadence'] as int?,
      goalCadenceFrequency: json['goal_cadence_frequency'] as int?,
      goalCreationMonth: json['goal_creation_month'] as String?,
      goalTarget: json['goal_target'] as int? ?? 0,
      goalTargetMonth: json['goal_target_month'] as String?,
      goalPercentageComplete: json['goal_percentage_complete'] as int?,
      goalMonthsToBudget: json['goal_months_to_budget'] as int?,
      goalUnderFunded: json['goal_under_funded'] as int?,
      goalOverallFunded: json['goal_overall_funded'] as int?,
      goalOverallLeft: json['goal_overall_left'] as int?,
      deleted: json['deleted'] as bool? ?? false,
    );
  }
}
