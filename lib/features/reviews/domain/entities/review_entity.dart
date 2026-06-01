class ReviewEntity {
  final String id;
  final String bookingId;
  final String listingId;
  final String customerId;
  final String customerName;
  final String? customerPhoto;
  final int rating;
  final String comment;

  const ReviewEntity({
    required this.id,
    required this.bookingId,
    required this.listingId,
    required this.customerId,
    required this.customerName,
    this.customerPhoto,
    required this.rating,
    this.comment = '',
  });
}
