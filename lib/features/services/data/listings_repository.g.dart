// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listingsRepository)
const listingsRepositoryProvider = ListingsRepositoryProvider._();

final class ListingsRepositoryProvider
    extends
        $FunctionalProvider<
          ListingsRepository,
          ListingsRepository,
          ListingsRepository
        >
    with $Provider<ListingsRepository> {
  const ListingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ListingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ListingsRepository create(Ref ref) {
    return listingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListingsRepository>(value),
    );
  }
}

String _$listingsRepositoryHash() =>
    r'7152cc3e130acfdf02ed474ec653a6bdcf3ccdef';
