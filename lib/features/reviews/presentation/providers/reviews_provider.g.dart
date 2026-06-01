// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getReviewsByListingUseCase)
const getReviewsByListingUseCaseProvider =
    GetReviewsByListingUseCaseProvider._();

final class GetReviewsByListingUseCaseProvider
    extends
        $FunctionalProvider<
          GetReviewsByListingUseCase,
          GetReviewsByListingUseCase,
          GetReviewsByListingUseCase
        >
    with $Provider<GetReviewsByListingUseCase> {
  const GetReviewsByListingUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getReviewsByListingUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getReviewsByListingUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetReviewsByListingUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetReviewsByListingUseCase create(Ref ref) {
    return getReviewsByListingUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetReviewsByListingUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetReviewsByListingUseCase>(value),
    );
  }
}

String _$getReviewsByListingUseCaseHash() =>
    r'666e0bdadbdbbfba90f2eb17987965b18a4600de';

@ProviderFor(submitReviewUseCase)
const submitReviewUseCaseProvider = SubmitReviewUseCaseProvider._();

final class SubmitReviewUseCaseProvider
    extends
        $FunctionalProvider<
          SubmitReviewUseCase,
          SubmitReviewUseCase,
          SubmitReviewUseCase
        >
    with $Provider<SubmitReviewUseCase> {
  const SubmitReviewUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitReviewUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitReviewUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitReviewUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitReviewUseCase create(Ref ref) {
    return submitReviewUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitReviewUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitReviewUseCase>(value),
    );
  }
}

String _$submitReviewUseCaseHash() =>
    r'a5a635a4778b5e98fbf732ccff3a7876d2da6f76';

@ProviderFor(listingReviews)
const listingReviewsProvider = ListingReviewsFamily._();

final class ListingReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReviewEntity>>,
          List<ReviewEntity>,
          FutureOr<List<ReviewEntity>>
        >
    with
        $FutureModifier<List<ReviewEntity>>,
        $FutureProvider<List<ReviewEntity>> {
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
  $FutureProviderElement<List<ReviewEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ReviewEntity>> create(Ref ref) {
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

String _$listingReviewsHash() => r'0d1a9b012eb8eda3c9b64dea82a3e26e1790ed43';

final class ListingReviewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ReviewEntity>>, String> {
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
