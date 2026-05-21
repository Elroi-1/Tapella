// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listingReviews)
const listingReviewsProvider = ListingReviewsFamily._();

final class ListingReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewModel>>,
          List<ReviewModel>,
          FutureOr<List<ReviewModel>>
        >
    with
        $FutureModifier<List<ReviewModel>>,
        $FutureProvider<List<ReviewModel>> {
  const ListingReviewsProvider._({
    required ListingReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listingReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listingReviewsHash();

  @override
  String toString() {
    return r'listingReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ReviewModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewModel>> create(Ref ref) {
    final argument = this.argument as String;
    return listingReviews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ListingReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listingReviewsHash() => r'c86e4a7c43c5c6bbd699b749c54483f1d990f977';

final class ListingReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewModel>>, String> {
  const ListingReviewsFamily._()
    : super(
        retry: null,
        name: r'listingReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListingReviewsProvider call(String listingId) =>
      ListingReviewsProvider._(argument: listingId, from: this);

  @override
  String toString() => r'listingReviewsProvider';
}

@ProviderFor(submitReview)
const submitReviewProvider = SubmitReviewProvider._();

final class SubmitReviewProvider
    extends
        $FunctionalProvider<
          SubmitReviewActions,
          SubmitReviewActions,
          SubmitReviewActions
        >
    with $Provider<SubmitReviewActions> {
  const SubmitReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitReviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitReviewHash();

  @$internal
  @override
  $ProviderElement<SubmitReviewActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitReviewActions create(Ref ref) {
    return submitReview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitReviewActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitReviewActions>(value),
    );
  }
}

String _$submitReviewHash() => r'9430e17b6bc4422c9587d59a3743fe6c536906b9';
