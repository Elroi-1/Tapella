// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providerStats)
const providerStatsProvider = ProviderStatsProvider._();

final class ProviderStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProviderStats>,
          ProviderStats,
          FutureOr<ProviderStats>
        >
    with $FutureModifier<ProviderStats>, $FutureProvider<ProviderStats> {
  const ProviderStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providerStatsHash();

  @$internal
  @override
  $FutureProviderElement<ProviderStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProviderStats> create(Ref ref) {
    return providerStats(ref);
  }
}

String _$providerStatsHash() => r'b30e1d636d5eb42d93f0ceeba591b586c19b1071';

@ProviderFor(customerBookings)
const customerBookingsProvider = CustomerBookingsProvider._();

final class CustomerBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          List<BookingModel>,
          FutureOr<List<BookingModel>>
        >
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  const CustomerBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerBookingsHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return customerBookings(ref);
  }
}

String _$customerBookingsHash() => r'9a4efd7fa66c522b684d52bc57dbf464520aaa26';

@ProviderFor(customerBookingsStale)
const customerBookingsStaleProvider = CustomerBookingsStaleProvider._();

final class CustomerBookingsStaleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const CustomerBookingsStaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerBookingsStaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerBookingsStaleHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return customerBookingsStale(ref);
  }
}

String _$customerBookingsStaleHash() =>
    r'365b7bf5ecd498273fe986454f2564c549a3f115';

@ProviderFor(incomingBookings)
const incomingBookingsProvider = IncomingBookingsProvider._();

final class IncomingBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          List<BookingModel>,
          FutureOr<List<BookingModel>>
        >
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  const IncomingBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomingBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomingBookingsHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return incomingBookings(ref);
  }
}

String _$incomingBookingsHash() => r'cea3ec265c05c747f944a0c350ed0760bae1fc74';

@ProviderFor(historyBookings)
const historyBookingsProvider = HistoryBookingsProvider._();

final class HistoryBookingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookingModel>>,
          List<BookingModel>,
          FutureOr<List<BookingModel>>
        >
    with
        $FutureModifier<List<BookingModel>>,
        $FutureProvider<List<BookingModel>> {
  const HistoryBookingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyBookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyBookingsHash();

  @$internal
  @override
  $FutureProviderElement<List<BookingModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookingModel>> create(Ref ref) {
    return historyBookings(ref);
  }
}

String _$historyBookingsHash() => r'1c647d24f614835192e3d93db3fb5950b9f25caf';

@ProviderFor(bookingActions)
const bookingActionsProvider = BookingActionsProvider._();

final class BookingActionsProvider
    extends $FunctionalProvider<BookingActions, BookingActions, BookingActions>
    with $Provider<BookingActions> {
  const BookingActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingActionsHash();

  @$internal
  @override
  $ProviderElement<BookingActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookingActions create(Ref ref) {
    return bookingActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingActions>(value),
    );
  }
}

String _$bookingActionsHash() => r'ea0205fd158b886b0020e265566941b71d38c3ec';
