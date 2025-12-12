/// ============================================================================
/// EasyGrocer - Orders Provider
/// ============================================================================
/// This provider manages order history and delivery address.
/// It persists orders to SharedPreferences for local storage.
/// 
/// Uses the Provider pattern (ChangeNotifier) for state management.
/// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easygrocer/models/order.dart';

/// OrdersProvider - Manages order history and delivery settings
/// 
/// Features:
/// - Store and retrieve order history
/// - Manage delivery address
/// - Persist data to SharedPreferences
/// - Limit order history to last 30 orders
/// 
/// Usage:
/// ```dart
/// // Get order history
/// final orders = context.watch<OrdersProvider>().orders;
/// 
/// // Add new order
/// await context.read<OrdersProvider>().addOrder(newOrder);
/// 
/// // Update delivery address
/// await context.read<OrdersProvider>().setAddress('New Address');
/// ```
class OrdersProvider extends ChangeNotifier {
  // SharedPreferences keys
  static const _kOrders = 'orders';    // Key for order history JSON
  static const _kAddress = 'address';  // Key for delivery address

  // Private state
  bool _ready = false;                          // Initialization complete
  List<OrderModel> _orders = [];                // Order history list
  String _address = 'Dhanmondi, Dhaka';         // Default delivery address

  // Public getters
  
  /// Whether the provider has finished loading from storage
  bool get ready => _ready;
  
  /// List of past orders (newest first)
  List<OrderModel> get orders => _orders;
  
  /// Current delivery address
  String get address => _address;

  /// Initialize by loading saved data from SharedPreferences
  /// 
  /// Called when app starts. Loads:
  /// - Saved delivery address
  /// - Order history (decoded from JSON)
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    
    // Load saved address or use default
    _address = sp.getString(_kAddress) ?? _address;

    // Load and decode order history
    final raw = sp.getString(_kOrders);
    if (raw != null && raw.isNotEmpty) {
      _orders = OrderModel.decodeList(raw);
    }
    
    _ready = true;
    notifyListeners();
  }

  /// Update the delivery address
  /// 
  /// [address] - New delivery address
  /// 
  /// If the address is empty, keeps the current address.
  /// Saves to SharedPreferences for persistence.
  Future<void> setAddress(String address) async {
    final sp = await SharedPreferences.getInstance();
    
    // Don't allow empty address
    _address = address.trim().isEmpty ? _address : address.trim();
    
    await sp.setString(_kAddress, _address);
    notifyListeners();
  }

  /// Add a new order to the history
  /// 
  /// [order] - The order to add
  /// 
  /// Orders are stored newest first.
  /// Only the last 30 orders are kept to manage storage.
  /// Saves to SharedPreferences as JSON.
  Future<void> addOrder(OrderModel order) async {
    // Add new order to the beginning, keep max 30 orders
    _orders = [order, ..._orders].take(30).toList();
    
    // Persist to storage
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kOrders, OrderModel.encodeList(_orders));
    
    notifyListeners();
  }
}
