class ListingEntity {
  final String id;
  final String providerId;
  final String providerName;
  final String? providerPhoto;
  final String title;
  final String description;
  final String category;
  final double priceEtb;
  final String location;
  final String phone;
  final double ratingAvg;
  final int reviewCount;

  const ListingEntity({
    required this.id,
    required this.providerId,
    required this.providerName,
    this.providerPhoto,
    required this.title,
    required this.description,
    required this.category,
    required this.priceEtb,
    required this.location,
    required this.phone,
    required this.ratingAvg,
    required this.reviewCount,
  });
}
