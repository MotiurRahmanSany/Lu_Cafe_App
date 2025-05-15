import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/core/common/constants/route_const.dart';
import 'package:lu_cafe/core/utils/utils.dart';
import 'package:lu_cafe/features/cart/presentation/widgets/food_quantity_selection_widget.dart';

import '../../../home/presentation/controller/home_controller.dart';
import '../../domain/cart.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_screen_price_checkout.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  bool _delteCartItem(BuildContext context,
      {required Cart cart, required WidgetRef ref}) {
    ref.read(cartControllerProvider.notifier).removeCartItem(
          context,
          cartId: cart.id,
        );
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cartState.when(
            data: (cartItems) {
              if (cartItems.isEmpty) {
                return _buildEmptyCart(context);
              }

              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Dismissible(
                            key: Key(cartItem.id),
                            confirmDismiss: (direction) async {
                              return await showDeleteCartItemDialog(
                                context,
                                () => _delteCartItem(context,
                                    cart: cartItem, ref: ref),
                              );
                            },
                            background: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                              ),
                            ),
                            direction: DismissDirection.startToEnd,
                            child: _buildCartTile(
                                cart: cartItem, context: context, ref: ref),
                          );
                        },
                      ),
                    ),

                    // Checkout section visible only when items exist in the cart
                    CartScreenPriceCheckout(cartItems: cartItems),
                    Gap(45),
                  ],
                ),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            error: (error, st) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const Gap(20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          Text(
            'Add items to your cart to see them here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          // order more button
          const Gap(20),
          ElevatedButton.icon(
            onPressed: () {
              context.goNamed(RouteLocName.home);
            },
            label: const Text(
              'Order More!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // burger icon
            icon: const Icon(
              Icons.fastfood,
              size: 25,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconColor: Colors.white,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartTile({
    required Cart cart,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final cartItemState = ref.watch(fetchFoodByIdProvider(cart.foodId));
    return cartItemState.when(
      data: (food) {
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: food.image,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Gap(5),
                      Text(
                        'Quantity: ${cart.quantity}\nPrice: ৳${cart.price.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                FoodQuantityWidget(
                  quantity: cart.quantity,
                  onIncrement: () {
                    ref
                        .read(cartControllerProvider.notifier)
                        .incrementItemQuantity(context, cart: cart);
                  },
                  onDecrement: () {
                    ref
                        .read(cartControllerProvider.notifier)
                        .decrementItemQuantity(context, cart: cart);
                  },
                ),
              ],
            ),
          ),
        );
      },
      error: (error, st) => const Text('Error loading food item'),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
