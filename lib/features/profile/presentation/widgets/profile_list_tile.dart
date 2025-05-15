import 'package:flutter/material.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String? description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: description != null ? Text(description!) : null,
          onTap: onPressed,
        ),
      ),
    );
  }
}
