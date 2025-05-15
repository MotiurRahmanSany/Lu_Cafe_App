import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/ui/custom_icon_button.dart';
import '../../../../core/utils/utils.dart';
import '../../../cart/domain/cart.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/presentation/widgets/food_quantity_selection_widget.dart';
import '../controller/home_controller.dart';

class FoodDetailsScreen extends ConsumerStatefulWidget {
  const FoodDetailsScreen({
    super.key,
    required this.foodId,
  });
  final String foodId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  bool _isInCart = false;
  int _quantity = 1;
  int _previousQuantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartState = ref.read(cartControllerProvider);
      cartState.when(
        data: (cartItems) {
          final existing = cartItems.firstWhere(
            (cartItem) => cartItem.foodId == widget.foodId,
            orElse: () => Cart(id: '', foodId: '', quantity: 1, price: 0),
          );
          if (existing.id.isNotEmpty) {
            setState(() {
              _quantity = 0;
              _previousQuantity = existing.quantity;
              _isInCart = true;
            });
          } else {
            setState(() {
              _quantity = 1;
            });
          }
        },
        error: (err, st) {},
        loading: () {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final foodState = ref.watch(fetchFoodByIdProvider(widget.foodId));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: foodState.when(
            data: (food) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              transitionOnUserGestures: true,
                              tag: food.id,
                              child: CachedNetworkImage(
                                imageUrl: food.image,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                key: UniqueKey(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.55),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_outlined),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                food.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            FoodQuantityWidget(
                              quantity: _isInCart
                                  ? (_previousQuantity + _quantity)
                                  : _quantity,
                              onIncrement: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              onDecrement: () {
                                if (_quantity > 1) {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        Text(
                          food.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        Text(
                          food.isAvailable ? 'In Stock' : 'Out of Stock',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: food.isAvailable
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        // calories
                        Text(
                          'Calories: ${food.calories.toString()}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '৳${food.price.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                  food.rating.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                        ),

                        CustomIconButton(
                          onPressed: food.isAvailable
                              ? () {
                                  final cart = Cart(
                                    id: '',
                                    foodId: food.id,
                                    quantity: _isInCart ? (_previousQuantity + _quantity) : _quantity,
                                    price: food.price,
                                  );
                                  cartNotifier.addCartItem(
                                    context,
                                    cart: cart,
                                  );
                                  showMessageToUser(
                                    context,
                                    message: _isInCart ? 'Item quantity updated!' : 'Item added to cart!',
                                  );
                                  context.pop();
                                }
                              : null,
                          label: 'Add to Cart',
                          icon: Icons.add_shopping_cart_rounded,
                        ),

                        Gap(10),
                      ],
                    ),
                  )
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
    );
  }
}
