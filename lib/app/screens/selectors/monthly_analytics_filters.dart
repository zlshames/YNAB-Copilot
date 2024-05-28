import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ynab_copilot/utils/date_utils.dart';
import 'package:ynab_copilot/utils/ui_utils.dart';

class MonthlyFilters {
  final DateTime? forMonth;
  final bool? showTrendLine;

  MonthlyFilters({this.forMonth, this.showTrendLine});
}

class MonthlyAnalyticsFilters extends HookConsumerWidget {
  late final DateTime initialMonthSelection;
  late final bool initialShowTrendLine;

  MonthlyAnalyticsFilters({
    DateTime? initialMonthSelection,
    bool? initialShowTrendLine,
  }) {
    this.initialMonthSelection = initialMonthSelection ?? DateTime(DateTime.now().year, DateTime.now().month);
    this.initialShowTrendLine = initialShowTrendLine ?? false;
  }

  final dateFilterOpts = getMonthsSince(DateTime.now(), maxMonths: 12);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forMonth = useState(initialMonthSelection);
    final showTrendLine = useState(initialShowTrendLine);

    MonthlyFilters buildResult() {
      return MonthlyFilters(forMonth: forMonth.value, showTrendLine: showTrendLine.value);
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text('Done', style: TextStyle(color: CupertinoColors.activeBlue)),
                onPressed: () {
                  Navigator.of(context).pop(buildResult());
                }),
            middle: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  Icon(Icons.tune, size: 24),
                  Gap(5),
                  Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
                ]))),
        child: Padding(
            padding: EdgeInsets.only(top: 90),
            child: Column(
              children: [
                CupertinoFormSection(header: Text('Date Filters'), children: [
                  CupertinoFormRow(
                      prefix: Text('Selected Month'),
                      child: CupertinoButton(
                        child: Text(DateFormat('MMMM yyyy').format(forMonth.value)),
                        onPressed: () => showCupertinoPicker(
                          context,
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            // This sets the initial item.
                            scrollController: FixedExtentScrollController(
                              initialItem: dateFilterOpts.indexWhere((element) => element == forMonth.value),
                            ),
                            // This is called when selected item is changed.
                            onSelectedItemChanged: (int selectedItem) {
                              forMonth.value = dateFilterOpts[selectedItem];
                            },
                            children: List<Widget>.generate(dateFilterOpts.length, (int index) {
                              return Center(child: Text(DateFormat('MMMM yyyy').format(dateFilterOpts[index])));
                            }),
                          ),
                          height: 250,
                        ),
                      ))
                ]),
                CupertinoFormSection(header: Text('Chart Options'), children: [
                  CupertinoFormRow(
                      prefix: Text('Show Trend Line'),
                      child: CupertinoSwitch(
                        value: showTrendLine.value,
                        onChanged: (bool value) {
                          showTrendLine.value = value;
                        },
                      ))
                ])
              ],
            )));
  }
}
