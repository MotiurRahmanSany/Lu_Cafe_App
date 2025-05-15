import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/features/admin/presentation/controllers/admin_panel_controller.dart';
import 'package:lu_cafe/features/admin/presentation/screens/inventory_food_edit_screen.dart';

import '../../../../core/utils/enums.dart';
import '../../../home/domain/food.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../home/presentation/widgets/menu_tab.dart';

class AdminViewInventoryScreen extends ConsumerWidget {
  const AdminViewInventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    final categoryState = ref.watch(
      continuouslyFetchFoodByCategoryProvider(selectedCategory.type),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuTab(
                      icon: Icons.breakfast_dining,
                      title: 'Breakfast',
                      isSelected: selectedCategory == Category.breakfast,
                      onTap: () {
                        ref
                            .read(selectedCategoryProvider.notifier).state = 
                            Category.breakfast;
                      }),
                  MenuTab(
                      icon: Icons.lunch_dining,
                      title: 'Lunch',
                      isSelected: selectedCategory == Category.lunch,
                      onTap: () {
                        ref
                            .read(selectedCategoryProvider.notifier).state =
                            Category.lunch;
                      }),
                  MenuTab(
                      icon: Icons.fastfood,
                      title: 'Snacks',
                      isSelected: selectedCategory == Category.snacks,
                      onTap: () {
                        ref
                            .read(selectedCategoryProvider.notifier).state = 
                            Category.snacks;
                      }),
                  MenuTab(
                      icon: Icons.dinner_dining,
                      title: 'Dinner',
                      isSelected: selectedCategory == Category.dinner,
                      onTap: () {
                        ref
                            .read(selectedCategoryProvider.notifier).state = 
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
                          return _buildInventoryEditTile(context, food: food);
                        },
                      );
                    },
                    loading: () => Center(
                            child: CircularProgressIndicator(
                        )),
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

  Widget _buildInventoryEditTile(BuildContext context, {required Food food}) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: ListTile(
        onTap: () {
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InventoryFoodEditScreen(food: food),
            ),
          );
        },

        leading: CircleAvatar(
          radius: 35,
          backgroundImage: CachedNetworkImageProvider(food.image),
        ),
        // isThreeLine: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        title: Text(food.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        titleTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        subtitle: Text(
          food.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.edit_note_outlined,
          size: 32,
        ),
      ),
    );
  }
}
