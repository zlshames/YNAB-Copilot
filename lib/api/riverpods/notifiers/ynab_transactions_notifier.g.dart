// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ynab_transactions_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ynabTransactionsControllerHash() =>
    r'7a1d278435a12c5ac3338d55cda1ddc6ede5b244';

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

abstract class _$YnabTransactionsController
    extends BuildlessAutoDisposeNotifier<YnabTransactionsState> {
  late final String budgetId;

  YnabTransactionsState build({
    required String budgetId,
  });
}

/// See also [YnabTransactionsController].
@ProviderFor(YnabTransactionsController)
const ynabTransactionsControllerProvider = YnabTransactionsControllerFamily();

/// See also [YnabTransactionsController].
class YnabTransactionsControllerFamily extends Family<YnabTransactionsState> {
  /// See also [YnabTransactionsController].
  const YnabTransactionsControllerFamily();

  /// See also [YnabTransactionsController].
  YnabTransactionsControllerProvider call({
    required String budgetId,
  }) {
    return YnabTransactionsControllerProvider(
      budgetId: budgetId,
    );
  }

  @override
  YnabTransactionsControllerProvider getProviderOverride(
    covariant YnabTransactionsControllerProvider provider,
  ) {
    return call(
      budgetId: provider.budgetId,
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
  String? get name => r'ynabTransactionsControllerProvider';
}

/// See also [YnabTransactionsController].
class YnabTransactionsControllerProvider
    extends AutoDisposeNotifierProviderImpl<YnabTransactionsController,
        YnabTransactionsState> {
  /// See also [YnabTransactionsController].
  YnabTransactionsControllerProvider({
    required String budgetId,
  }) : this._internal(
          () => YnabTransactionsController()..budgetId = budgetId,
          from: ynabTransactionsControllerProvider,
          name: r'ynabTransactionsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ynabTransactionsControllerHash,
          dependencies: YnabTransactionsControllerFamily._dependencies,
          allTransitiveDependencies:
              YnabTransactionsControllerFamily._allTransitiveDependencies,
          budgetId: budgetId,
        );

  YnabTransactionsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.budgetId,
  }) : super.internal();

  final String budgetId;

  @override
  YnabTransactionsState runNotifierBuild(
    covariant YnabTransactionsController notifier,
  ) {
    return notifier.build(
      budgetId: budgetId,
    );
  }

  @override
  Override overrideWith(YnabTransactionsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: YnabTransactionsControllerProvider._internal(
        () => create()..budgetId = budgetId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        budgetId: budgetId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<YnabTransactionsController,
      YnabTransactionsState> createElement() {
    return _YnabTransactionsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YnabTransactionsControllerProvider &&
        other.budgetId == budgetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, budgetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin YnabTransactionsControllerRef
    on AutoDisposeNotifierProviderRef<YnabTransactionsState> {
  /// The parameter `budgetId` of this provider.
  String get budgetId;
}

class _YnabTransactionsControllerProviderElement
    extends AutoDisposeNotifierProviderElement<YnabTransactionsController,
        YnabTransactionsState> with YnabTransactionsControllerRef {
  _YnabTransactionsControllerProviderElement(super.provider);

  @override
  String get budgetId =>
      (origin as YnabTransactionsControllerProvider).budgetId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
