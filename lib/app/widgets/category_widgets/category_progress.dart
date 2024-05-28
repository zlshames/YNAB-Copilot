import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';

class CategoryProgress extends StatelessWidget {
  CategoryProgress({required this.category, this.animationDuration = const Duration(seconds: 1)});

  final YnabCategory category;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TweenAnimationBuilder<double>(
      duration: animationDuration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ),
      builder: (context, value, _) => LinearProgressIndicator(
          borderRadius: BorderRadius.circular(5),
          minHeight: 5,
          backgroundColor: CupertinoColors.secondarySystemBackground,
          value: category.completion.percentage,
          valueColor: AlwaysStoppedAnimation<Color>(category.completion.color)),
    ));
  }
}
