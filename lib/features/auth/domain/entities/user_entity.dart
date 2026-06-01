class UserEntity {
  final String id;
  final String email;
  final String role;
  final String displayName;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profileImage;
  final String? profession;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.displayName,
    this.phone,
    this.location,
    this.bio,
    this.profileImage,
    this.profession,
  });

  bool get isCustomer => role == 'customer';
  bool get isProvider => role == 'provider';
  String get roleLabel => isProvider ? 'SERVICE PROVIDER' : 'PREMIUM MEMBER';
}
