import 'package:flutter/material.dart';

class FoodQuantityWidget extends StatelessWidget {
  const FoodQuantityWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(context, Icons.remove),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          width: 40,
          child: Center(
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        _buildButton(context, Icons.add),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: icon == Icons.add ? onIncrement : onDecrement,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
