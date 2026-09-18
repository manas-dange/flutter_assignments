class UserProfile {
  final String fullName;
  final String email;
  final String role;
  final DateTime registeredAt;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.role,
    required this.registeredAt,
  });
}
