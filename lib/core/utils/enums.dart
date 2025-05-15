enum Category {
  breakfast('breakfast'),
  lunch('lunch'),
  dinner('dinner'),
  snacks('snacks');

  final String type;

  const Category(this.type);
}

extension StringExt on String {
  Category toCategoryEnum() {
    switch (this) {
      case 'breakfast' || 'Breakfast': 
        return Category.breakfast;
      case 'lunch' || 'Lunch':
        return Category.lunch;
      case 'dinner' || 'Dinner':
        return Category.dinner;
      case 'snacks' || 'Snacks':  
        return Category.snacks;
      default:
        return Category.breakfast;
    }
  }

  String toCategoryString() {
    switch (this) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snacks':
        return 'Snacks';
      default:
        return 'Breakfast';
    }
  }

  String firstCap() {
    return this[0].toUpperCase() + substring(1);
  }
}
