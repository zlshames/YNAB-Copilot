// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ynab_pods.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ynabBudgetsHash() => r'0c093e71b4a67f6c1d7529dc65569383738e5723';

/// See also [ynabBudgets].
@ProviderFor(ynabBudgets)
final ynabBudgetsProvider =
    AutoDisposeFutureProvider<List<YnabBudget>>.internal(
  ynabBudgets,
  name: r'ynabBudgetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ynabBudgetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef YnabBudgetsRef = AutoDisposeFutureProviderRef<List<YnabBudget>>;
String _$monthlyTransactionVolumeHash() =>
    r'e9d50bed0725b10a2bd96bdb0c49ace971ff1115';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [monthlyTransactionVolume].
@ProviderFor(monthlyTransactionVolume)
const monthlyTransactionVolumeProvider = MonthlyTransactionVolumeFamily();

/// See also [monthlyTransactionVolume].
class MonthlyTransactionVolumeFamily
    extends Family<AsyncValue<List<VerticalBarChartData>>> {
  /// See also [monthlyTransactionVolume].
  const MonthlyTransactionVolumeFamily();

  /// See also [monthlyTransactionVolume].
  MonthlyTransactionVolumeProvider call(
    List<YnabTransaction> transactions,
    DateTime month,
  ) {
    return MonthlyTransactionVolumeProvider(
      transactions,
      month,
    );
  }

  @override
  MonthlyTransactionVolumeProvider getProviderOverride(
    covariant MonthlyTransactionVolumeProvider provider,
  ) {
    return call(
      provider.transactions,
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyTransactionVolumeProvider';
}

/// See also [monthlyTransactionVolume].
class MonthlyTransactionVolumeProvider
    extends AutoDisposeFutureProvider<List<VerticalBarChartData>> {
  /// See also [monthlyTransactionVolume].
  MonthlyTransactionVolumeProvider(
    List<YnabTransaction> transactions,
    DateTime month,
  ) : this._internal(
          (ref) => monthlyTransactionVolume(
            ref as MonthlyTransactionVolumeRef,
            transactions,
            month,
          ),
          from: monthlyTransactionVolumeProvider,
          name: r'monthlyTransactionVolumeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyTransactionVolumeHash,
          dependencies: MonthlyTransactionVolumeFamily._dependencies,
          allTransitiveDependencies:
              MonthlyTransactionVolumeFamily._allTransitiveDependencies,
          transactions: transactions,
          month: month,
        );

  MonthlyTransactionVolumeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transactions,
    required this.month,
  }) : super.internal();

  final List<YnabTransaction> transactions;
  final DateTime month;

  @override
  Override overrideWith(
    FutureOr<List<VerticalBarChartData>> Function(
            MonthlyTransactionVolumeRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyTransactionVolumeProvider._internal(
        (ref) => create(ref as MonthlyTransactionVolumeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transactions: transactions,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VerticalBarChartData>> createElement() {
    return _MonthlyTransactionVolumeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTransactionVolumeProvider &&
        other.transactions == transactions &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transactions.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MonthlyTransactionVolumeRef
    on AutoDisposeFutureProviderRef<List<VerticalBarChartData>> {
  /// The parameter `transactions` of this provider.
  List<YnabTransaction> get transactions;

  /// The parameter `month` of this provider.
  DateTime get month;
}

class _MonthlyTransactionVolumeProviderElement
    extends AutoDisposeFutureProviderElement<List<VerticalBarChartData>>
    with MonthlyTransactionVolumeRef {
  _MonthlyTransactionVolumeProviderElement(super.provider);

  @override
  List<YnabTransaction> get transactions =>
      (origin as MonthlyTransactionVolumeProvider).transactions;
  @override
  DateTime get month => (origin as MonthlyTransactionVolumeProvider).month;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
