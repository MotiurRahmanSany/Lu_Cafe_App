import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/features/profile/data/user_repository.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/user_model.dart';


final  userDataProvider = FutureProvider.family<UserModel, String>((Ref ref, uid) async {
  final userRepository = ref.watch(userRepositoryProvider);

  return userRepository.getUserData(uid);
});

final userControllerProvider = StateNotifierProvider<UserController, bool>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserController(userRepository: userRepository);
});

class UserController extends StateNotifier<bool> {
  final UserRepository _userRepository;

  UserController({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(false);

  void saveUserData({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    state = true;
    final result = await _userRepository.saveUserData(userModel);
    state = false;
    result.fold(
      (failure) {
        showDialogMesssageToUser(
          context,
          title: 'Error!',
          message: failure.message,
        );
      },
      (userData) {
        showDialogMesssageToUser(
          context,
          title: 'Success!',
          message: 'User data saved successfully!',
        );
      },
    );
  }
}
