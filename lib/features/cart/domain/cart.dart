class Cart {
  final String id;
  final String foodId;
  final int quantity;
  final double price;
  Cart({
    required this.id,
    required this.foodId,
    required this.quantity,
    required this.price,
  });

  Cart copyWith({
    String? id,
    String? foodId,
    int? quantity,
    double? price,
  }) {
    return Cart(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodId': foodId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['\$id'] as String,
      foodId: map['foodId'] as String,
      quantity: (map['quantity'] as num).round(),
      price: (map['price'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Cart(id: $id, foodId: $foodId, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.foodId == foodId &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ foodId.hashCode ^ quantity.hashCode ^ price.hashCode;
  }
}
