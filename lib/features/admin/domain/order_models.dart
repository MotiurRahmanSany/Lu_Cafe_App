class Order {
  final int id;
  final List<OrderItem> items;
  final double totalPrice;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
  });
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class User {
  final String name;
  final String email;
  final String address;

  User({
    required this.name,
    required this.email,
    required this.address,
  });
}

class CartItem {
  final Food food;
  final double price;
  final int quantity;

  CartItem({
    required this.food,
    required this.price,
    required this.quantity,
  });
}

class Food {
  final String name;
  final String image;

  Food({
    required this.name,
    required this.image,
  });
}
