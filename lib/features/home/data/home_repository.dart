import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';

import '../../../core/failure.dart';
import '../../../core/providers.dart';

final homeRepositoryProvider = Provider<HomeRepository>((Ref ref) {
  return HomeRepository(
    database: ref.watch(appwriteDatabasesProvider),
  );
});

class HomeRepository {
  final Databases _database;

  HomeRepository({
    required Databases database,
  }) : _database = database;

  // fetch food by category
  Future<List<Document>> fetchFoodByCategory({required String category}) async {
    try {
      final documentList = await _database.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.foodCollectionId,
        queries: [
          Query.equal('category', category),
        ],
      );

      return documentList.documents;
    } catch (err) {
      throw 'Error occurred while fetching food items!';
    }
  }

  // fetch specific food by id
  Future<Document> fetchFoodById({required String id}) async {
    try {
      final document = await _database.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.foodCollectionId,
        documentId: id,
      );

      return document;
    } on AppwriteException catch (err, stackTrace) {
      throw Failure(
        message: err.message ?? 'Error occurred while fetching food item!',
        stackTrace: stackTrace,
      );
    } catch (err, stackTrace) {
      throw Failure(
        message: err.toString(),
        stackTrace: stackTrace,
      );
    }
  }
}
