import '../../../core/utils/enums.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;
  final Category category;
  final int calories;
  final bool isAvailable;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
    required this.calories,
    required this.isAvailable,
  });

  Food copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? image,
    double? rating,
    Category? category,
    int? calories,
    bool? isAvailable,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'rating': rating,
      'category': category.type,
      'calories': calories,
      'isAvailable': isAvailable,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['\$id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      rating: (map['rating'] as num).toDouble(),
      category: (map['category'] as String).toCategoryEnum(),
      calories: (map['calories'] as num).round(),
      isAvailable: map['isAvailable'] as bool,
    );
  }

  @override
  String toString() {
    return 'Food(id: $id, name: $name, description: $description, price: $price, image: $image, rating: $rating, category: $category, calories: $calories, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(covariant Food other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.image == image &&
        other.rating == rating &&
        other.category == category &&
        other.calories == calories &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        image.hashCode ^
        rating.hashCode ^
        category.hashCode ^
        calories.hashCode ^
        isAvailable.hashCode;
  }
}
