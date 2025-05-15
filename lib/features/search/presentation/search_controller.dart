import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/domain/food.dart';
import '../data/search_repository.dart';


final searchControllerProvider =
    StateNotifierProvider<SearchController, AsyncValue<dynamic>>((ref) {
  return SearchController(
    searchRepository: ref.watch(searchRepositoryProvider),
  );
});

class SearchController extends StateNotifier<AsyncValue<dynamic>> {
  final SearchRepository _searchRepository;
  SearchController({required SearchRepository searchRepository})
      : _searchRepository = searchRepository, super(AsyncValue.data(null));


  /// **Search Food by Query**
  Future<void> searchFoodByQuery(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]); // Reset state if query is empty
      return;
    }

    state = const AsyncValue.loading();

    final result = await _searchRepository.searchFoodByQuery(query);
    final foodList = result.map((doc) => Food.fromMap(doc.data)).toList();

    state = AsyncValue.data(foodList);
  }
}
