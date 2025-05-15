import 'package:appwrite/models.dart' as models;


enum UserRole { normal, admin }

class AppUser {
  final models.User user;
  final UserRole role;
  AppUser({required this.user, required this.role});
}
