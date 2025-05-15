import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/core/common/constants/appwrite_constants.dart';

import '../../../core/providers.dart';



final  searchRepositoryProvider = Provider<SearchRepository>((Ref ref) {
  return SearchRepository(
    databases: ref.watch(appwriteDatabasesProvider),
  );
});


class SearchRepository {
  final Databases _databases;

  SearchRepository({required Databases databases}) : _databases = databases;

  Future<List<Document>> searchFoodByQuery(String query) async {
    final matchedDcuments = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.foodCollectionId,
      queries: [
        Query.contains('name', query),
      ],
    );

    return matchedDcuments.documents;
  }
}
