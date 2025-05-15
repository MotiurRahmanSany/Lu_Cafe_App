import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:appwrite/models.dart' as models;
import 'package:lu_cafe/core/utils/user_model_enum.dart';
import 'package:lu_cafe/features/admin/data/admin_auth_repository.dart';
import '../../../core/failure.dart';
import '../../../core/providers.dart';
import '../../../core/type_defs.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (Ref ref) => AuthRepository(
    account: ref.read(appwriteAccountProvider),
    adminAuthRepository: ref.read(adminAuthRepositoryProvider),
  ),
);

class AuthRepository {
  final Account _account;
  final AdminAuthRepository adminAuthRepository;

  AuthRepository({
    required Account account,
    required AdminAuthRepository adminAuthRepository,
  })  : _account = account,
        adminAuthRepository = adminAuthRepository;

  // Check if the current user is admin or not and wrap it.
  Future<AppUser?> currentUser() async {
    try {
      final user = await _account.get();
      final adminCheck =
          await adminAuthRepository.isAdminEmail(email: user.email);
      final isAdmin = adminCheck.fold((l) => false, (r) => r);
      return AppUser(
          user: user, role: isAdmin ? UserRole.admin : UserRole.normal);
    } on AppwriteException {
      return null;
    } catch (_) {
      return null;
    }
  }

  FutureEither<models.User> register({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while registering user',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(message: err.toString(), stackTrace: stackTrace),
      );
    }
  }

  FutureEither<models.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      return right(session);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while logging in user',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(
          message: err.toString(),
          stackTrace: stackTrace,
        ),
      );
    }
  }

  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while logging out user',
          stackTrace: stackTrace,
        ),
      );
    } catch (err) {
      return left(
        Failure(
          message: err.toString(),
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}
