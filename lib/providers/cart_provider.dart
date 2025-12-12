/// ============================================================================
/// EasyGrocer - Cart Provider
/// ============================================================================
/// This provider manages the shopping cart state.
/// It handles adding, removing, and modifying items in the cart.
/// 
/// Uses the Provider pattern (ChangeNotifier) for reactive state management.
/// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:easygrocer/models/product.dart';
import 'package:easygrocer/models/order.dart';

/// CartLine - Represents a single line item in the cart
/// 
/// Each CartLine contains:
/// - A Product reference
/// - Quantity of that product
/// 
/// This allows tracking how many of each product the user wants to buy.
class CartLine {
  /// The product being purchased
  final Product product;
  
  /// Quantity to purchase (can be modified)
  int qty;
  
  CartLine({required this.product, required this.qty});
}

/// CartProvider - Manages shopping cart state
/// 
/// Features:
/// - Add products to cart
/// - Increment/decrement quantities
/// - Remove items completely
/// - Clear entire cart
/// - Calculate totals
/// - Convert to order items for checkout
/// - Load items from previous order (reorder)
/// 
/// Usage:
/// ```dart
/// // Add to cart
/// context.read<CartProvider>().add(product);
/// 
/// // Get cart items
/// final items = context.watch<CartProvider>().lines;
/// 
/// // Get total price
/// final total = context.watch<CartProvider>().total;
/// ```
class CartProvider extends ChangeNotifier {
  // Map of product ID to CartLine for O(1) lookup
  final Map<int, CartLine> _lines = {};

  /// Get all cart lines as a list
  List<CartLine> get lines => _lines.values.toList();
  
  /// Get total number of items in cart (sum of all quantities)
  int get itemsCount => _lines.values.fold(0, (a, b) => a + b.qty);
  
  /// Get total price of all items in cart
  double get total => _lines.values.fold(0, (a, b) => a + b.qty * b.product.price);

  /// Add a product to the cart
  /// 
  /// If the product already exists, increment its quantity.
  /// Otherwise, add a new line with quantity 1.
  void add(Product p) {
    if (_lines.containsKey(p.id)) {
      // Product exists - increment quantity
      _lines[p.id]!.qty += 1;
    } else {
      // New product - add to cart
      _lines[p.id] = CartLine(product: p, qty: 1);
    }
    notifyListeners();
  }

  /// Increment quantity for a specific product
  void inc(int productId) {
    if (_lines.containsKey(productId)) {
      _lines[productId]!.qty += 1;
      notifyListeners();
    }
  }

  /// Decrement quantity for a specific product
  /// 
  /// If quantity reaches 0, the item is removed from cart.
  void dec(int productId) {
    if (!_lines.containsKey(productId)) return;
    
    _lines[productId]!.qty -= 1;
    
    // Remove if quantity is 0 or less
    if (_lines[productId]!.qty <= 0) {
      _lines.remove(productId);
    }
    notifyListeners();
  }

  /// Remove a product completely from cart
  void remove(int productId) {
    _lines.remove(productId);
    notifyListeners();
  }

  /// Clear all items from cart
  void clear() {
    _lines.clear();
    notifyListeners();
  }

  /// Convert cart items to OrderItem list for order creation
  /// 
  /// Used when placing an order - creates a snapshot of current cart
  /// that will be stored with the order.
  List<OrderItem> toOrderItems() {
    return _lines.values.map((l) => OrderItem(
      productId: l.product.id,
      title: l.product.title,
      price: l.product.price,
      qty: l.qty,
      thumbnail: l.product.thumbnail,
    )).toList();
  }

  /// Load cart from a previous order (reorder feature)
  /// 
  /// [items] - List of OrderItems from a previous order
  /// 
  /// This clears the current cart and adds all items from the order.
  void loadFromOrder(List<OrderItem> items) {
    _lines.clear();
    
    for (final it in items) {
      // Recreate Product from OrderItem data
      final p = Product(
        id: it.productId, 
        title: it.title, 
        price: it.price, 
        thumbnail: it.thumbnail,
      );
      _lines[p.id] = CartLine(product: p, qty: it.qty);
    }
    notifyListeners();
  }
}
