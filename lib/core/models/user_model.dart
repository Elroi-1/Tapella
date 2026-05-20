class UserModel {
  final String id;
  final String email;
  final String role;
  final String displayName;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profileImage;
  final String? profession;

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      displayName: (json['displayName'] ?? json['display_name']) as String,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      profileImage: (json['profileImage'] ?? json['profile_image']) as String?,
      profession: json['profession'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        'displayName': displayName,
        'phone': phone,
        'location': location,
        'bio': bio,
        'profileImage': profileImage,
        'profession': profession,
      };

  UserModel copyWith({
    String? displayName,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profileImage,
    String? profession,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      role: role,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      profession: profession ?? this.profession,
    );
  }

  bool get isCustomer => role == 'customer';
  bool get isProvider => role == 'provider';

  String get roleLabel => isProvider ? 'SERVICE PROVIDER' : 'PREMIUM MEMBER';
}
