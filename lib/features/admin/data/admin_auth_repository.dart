import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers.dart';
import '../../../core/type_defs.dart';

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((Ref ref) {
  return AdminAuthRepository(
    account: ref.watch(appwriteAccountProvider),
    database: ref.watch(appwriteDatabasesProvider),
  );
});

class AdminAuthRepository {
  final Account _adminAccount;
  final Databases _database;
  AdminAuthRepository({
    required Account account,
    required Databases database,
  })  : _adminAccount = account,
        _database = database;

  // Check if email exists in the admin collection.
  FutureEither<bool> isAdminEmail({required String email}) async {
    try {
      print('entering isAdminEmail response');
      final response = await _database.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.adminCollectionId,
      );
      print('got response: ${response.documents}');
      final isAdmin = response.documents.any((element) {
        return element.data['email'] == email;
      });
      print('isAdmin: $isAdmin');
      return right(isAdmin);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Unexpected Error occurred',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // Log in admin by creating an email-password session.
  FutureEither<models.Session> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final adminSession = await _adminAccount.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return right(adminSession);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while logging in admin',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // Log out admin.
  FutureEitherVoid adminLogout() async {
    try {
      print('Logging out in repo');
      await _adminAccount.deleteSession(sessionId: 'current');
      print('Logged out in repo');
      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while logging out Admin',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  // Get the current admin account if logged in and valid.
  Future<models.User?> currentAdminAccount() async {
    try {
      final user = await _adminAccount.get();
      // Verify that the user is indeed an admin.
      final adminCheck = await isAdminEmail(email: user.email);
      final isAdmin = adminCheck.fold((l) => false, (r) => r);
      if (isAdmin) {
        return user;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
