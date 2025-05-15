import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lu_cafe/features/home/data/home_repository.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/food.dart';

final fetchFoodByIdProvider =
    FutureProvider.family<Food, String>((ref, id) async {
  final homeController = ref.read(homeControllerProvider.notifier);

  return homeController.fetchFoodById(id: id);
});

final selectedCategoryProvider =
    StateProvider<Category>((ref) => Category.breakfast);

final fetchFoodByCategoryProvider =
    FutureProvider.family<List<Food>, String>((ref, category) async {
  final repository = ref.read(homeRepositoryProvider);
  final result = await repository.fetchFoodByCategory(category: category);

  return result.map((doc) => Food.fromMap(doc.data)).toList();
});

final homeControllerProvider =
    StateNotifierProvider<HomeController, AsyncValue<List<Food>>>((ref) {
  return HomeController(
    homeRepository: ref.watch(homeRepositoryProvider),
  );
});

class HomeController extends StateNotifier<AsyncValue<List<Food>>> {
  final HomeRepository _homeRepository;

  HomeController({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(AsyncValue.data([]));


  // specific food by id for details page
  Future<Food> fetchFoodById({required String id}) async {
    final document = await _homeRepository.fetchFoodById(id: id);

    return Food.fromMap(document.data);
  }
}
