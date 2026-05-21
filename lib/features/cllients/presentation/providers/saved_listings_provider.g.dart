// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_listings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SavedListings)
const savedListingsProvider = SavedListingsProvider._();

final class SavedListingsProvider
    extends $NotifierProvider<SavedListings, Set<String>> {
  const SavedListingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedListingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedListingsHash();

  @$internal
  @override
  SavedListings create() => SavedListings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$savedListingsHash() => r'cdd85e0d7c6f57750987c072231d78eb6d5d4a37';

abstract class _$SavedListings extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
