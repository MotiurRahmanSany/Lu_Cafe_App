import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';
import 'package:lu_cafe/features/home/domain/food.dart';

import '../../../core/failure.dart';
import '../../../core/providers.dart';
import '../../../core/type_defs.dart';

final adminPanelRepositoryProvider = Provider<AdminPanelRepository>(
  (ref) => AdminPanelRepository(
    storage: ref.watch(appwriteStorageProvider),
    database: ref.watch(appwriteDatabasesProvider),
  ),
);


class AdminPanelRepository {
  final Storage _storage;
  final Databases _database;

  AdminPanelRepository({
    required Storage storage,
    required Databases database,
  })  : _storage = storage,
        _database = database;

  // upload image to the storage and return the image id
  FutureEither<String> uploadImage({required File file}) async {
    try {
      final uploadedFile = await _storage.createFile(
        bucketId: AppwriteConstants.foodImageBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      return right(uploadedFile.$id);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(message: e.message ?? 'Error uploading image', stackTrace: st),
      );
    } catch (e) {
      print('Error uploading image: $e');
      return left(
        Failure(message: e.toString(), stackTrace: StackTrace.current),
      );
    }
  }

  FutureEitherVoid deleteImage({required String fileId}) async {
    try {
      await _storage.deleteFile(
        fileId: fileId,
        bucketId: AppwriteConstants.foodImageBucketId,
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(message: e.message ?? 'Error deleting image', stackTrace: st),
      );
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }
  

  // create food item
  // get the food model and then upload it to the database to create a new food item
  FutureEitherVoid createFoodItem({required Food food}) async {
    try {
      await _database.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.foodCollectionId,
        documentId: ID.unique(),
        data: food.toMap(),
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
            message: e.message ?? 'Error creating food item', stackTrace: st),
      );
    } catch (e, st) {
      print('Error creating food item: $e');
      return left(
        Failure(message: e.toString(), stackTrace: st),
      );
    }
  }

  // update food item
  FutureEitherVoid updateFoodItem({required Food food}) async {
    try {
      await _database.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.foodCollectionId,
        documentId: food.id,
        data: food.toMap(),
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          message: e.message ?? 'Error updating food item',
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      print('Error updating food item: $e');
      return left(
        Failure(message: e.toString(), stackTrace: st),
      );
    }
  }

  // delete food item
  FutureEitherVoid deleteFoodItem({required String foodId}) async {
    try {
      await _database.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.foodCollectionId,
        documentId: foodId,
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          message: e.message ?? 'Error deleting food item',
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      print('Error deleting food item: $e');
      return left(
        Failure(message: e.toString(), stackTrace: st),
      );
    }
  }


}
