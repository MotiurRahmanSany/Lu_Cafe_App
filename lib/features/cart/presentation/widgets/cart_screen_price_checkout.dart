import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/core/common/ui/custom_icon_button.dart';
import 'package:lu_cafe/features/cart/presentation/widgets/cart_overlay_item.dart';
import '../../../../core/common/constants/route_const.dart';
import '../../domain/cart.dart';

class CartScreenPriceCheckout extends ConsumerWidget {
  const CartScreenPriceCheckout({super.key, required this.cartItems});
  final List<Cart> cartItems;

  double calculateTotalPrice(List<Cart> carts) {
    double totalPrice = 0;
    for (Cart cart in carts) {
      totalPrice += cart.price * cart.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final price = calculateTotalPrice(cartItems);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Total Items
          CartOverlayItem(
            title: 'Items in Cart:',
            price: '${cartItems.length}',
          ),
          // Payable Amount
          CartOverlayItem(
            title: 'Payable Amount:',
            price: '৳${price.toStringAsFixed(0)}',
            isBold: true,
          ),
          const SizedBox(height: 8),
          // Checkout Button
          CustomIconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CheckoutScreen(),
              //   ),
              // );
              context.pushNamed(RouteLocName.checkout);
            },
            label: 'Checkout',
            icon: Icons.payment,
          ),
        ],
      ),
    );
  }

}
