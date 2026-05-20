// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_invalidator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cacheInvalidator)
const cacheInvalidatorProvider = CacheInvalidatorProvider._();

final class CacheInvalidatorProvider
    extends
        $FunctionalProvider<
          CacheInvalidator,
          CacheInvalidator,
          CacheInvalidator
        >
    with $Provider<CacheInvalidator> {
  const CacheInvalidatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheInvalidatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheInvalidatorHash();

  @$internal
  @override
  $ProviderElement<CacheInvalidator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheInvalidator create(Ref ref) {
    return cacheInvalidator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheInvalidator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheInvalidator>(value),
    );
  }
}

String _$cacheInvalidatorHash() => r'725111a853e3ae855c1cae6f804097c746072bc9';
