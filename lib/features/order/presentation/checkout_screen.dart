import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/core/common/ui/custom_icon_button.dart';
import 'package:lu_cafe/core/utils/enums.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lu_cafe/features/cart/presentation/controllers/cart_controller.dart';
import 'package:lu_cafe/features/home/presentation/controller/home_controller.dart';

import '../../cart/domain/cart.dart';
import '../../cart/presentation/screens/delivery_screen.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  void goToDelivery(BuildContext context, WidgetRef ref) async {
    // Call the clearCart function from the controller
    await ref.read(cartControllerProvider.notifier).clearCart(context);
    Navigator.of(context).pop(); // Close the dialog box

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeliveryScreen(),
      ),
    );
  }

  void confirmOrderDialogBox(BuildContext context, WidgetRef ref,
      {required double price}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm Order?',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(text: 'Ensure your delivery address is correct.'),
              const SizedBox(height: 8),
              _buildInfoRow(text: 'Payment Method: Cash on Delivery (COD)'),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () => goToDelivery(context, ref),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  // color: AppColor.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double calculateTotalPrice(List<Cart> carts) {
    double totalPrice = 0;
    for (Cart cart in carts) {
      totalPrice += cart.price * cart.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () =>context.pop(),
        ),
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: userState.when(
        data: (user) {
          // Wrap your content in a Stack so that the Place Order button is pinned.
          return Stack(
            children: [
              // Main scrollable content.
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                    bottom: 100), // Reserve space for button.
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(15),
                      Text(
                        'Buyer Details',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 20),
                      ),

                      _buildBuyerDetails(
                        context: context,
                        title: 'Name',
                        description:
                            getNameFromEmail(user!.user.email).firstCap(),
                      ),
                      _buildBuyerDetails(
                        context: context,
                        title: 'Email',
                        description: user.user.email,
                      ),

                      _buildBuyerDetails(
                        context: context,
                        title: 'Address',
                        description:
                            'Leading University, Ragibnagar, South Surma, Sylhet-3112',
                      ),
                      _buildBuyerDetails(
                        context: context,
                        title: 'Payment Method',
                        description: 'Cash on Delivery',
                      ),
                      // Order details
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Order Details',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 20),
                        ),
                      ),
                      _buildOrderDetails(context: context, ref: ref),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      // Total price section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Price',
                                style: TextStyle(fontSize: 17)),
                            Consumer(builder: (context, ref, _) {
                              final cartItems =
                                  ref.watch(cartControllerProvider).value ?? [];
                              return Text(
                                '৳${calculateTotalPrice(cartItems).toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 17),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Place Order button overlayed at the bottom.
              Positioned(
                left: 0,
                right: 0,
                bottom: 55,
                child: Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: CustomIconButton(
                    onPressed: () {
                      confirmOrderDialogBox(
                        context,
                        ref,
                        price: calculateTotalPrice(
                            ref.watch(cartControllerProvider).value ?? []),
                      );
                    },
                    label: 'Place Order',
                    icon: Icons.shopping_cart_checkout_outlined,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBuyerDetails({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14)),
      subtitle: Text(
        description,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget _buildInfoRow({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check,
          color: Colors.green,
          size: 30,
        ),
        const SizedBox(width: 5),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildOrderDetails(
      {required BuildContext context, required WidgetRef ref}) {
    final cartState = ref.watch(cartControllerProvider);
    return cartState.when(
      data: (cart) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final cartItem = cart[index];
              return _buildEachOrderItem(
                context: context,
                ref: ref,
                cart: cartItem,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildEachOrderItem({
    required BuildContext context,
    required WidgetRef ref,
    required Cart cart,
  }) {
    final foodState = ref.watch(fetchFoodByIdProvider(cart.foodId));
    return foodState.when(
      data: (food) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(food.image),
          ),
          title: Text(food.name, style: const TextStyle(fontSize: 17)),
          subtitle: Text(
            'Price: ৳${cart.price.toStringAsFixed(0)} x ${cart.quantity} = ৳${(cart.price * cart.quantity).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
      error: (err, st) => const Text('Error loading food item'),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
