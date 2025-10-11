class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? profileImageUrl;
  final bool isStylist;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.profileImageUrl,
    this.isStylist = false,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isStylist: json['is_stylist'] as bool? ?? false,
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'is_stylist': isStylist,
      'is_admin': isAdmin,
    };
  }
}

