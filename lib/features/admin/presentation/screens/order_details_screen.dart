import 'package:flutter/material.dart';

import '../../../../core/common/constants/constants.dart';
import '../../domain/order_models.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({
    super.key,
    required this.user,
  });

  final User user;

  // Hardcoded total price calculation
  double calculateTotalPrice(List<Map<String, dynamic>> cartItems) {
    double totalPrice = 0;
    for (var cart in cartItems) {
      totalPrice += cart['price'] * cart['quantity'];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cartItems = [
      {
        'name': 'Burger',
        'price': 150.0,
        'quantity': 2,
        'image': Constants.burgerPizzaPasta,
      },
      {
        'name': 'Pizza',
        'price': 300.0,
        'quantity': 1,
        'image': Constants.burgerPizzaPasta,
      },
      {
        'name': 'Fries',
        'price': 100.0,
        'quantity': 3,
        'image': Constants.burgerPizzaPasta,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buyer Details
            const SizedBox(height: 15),
            Text(
              'Buyer Details',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 20),
            ),
            _buildBuyerDetails(
              context: context,
              title: 'Name',
              description: user.name,
            ),
            _buildBuyerDetails(
              context: context,
              title: 'Email',
              description: user.email,
            ),
            _buildBuyerDetails(
              context: context,
              title: 'Address',
              description: user.address,
            ),
            _buildBuyerDetails(
              context: context,
              title: 'Payment Method',
              description: 'Cash on Delivery',
            ),
            const SizedBox(height: 15),
            // Order Details
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Order Details',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 20),
              ),
            ),
            _buildOrderDetails(context, cartItems),
            const Divider(
              thickness: 1,
              color: Colors.black38,
            ),
            // Total Price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Price', style: TextStyle(fontSize: 17)),
                  Text(
                    '৳${calculateTotalPrice(cartItems).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Buyer details
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

  // Order details
  Widget _buildOrderDetails(
      BuildContext context, List<Map<String, dynamic>> cartItems) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return _buildEachOrderItem(
            context: context,
            cart: cartItem,
          );
        },
      ),
    );
  }

  // Order item details
  Widget _buildEachOrderItem({
    required BuildContext context,
    required Map<String, dynamic> cart,
  }) {
    return ListTile(
      title: Text(cart['name'], style: const TextStyle(fontSize: 17)),
      subtitle: Text(
        'Price: ৳${cart['price'].toStringAsFixed(0)} x ${cart['quantity']} ',
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Text(
        '= ৳${(cart['price'] * cart['quantity']).toStringAsFixed(0)}',
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
