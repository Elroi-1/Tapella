class BookingModel {
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

  const BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String? ?? 'Service',
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String? ?? 'Customer',
      customerPhoto: json['customerPhoto'] as String?,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String? ?? 'Provider',
      providerPhoto: json['providerPhoto'] as String?,
      status: json['status'] as String,
      scheduledDate: json['scheduledDate'] as String?,
      notes: json['notes'] as String? ?? '',
      amountEtb: (json['amountEtb'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toDbMap() => {
    'id': id,
    'listing_id': listingId,
    'listing_title': listingTitle,
    'customer_id': customerId,
    'customer_name': customerName,
    'customer_photo': customerPhoto,
    'provider_id': providerId,
    'provider_name': providerName,
    'provider_photo': providerPhoto,
    'status': status,
    'scheduled_date': scheduledDate,
    'notes': notes,
    'amount_etb': amountEtb,
    'cached_at': DateTime.now().toIso8601String(),
    'is_stale': 0,
  };

  factory BookingModel.fromDb(Map<String, dynamic> row) {
    return BookingModel(
      id: row['id'] as String,
      listingId: row['listing_id'] as String,
      listingTitle: row['listing_title'] as String,
      customerId: row['customer_id'] as String,
      customerName: row['customer_name'] as String,
      customerPhoto: row['customer_photo'] as String?,
      providerId: row['provider_id'] as String,
      providerName: row['provider_name'] as String,
      providerPhoto: row['provider_photo'] as String?,
      status: row['status'] as String,
      scheduledDate: row['scheduled_date'] as String?,
      notes: row['notes'] as String? ?? '',
      amountEtb: (row['amount_etb'] as num).toDouble(),
    );
  }
}
