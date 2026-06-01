import '../../features/services/domain/entities/listing_entity.dart';

const List<String> appCategories = [
  'Plumbing',
  'Cleaning',
  'Development',
  'Design',
  'Marketing',
  'Electrician',
  'Carpentry',
  'Painting',
  'Tutoring',
  'Beauty',
  'Other'
];

class ListingModel extends ListingEntity {
  const ListingModel({
    required super.id,
    required super.providerId,
    required super.providerName,
    super.providerPhoto,
    required super.title,
    required super.description,
    required super.category,
    required super.priceEtb,
    required super.location,
    required super.phone,
    required super.ratingAvg,
    required super.reviewCount,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String? ?? 'Provider',
      providerPhoto: json['providerPhoto'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      priceEtb: (json['priceEtb'] as num?)?.toDouble() ?? 0,
      location: json['location'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toDbMap() => {
        'id': id,
        'provider_id': providerId,
        'provider_name': providerName,
        'provider_photo': providerPhoto,
        'title': title,
        'description': description,
        'category': category,
        'price_etb': priceEtb,
        'location': location,
        'phone': phone,
        'rating_avg': ratingAvg,
        'review_count': reviewCount,
        'cached_at': DateTime.now().toIso8601String(),
        'is_stale': 0,
      };

  factory ListingModel.fromDb(Map<String, dynamic> row) {
    return ListingModel(
      id: row['id'] as String,
      providerId: row['provider_id'] as String,
      providerName: row['provider_name'] as String,
      providerPhoto: row['provider_photo'] as String?,
      title: row['title'] as String,
      description: row['description'] as String? ?? '',
      category: row['category'] as String,
      priceEtb: (row['price_etb'] as num).toDouble(),
      location: row['location'] as String? ?? '',
      phone: row['phone'] as String? ?? '',
      ratingAvg: (row['rating_avg'] as num).toDouble(),
      reviewCount: (row['review_count'] as num).toInt(),
    );
  }
}
