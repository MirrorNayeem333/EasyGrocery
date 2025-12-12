/// ============================================================================
/// EasyGrocer - Order Models
/// ============================================================================
/// This file defines the data models for orders in the app:
/// 1. OrderItem - Individual item within an order
/// 2. OrderModel - Complete order with delivery and payment info
/// 
/// These models support JSON serialization for local storage persistence.
/// ============================================================================

import 'dart:convert';

/// OrderItem - Represents a single item within an order
/// 
/// When a user places an order, each product in their cart becomes an OrderItem.
/// This stores a snapshot of the product at the time of purchase.
/// 
/// Properties:
/// - [productId]: Reference to the original product
/// - [title]: Product name at time of purchase
/// - [price]: Price per unit at time of purchase
/// - [qty]: Quantity ordered
/// - [thumbnail]: Product image URL
class OrderItem {
  final int productId;
  final String title;
  final double price;
  final int qty;
  final String thumbnail;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.qty,
    required this.thumbnail,
  });

  /// Convert OrderItem to JSON for storage
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'title': title,
    'price': price,
    'qty': qty,
    'thumbnail': thumbnail,
  };

  /// Create OrderItem from JSON data
  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
    productId: j['productId'] as int,
    title: j['title'] as String,
    price: (j['price'] as num).toDouble(),
    qty: j['qty'] as int,
    thumbnail: j['thumbnail'] as String,
  );
}

/// OrderModel - Represents a complete customer order
/// 
/// This model contains all information about a placed order:
/// - Order identification
/// - Timestamp
/// - Delivery address
/// - List of items ordered
/// - Total cost
/// 
/// Orders are persisted to SharedPreferences using JSON encoding.
class OrderModel {
  /// Unique order ID (UUID format)
  final String id;
  
  /// When the order was placed
  final DateTime createdAt;
  
  /// Delivery address for the order
  final String address;
  
  /// List of items in this order
  final List<OrderItem> items;
  
  /// Total cost of the order
  final double total;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.address,
    required this.items,
    required this.total,
  });

  /// Convert OrderModel to JSON for storage
  /// DateTime is converted to ISO 8601 string format
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'address': address,
    'items': items.map((e) => e.toJson()).toList(),
    'total': total,
  };

  /// Create OrderModel from JSON data
  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
    id: j['id'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    address: j['address'] as String,
    items: (j['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
    total: (j['total'] as num).toDouble(),
  );

  /// Encode a list of orders to JSON string for storage
  /// Used by OrdersProvider to save orders to SharedPreferences
  static String encodeList(List<OrderModel> orders) =>
      jsonEncode(orders.map((o) => o.toJson()).toList());

  /// Decode a JSON string back to a list of OrderModel objects
  /// Used by OrdersProvider to load orders from SharedPreferences
  static List<OrderModel> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => OrderModel.fromJson(e)).toList();
  }
}
