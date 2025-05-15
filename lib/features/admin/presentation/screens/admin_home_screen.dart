import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/admin/presentation/screens/admin_add_food_item_screen.dart';
import 'package:lu_cafe/features/admin/presentation/screens/admin_view_inventory_screen.dart';
import 'package:lu_cafe/features/admin/presentation/screens/view_order_sales_screen.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lu_cafe/features/auth/presentation/screens/login_screen.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  void _adminLogout(BuildContext context, WidgetRef ref) {
    ref.read(authStateNotifierProvider.notifier).logout(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  void _goToAddItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminAddFoodItemScreen(),
      ),
    );
  }

  void _goToInventory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminViewInventoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => showLogoutConfirmDialog(
                        context,
                        () => _adminLogout(context, ref),
                      ),
                      icon: Icon(Icons.logout),
                    ),
                  ],
                ),
                Gap(10),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 9 / 16,
                  children: [
                    _buildGridItem(
                      context,
                      icon: Icons.fastfood_outlined,
                      title: 'Add Food Item',
                      subTitle: 'Add new Food Item in any category',
                      onTap: () => _goToAddItem(context),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.inventory,
                      title: 'Edit Inventory',
                      subTitle: 'View, Edit and Delete Inventory Items',
                      onTap: () => _goToInventory(context),
                    ),
                    // order and sales
                    _buildGridItem(
                      context,
                      icon: Icons.receipt_long_sharp,
                      title: 'Orders and Sales',
                      subTitle: 'View Orders and Sales',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewOrderSalesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subTitle,
    required Function() onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              Gap(10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(5),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
