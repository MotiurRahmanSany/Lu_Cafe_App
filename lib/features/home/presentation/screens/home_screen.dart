import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/features/home/presentation/controller/home_controller.dart';

import '../../../../core/common/constants/route_const.dart';
import '../../../../core/utils/enums.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../widgets/home_food_tile_widget.dart';
import '../widgets/menu_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final categoryState = ref.watch(
      fetchFoodByCategoryProvider(selectedCategory.type),
    );

    final cartLength = ref.watch(cartControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello LUian!',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //  search icon leading to search screen

                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteLocName.search);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black,
                            ),
                            child: Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Gap(12),
                        // cart icon leading to cart screen
                        GestureDetector(
                          onTap: () {
                            print('cart tapped');
                            context.goNamed(RouteLocName.cart);
                          },
                          child: Badge(
                            offset: Offset(-1, 0),
                            label: cartLength.when(
                              data: (cart) => Center(
                                child: Text(
                                  '${cart.length}',
                                ),
                              ),
                              error: (err, st) => Center(child: Text('...')),
                              loading: () => Center(child: Text('...')),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
              Gap(20),
              Text(
                'Explore Our Menu',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Text(
                'Find the Perfect Meal for Any Time of Day',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Gap(20),
              // breakfast, lunch, snacks, dinner tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuTab(
                      icon: Icons.breakfast_dining,
                      title: 'Breakfast',
                      isSelected: selectedCategory == Category.breakfast,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            Category.breakfast;
                      }),
                  MenuTab(
                      icon: Icons.lunch_dining,
                      title: 'Lunch',
                      isSelected: selectedCategory == Category.lunch,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            Category.lunch;
                      }),
                  MenuTab(
                      icon: Icons.fastfood,
                      title: 'Snacks',
                      isSelected: selectedCategory == Category.snacks,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            Category.snacks;
                      }),
                  MenuTab(
                      icon: Icons.dinner_dining,
                      title: 'Dinner',
                      isSelected: selectedCategory == Category.dinner,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            Category.dinner;
                      }),
                ],
              ),
              Gap(20),
              // food list
              Expanded(
                child: categoryState.when(
                    data: (foodList) {
                      if (foodList.isEmpty) {
                        return Center(
                          child: Text("No food available in this category"),
                        );
                      }

                      return ListView.builder(
                        itemCount: foodList.length,
                        itemBuilder: (context, index) {
                          final food = foodList[index];
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                RouteLocName.foodDetails,
                                pathParameters: {'id': food.id},
                              );
                            },
                            child: HomeFoodTileWidget(food: food),
                          );
                        },
                      );
                    },
                    loading: () => Center(
                          child: CircularProgressIndicator(),
                        ),
                    error: (error, stack) {
                      print('Error: $error');
                      return Center(child: Text('Error: $error'));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
