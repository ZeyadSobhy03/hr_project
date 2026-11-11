class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.group,
    this.groupId,
    this.isActive = true,
  });

  /// Supabase returns a UUID. Object keeps existing local/demo integer IDs
  /// source-compatible until the UI is connected to the remote data source.
  final Object id;
  final String fullName;
  final String username;
  final String email;
  final String group;
  final String? groupId;
  final bool isActive;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final relation = json['user_groups'];
    final group = relation is Map<String, dynamic>
        ? relation
        : relation is List && relation.isNotEmpty && relation.first is Map
        ? Map<String, dynamic>.from(relation.first as Map)
        : const <String, dynamic>{};

    return AppUser(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      group: group['name'] as String? ?? '',
      groupId: json['group_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
