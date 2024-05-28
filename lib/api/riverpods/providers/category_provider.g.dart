// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryHash() => r'0beaac4df9997fed33236894b5809f963ee7904b';

/// See also [category].
@ProviderFor(category)
final categoryProvider =
    AutoDisposeStreamProvider<List<YnabCategoryGroup>>.internal(
  category,
  name: r'categoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CategoryRef = AutoDisposeStreamProviderRef<List<YnabCategoryGroup>>;
String _$ynabCategorySyncControllerHash() =>
    r'60ebb30903176511e3fb067b7f0ecbfa642908c4';

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

abstract class _$YnabCategorySyncController
    extends BuildlessAutoDisposeNotifier<YnabCategorySyncState> {
  late final String budgetId;

  YnabCategorySyncState build({
    required String budgetId,
  });
}

/// See also [YnabCategorySyncController].
@ProviderFor(YnabCategorySyncController)
const ynabCategorySyncControllerProvider = YnabCategorySyncControllerFamily();

/// See also [YnabCategorySyncController].
class YnabCategorySyncControllerFamily extends Family<YnabCategorySyncState> {
  /// See also [YnabCategorySyncController].
  const YnabCategorySyncControllerFamily();

  /// See also [YnabCategorySyncController].
  YnabCategorySyncControllerProvider call({
    required String budgetId,
  }) {
    return YnabCategorySyncControllerProvider(
      budgetId: budgetId,
    );
  }

  @override
  YnabCategorySyncControllerProvider getProviderOverride(
    covariant YnabCategorySyncControllerProvider provider,
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
  String? get name => r'ynabCategorySyncControllerProvider';
}

/// See also [YnabCategorySyncController].
class YnabCategorySyncControllerProvider
    extends AutoDisposeNotifierProviderImpl<YnabCategorySyncController,
        YnabCategorySyncState> {
  /// See also [YnabCategorySyncController].
  YnabCategorySyncControllerProvider({
    required String budgetId,
  }) : this._internal(
          () => YnabCategorySyncController()..budgetId = budgetId,
          from: ynabCategorySyncControllerProvider,
          name: r'ynabCategorySyncControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ynabCategorySyncControllerHash,
          dependencies: YnabCategorySyncControllerFamily._dependencies,
          allTransitiveDependencies:
              YnabCategorySyncControllerFamily._allTransitiveDependencies,
          budgetId: budgetId,
        );

  YnabCategorySyncControllerProvider._internal(
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
  YnabCategorySyncState runNotifierBuild(
    covariant YnabCategorySyncController notifier,
  ) {
    return notifier.build(
      budgetId: budgetId,
    );
  }

  @override
  Override overrideWith(YnabCategorySyncController Function() create) {
    return ProviderOverride(
      origin: this,
      override: YnabCategorySyncControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<YnabCategorySyncController,
      YnabCategorySyncState> createElement() {
    return _YnabCategorySyncControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YnabCategorySyncControllerProvider &&
        other.budgetId == budgetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, budgetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin YnabCategorySyncControllerRef
    on AutoDisposeNotifierProviderRef<YnabCategorySyncState> {
  /// The parameter `budgetId` of this provider.
  String get budgetId;
}

class _YnabCategorySyncControllerProviderElement
    extends AutoDisposeNotifierProviderElement<YnabCategorySyncController,
        YnabCategorySyncState> with YnabCategorySyncControllerRef {
  _YnabCategorySyncControllerProviderElement(super.provider);

  @override
  String get budgetId =>
      (origin as YnabCategorySyncControllerProvider).budgetId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
