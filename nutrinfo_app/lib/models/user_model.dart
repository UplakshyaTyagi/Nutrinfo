class UserModel {
  final String id;
  final String auth0Sub;
  final String displayName;
  final String email;
  final String dietaryFocus;
  final String pictureUrl;
  final bool isPro;
  final DateTime createdAt;

  UserModel({
    required this.id,
    this.auth0Sub = '',
    required this.displayName,
    required this.email,
    required this.dietaryFocus,
    this.pictureUrl = '',
    this.isPro = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      auth0Sub:
          json['auth0_sub'] as String? ?? json['firebase_uid'] as String? ?? '',
      displayName: json['display_name'] as String? ?? 'Anonymous',
      email: json['email'] as String? ?? '',
      dietaryFocus: json['dietary_focus'] as String? ?? 'None',
      pictureUrl: json['picture_url'] as String? ?? '',
      isPro: json['is_pro'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// First name for greetings (e.g. "Good morning, Alex.")
  String get firstName {
    final parts = displayName.trim().split(' ');
    return parts.first.isNotEmpty ? parts.first : 'User';
  }

  /// Avatar URL — falls back to ui-avatars.com if no picture
  String get avatarUrl {
    if (pictureUrl.isNotEmpty) return pictureUrl;
    final encoded = Uri.encodeComponent(displayName);
    return 'https://ui-avatars.com/api/?name=$encoded&background=random&size=100';
  }
}
