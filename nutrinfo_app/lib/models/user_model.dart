class UserModel {
  final String id;
  final String auth0Sub;
  final String displayName;
  final String email;
  final String dietaryFocus;
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.auth0Sub = '',
    required this.displayName,
    required this.email,
    required this.dietaryFocus,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      auth0Sub: json['auth0_sub'] as String? ?? json['firebase_uid'] as String? ?? '',
      displayName: json['display_name'] as String? ?? 'Anonymous',
      email: json['email'] as String? ?? '',
      dietaryFocus: json['dietary_focus'] as String? ?? 'None',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
