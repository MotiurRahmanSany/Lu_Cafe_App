import 'package:flutter/material.dart';
import 'package:lu_cafe/features/admin/presentation/screens/order_details_screen.dart';

import '../../domain/order_models.dart';

class ViewOrderSalesScreen extends StatelessWidget {
  ViewOrderSalesScreen({Key? key}) : super(key: key);

  // Hardcoded list of users with email and address
  final List<User> users = [
    User(
      name: 'John Doe',
      email: 'johndoe@example.com',
      address: '123 Main Street, City A',
    ),
    User(
      name: 'Jane Smith',
      email: 'janesmith@example.com',
      address: '456 Oak Avenue, City B',
    ),
    User(
      name: 'Alice Johnson',
      email: 'alicej@example.com',
      address: '789 Pine Road, City C',
    ),
    User(
      name: 'Bob Brown',
      email: 'bobbrown@example.com',
      address: '101 Maple Lane, City D',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders & Sales'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: ListTile(
                title: Text(user.name),
                subtitle: Text('${user.email}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsScreen(
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
