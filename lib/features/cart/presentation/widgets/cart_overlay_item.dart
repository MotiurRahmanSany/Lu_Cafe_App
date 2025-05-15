import 'package:flutter/material.dart';

class CartOverlayItem extends StatelessWidget {
  const CartOverlayItem({
    super.key,
    required this.title,
    required this.price,
    this.isBold = false,
  });

  final String title;
  final String price;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          price,
          style: isBold
              ? const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              : const TextStyle(
                  fontSize: 16,
                ),
        ),
      ],
    );

  }
}
