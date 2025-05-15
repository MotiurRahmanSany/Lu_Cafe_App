import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/core/utils/user_model_enum.dart'; // Contains UserRole enum
import 'package:lu_cafe/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:lu_cafe/features/auth/data/auth_repository.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/auth/presentation/screens/login_screen.dart';
import 'package:lu_cafe/features/profile/data/user_repository.dart';
import 'package:lu_cafe/features/profile/domain/user_model.dart';

final currentUserProvider = FutureProvider.autoDispose<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser();
});

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AppUser?>((ref) {
  return AuthStateNotifier(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});

class AuthStateNotifier extends StateNotifier<AppUser?> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  AuthStateNotifier({
    required Ref ref,
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(null) {
    _init();
  }

  // On initialization, fetch the current user.
  Future<void> _init() async {
    final user = await _authRepository.currentUser();
    state = user;
  }

  Future<void> register({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final result =
        await _authRepository.register(email: email, password: password);

    result.fold(
      (failure) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: failure.message,
        );
      },
      (userData) async {
        final userModel = UserModel(
          uid: userData.$id,
          name: getNameFromEmail(userData.email),
          email: userData.email,
          userCart: [],
        );

        final result2 = await _userRepository.saveUserData(userModel);

        result2.fold(
          (failure) {
            showDialogMesssageToUser(
              context,
              title: 'Error!',
              message: failure.message,
            );
          },
          (_) async {
            showMessageToUser(
              context,
              message:
                  'User registered successfully! Please login to continue.',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    bool isAdminLogin = false, // Default false for normal login
  }) async {
    // FIRST: if this is an admin login attempt, check the admin collection.
    if (isAdminLogin) {
      final adminCheck =
          await _authRepository.adminAuthRepository.isAdminEmail(email: email);
      final isAdmin = adminCheck.fold((l) => false, (r) => r);
      if (!isAdmin) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: 'You are not an Admin!',
        );
        return; // Abort login if not admin.
      }
    }
    // SECOND: Proceed to create a session.
    final result =
        await _authRepository.login(email: email, password: password);
    result.fold(
      (failure) {
        showDialogMesssageToUser(context,
            title: 'Error!', message: failure.message);
      },
      (session) async {
        // After a successful login, fetch the unified user with role.
        final myUser = await _authRepository.currentUser();
        if (myUser == null) {
          showDialogMesssageToUser(
            context,
            title: 'Error!',
            message: 'Unable to retrieve user data.',
          );
          return;
        }
        print('User logged in: ${myUser.user.email}, role: ${myUser.role}');
        state = myUser;

        if (isAdminLogin && myUser.role == UserRole.admin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminHomeScreen(),
            ),
          );
        }
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    final result = await _authRepository.logout();
    result.fold(
      (failure) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: failure.message,
        );
      },
      (_) {
        state = null; // clear the auth state
        showMessageToUser(context, message: 'Logout Successful!');
      },
    );
  }
}
