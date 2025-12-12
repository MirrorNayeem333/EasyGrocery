/// ============================================================================
/// EasyGrocer - Product Model
/// ============================================================================
/// This file defines the Product data model used throughout the app.
/// Products are the core entity in a grocery shopping application.
/// ============================================================================

/// Product - Represents a grocery product in the store
/// 
/// This is a simple data class (model) that holds product information.
/// It uses immutable properties (final) for data integrity.
/// 
/// Properties:
/// - [id]: Unique identifier for the product
/// - [title]: Display name/description of the product
/// - [price]: Cost of the product in local currency (Taka ৳)
/// - [thumbnail]: URL of the product image
/// 
/// Example:
/// ```dart
/// final apple = Product(
///   id: 1,
///   title: 'Fresh Apples 1kg',
///   price: 180,
///   thumbnail: 'https://example.com/apple.jpg',
/// );
/// ```
class Product {
  /// Unique identifier for the product
  final int id;
  
  /// Display name of the product (e.g., "Fresh Apples 1kg")
  final String title;
  
  /// Price in local currency (Taka ৳)
  final double price;
  
  /// URL of the product thumbnail image
  final String thumbnail;

  /// Creates a new Product instance
  /// All parameters are required for data completeness
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  /// Factory constructor to create a Product from JSON data
  /// 
  /// This is used when parsing data from an API response.
  /// Handles type conversion and null safety.
  /// 
  /// [j] - JSON map containing product data
  /// Returns a new Product instance
  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'] as int,
      title: (j['title'] ?? '') as String,
      // Convert to double as JSON numbers can be int or double
      price: (j['price'] as num).toDouble(),
      thumbnail: (j['thumbnail'] ?? '') as String,
    );
  }
}
