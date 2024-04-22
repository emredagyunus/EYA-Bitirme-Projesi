//foood item
class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });
}

// food categories
enum FoodCategory {
  burgers,
  salads,
}
extension FoodCategoryExtension on FoodCategory {
  String get value {
    switch (this) {
      case FoodCategory.burgers:
        return 'En Yeni Şikayetler';
      case FoodCategory.salads:
        return 'En Popüler Şikayetler';


      default:
        return '';
    }
  }
}

// food addons
class Addon{
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });
}