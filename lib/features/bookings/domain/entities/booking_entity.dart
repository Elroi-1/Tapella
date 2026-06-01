class BookingEntity {
  final String id;
  final String listingId;
  final String listingTitle;
  final String customerId;
  final String customerName;
  final String? customerPhoto;
  final String providerId;
  final String providerName;
  final String? providerPhoto;
  final String status;
  final String? scheduledDate;
  final String notes;
  final double amountEtb;

  const BookingEntity({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.customerId,
    required this.customerName,
    this.customerPhoto,
    required this.providerId,
    required this.providerName,
    this.providerPhoto,
    required this.status,
    this.scheduledDate,
    this.notes = '',
    this.amountEtb = 0,
  });
}
