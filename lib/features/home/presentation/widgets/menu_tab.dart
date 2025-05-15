import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });
  final bool isSelected;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
            ),
            Gap(5),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
