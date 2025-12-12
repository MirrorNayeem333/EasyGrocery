/// ============================================================================
/// EasyGrocer - API Service
/// ============================================================================
/// This service handles all product data for the app.
/// It provides a curated list of grocery products with realistic pricing
/// and high-quality product images from Pexels.
/// 
/// In a production app, this would connect to a real backend API.
/// Currently it uses sample data to demonstrate the app functionality.
/// ============================================================================

import 'package:easygrocer/models/product.dart';

/// ApiService - Handles fetching product data
/// 
/// This service class is responsible for:
/// 1. Providing product data to the app
/// 2. Supporting search/filter functionality
/// 3. Organizing products by category
class ApiService {
  
  /// Fetches products from the data source
  /// 
  /// [query] - Optional search query to filter products by title
  /// Returns a list of Product objects matching the query
  /// 
  /// Example usage:
  /// ```dart
  /// final products = await ApiService().fetchProducts();
  /// final searchResults = await ApiService().fetchProducts(query: 'apple');
  /// ```
  Future<List<Product>> fetchProducts({String query = ''}) async {
    // Get our curated sample grocery products
    final List<Product> allProducts = _getSampleGroceryProducts();

    // If no search query, return all products
    if (query.trim().isEmpty) return allProducts;

    // Filter products by search query (case-insensitive)
    final q = query.toLowerCase().trim();
    return allProducts.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  /// Returns a curated list of sample grocery products
  /// 
  /// Products are organized by category:
  /// - Breakfast (6 items): Cereal, bread, oatmeal, pancakes, etc.
  /// - Snacks (7 items): Chips, cookies, chocolate, popcorn, etc.
  /// - Drinks (7 items): Juice, cola, coffee, tea, water, etc.
  /// - Fruits (7 items): Apples, bananas, oranges, mangoes, etc.
  /// - Vegetables (8 items): Tomatoes, potatoes, carrots, spinach, etc.
  /// - Dairy (6 items): Milk, cheese, yogurt, butter, etc.
  /// - Meat (6 items): Chicken, beef, salmon, prawns, etc.
  /// 
  /// Each product has:
  /// - Unique ID for identification
  /// - Title describing the product
  /// - Price in local currency (Taka ৳)
  /// - Thumbnail image URL from Pexels (high-quality stock photos)
  List<Product> _getSampleGroceryProducts() {
    return [
      // ============ BREAKFAST CATEGORY ============
      // Products that customers typically buy for breakfast meals
      // Keywords used for filtering: cereal, bread, oatmeal, pancake, waffle, toast
      
      Product(
        id: 1001,
        title: 'Corn Flakes Cereal 500g',
        price: 350,
        thumbnail: 'https://images.unsplash.com/photo-1521483451569-e33803c0330c?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1002,
        title: 'Whole Wheat Bread Loaf',
        price: 65,
        thumbnail: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1003,
        title: 'Oatmeal Breakfast Pack',
        price: 280,
        thumbnail: 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1004,
        title: 'Pancake Mix Original 400g',
        price: 195,
        thumbnail: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1005,
        title: 'Multigrain Toast Slices',
        price: 85,
        thumbnail: 'https://images.unsplash.com/photo-1619535860434-ba1d8fa12536?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1006,
        title: 'Belgian Waffle Mix',
        price: 220,
        thumbnail: 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=400&h=400&fit=crop',
      ),

      // ============ SNACKS CATEGORY ============
      // Products for snacking between meals
      // Keywords: chips, cookie, chocolate, biscuit, popcorn, candy, crisp, snack
      
      Product(
        id: 1010,
        title: 'Potato Chips Classic 150g',
        price: 45,
        thumbnail: 'https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1011,
        title: 'Chocolate Cookies Pack',
        price: 75,
        thumbnail: 'https://images.pexels.com/photos/230325/pexels-photo-230325.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1012,
        title: 'Crispy Snack Mix',
        price: 120,
        thumbnail: 'https://images.pexels.com/photos/5945565/pexels-photo-5945565.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1013,
        title: 'Milk Chocolate Bar 100g',
        price: 95,
        thumbnail: 'https://images.pexels.com/photos/65882/chocolate-dark-coffee-confiserie-65882.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1014,
        title: 'Digestive Biscuits 200g',
        price: 85,
        thumbnail: 'https://images.pexels.com/photos/890577/pexels-photo-890577.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1015,
        title: 'Butter Popcorn Pack',
        price: 55,
        thumbnail: 'https://images.pexels.com/photos/33129/popcorn-movie-party-entertainment.jpg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1016,
        title: 'Candy Assorted Mix',
        price: 40,
        thumbnail: 'https://images.pexels.com/photos/1906435/pexels-photo-1906435.jpeg?w=400&h=400&fit=crop',
      ),

      // ============ DRINKS CATEGORY ============
      // Beverages and drinks for various occasions
      // Keywords: juice, drink, cola, coffee, tea, soda, water, beverage, sprite, pepsi
      
      Product(
        id: 1020,
        title: 'Fresh Orange Juice 1L',
        price: 145,
        thumbnail: 'https://images.pexels.com/photos/158053/fresh-orange-juice-squeezed-refreshing-citrus-158053.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1021,
        title: 'Cola Soft Drink 2L',
        price: 85,
        thumbnail: 'https://images.pexels.com/photos/50593/coca-cola-cold-drink-soft-drink-coke-50593.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1022,
        title: 'Instant Coffee Jar 200g',
        price: 285,
        thumbnail: 'https://images.pexels.com/photos/585753/pexels-photo-585753.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1023,
        title: 'Green Tea Bags 25pcs',
        price: 165,
        thumbnail: 'https://images.pexels.com/photos/1417945/pexels-photo-1417945.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1024,
        title: 'Lemon Soda 1.5L',
        price: 75,
        thumbnail: 'https://images.pexels.com/photos/2789328/pexels-photo-2789328.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1025,
        title: 'Mineral Water Bottle 1L',
        price: 20,
        thumbnail: 'https://images.pexels.com/photos/327090/pexels-photo-327090.jpeg?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1026,
        title: 'Apple Juice Fresh 500ml',
        price: 95,
        thumbnail: 'https://images.pexels.com/photos/1337825/pexels-photo-1337825.jpeg?w=400&h=400&fit=crop',
      ),

      // ============ FRUITS CATEGORY ============
      // Fresh fruits for healthy eating
      // Keywords: apple, banana, orange, mango, grape, berry, melon, pear, kiwi, fruit
      
      Product(
        id: 1030,
        title: 'Fresh Red Apples 1kg',
        price: 180,
        thumbnail: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1031,
        title: 'Ripe Bananas 1kg',
        price: 65,
        thumbnail: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1032,
        title: 'Sweet Oranges 1kg',
        price: 120,
        thumbnail: 'https://images.unsplash.com/photo-1547514701-42782101795e?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1033,
        title: 'Fresh Mangoes 1kg',
        price: 250,
        thumbnail: 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1034,
        title: 'Green Grapes Seedless 500g',
        price: 195,
        thumbnail: 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1035,
        title: 'Fresh Strawberry 250g',
        price: 150,
        thumbnail: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1036,
        title: 'Watermelon Slice',
        price: 80,
        thumbnail: 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=400&h=400&fit=crop',
      ),

      // ============ VEGETABLES CATEGORY ============
      // Fresh vegetables for cooking
      // Keywords: tomato, potato, carrot, spinach, onion, broccoli, cabbage, lettuce, vegetable
      
      Product(
        id: 1040,
        title: 'Fresh Tomatoes 1kg',
        price: 45,
        thumbnail: 'https://images.unsplash.com/photo-1546470427-e26264be0b11?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1041,
        title: 'Potatoes 1kg',
        price: 35,
        thumbnail: 'https://images.unsplash.com/photo-1518977676601-b53f82abb95e?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1042,
        title: 'Fresh Carrots 500g',
        price: 40,
        thumbnail: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1043,
        title: 'Green Spinach Bunch',
        price: 25,
        thumbnail: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1044,
        title: 'Onions 1kg',
        price: 50,
        thumbnail: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1045,
        title: 'Fresh Broccoli Head',
        price: 85,
        thumbnail: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1046,
        title: 'Green Cabbage',
        price: 30,
        thumbnail: 'https://images.unsplash.com/photo-1594282486552-05a53a0cbaf8?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1047,
        title: 'Fresh Lettuce',
        price: 35,
        thumbnail: 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400&h=400&fit=crop',
      ),

      // ============ DAIRY CATEGORY ============
      // Dairy products for everyday use
      // Keywords: milk, cheese, yogurt, butter, cream, curd, dairy
      
      Product(
        id: 1050,
        title: 'Fresh Milk 1L',
        price: 75,
        thumbnail: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1051,
        title: 'Cheddar Cheese Block 200g',
        price: 320,
        thumbnail: 'https://images.unsplash.com/photo-1618164436241-4473940d1f5c?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1052,
        title: 'Greek Yogurt 400g',
        price: 145,
        thumbnail: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1053,
        title: 'Butter Unsalted 200g',
        price: 185,
        thumbnail: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1054,
        title: 'Fresh Cream 200ml',
        price: 95,
        thumbnail: 'https://images.unsplash.com/photo-1587657778989-ccb06a830f3f?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1055,
        title: 'Cottage Cheese 250g',
        price: 165,
        thumbnail: 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop',
      ),

      // ============ MEAT CATEGORY ============
      // Meat and seafood products
      // Keywords: chicken, beef, steak, salmon, fish, lamb, turkey, mutton, prawn, shrimp, meat
      
      Product(
        id: 1060,
        title: 'Chicken Breast 500g',
        price: 280,
        thumbnail: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1061,
        title: 'Fresh Beef Steak 500g',
        price: 650,
        thumbnail: 'https://images.unsplash.com/photo-1603048297172-c92544798d5a?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1062,
        title: 'Salmon Fish Fillet 400g',
        price: 750,
        thumbnail: 'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1063,
        title: 'Lamb Mutton Cut 500g',
        price: 580,
        thumbnail: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1064,
        title: 'Fresh Prawns 500g',
        price: 450,
        thumbnail: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=400&h=400&fit=crop',
      ),
      Product(
        id: 1065,
        title: 'Turkey Breast Slices 300g',
        price: 380,
        thumbnail: 'https://images.unsplash.com/photo-1606728035253-49e8a23146de?w=400&h=400&fit=crop',
      ),
    ];
  }
}
