import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';
import 'package:lu_cafe/core/providers.dart';
import 'package:lu_cafe/core/type_defs.dart';

import '../../../core/failure.dart';
import '../domain/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((Ref ref) {
  return UserRepository(
    database: ref.read(appwriteDatabasesProvider),
  );
});

class UserRepository {
  final Databases _database;

  UserRepository({required Databases database}) : _database = database;

  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _database.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      return right(null);
    } on AppwriteException catch (err, stackTrace) {
      return left(
        Failure(
          message: err.message ?? 'Error occurred while saving user data',
          stackTrace: stackTrace,
        ),
      );
    } catch (err, stackTrace) {
      return left(
        Failure(
          message: 'An unknown error occurred',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<UserModel> getUserData(String uid) async {
    final response = await _database.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: uid,
    );
    print('tryna get user data');
    final userModel = UserModel.fromMap(response.data);
    print('got user data: $userModel');
    return userModel;
  }

  FutureEitherVoid updateUserCart(
      {required String uid, required String cartId}) async {
    try {
      // Get current user document.
      final doc = await _database.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
      );
      List<dynamic> currentCart = doc.data['userCart'] ?? [];
      currentCart.add(cartId);
      await _database.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
        data: {'userCart': currentCart},
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  FutureEitherVoid removeCartFromUser(
      {required String uid, required String cartId}) async {
    try {
      final doc = await _database.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
      );
      List<dynamic> currentCart = doc.data['userCart'] ?? [];
      currentCart.remove(cartId);
      await _database.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
        data: {'userCart': currentCart},
      );
      return right(null);
    } catch (e, stackTrace) {
      return left(Failure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  FutureEitherVoid clearUserCart({required String uid}) async {
    try {
      await _database.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
        data: {'userCart': []},
      );

      return right(null);
    } catch (err, st) {
      return left(Failure(message: err.toString(), stackTrace: st));
    }
  }
}
