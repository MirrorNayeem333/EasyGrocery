/// ============================================================================
/// EasyGrocer - Authentication Provider
/// ============================================================================
/// This provider manages user authentication state for the app.
/// It handles login, logout, and persistence of auth state using SharedPreferences.
/// 
/// Uses the Provider pattern (ChangeNotifier) for state management.
/// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AuthProvider - Manages user authentication state
/// 
/// This provider:
/// 1. Tracks if user is logged in
/// 2. Stores user email
/// 3. Persists auth state to SharedPreferences
/// 4. Notifies listeners when state changes
/// 
/// Usage:
/// ```dart
/// // Access in widget
/// final auth = context.watch<AuthProvider>();
/// if (auth.loggedIn) { /* show home */ }
/// 
/// // Login
/// await context.read<AuthProvider>().login('user@email.com');
/// 
/// // Logout
/// await context.read<AuthProvider>().logout();
/// ```
class AuthProvider extends ChangeNotifier {
  // SharedPreferences keys for persistent storage
  static const _kLoggedIn = 'loggedIn';  // Key for login status
  static const _kEmail = 'email';         // Key for user email

  // Private state variables
  bool _ready = false;     // True when initialization is complete
  bool _loggedIn = false;  // True if user is logged in
  String _email = '';      // User's email address

  // Public getters - expose state to widgets
  
  /// Whether the provider has finished loading from storage
  bool get ready => _ready;
  
  /// Whether the user is currently logged in
  bool get loggedIn => _loggedIn;
  
  /// The logged-in user's email address
  String get email => _email;

  /// Initialize the provider by loading saved auth state
  /// 
  /// This should be called when the app starts.
  /// Loads login status and email from SharedPreferences.
  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    
    // Load saved values, use defaults if not found
    _loggedIn = sp.getBool(_kLoggedIn) ?? false;
    _email = sp.getString(_kEmail) ?? '';
    
    // Mark as ready and notify listeners to rebuild UI
    _ready = true;
    notifyListeners();
  }

  /// Log in a user with the given email
  /// 
  /// [email] - The user's email address
  /// 
  /// This saves the login state to SharedPreferences so the user
  /// stays logged in even after closing the app.
  Future<void> login(String email) async {
    final sp = await SharedPreferences.getInstance();
    
    // Save to persistent storage
    await sp.setBool(_kLoggedIn, true);
    await sp.setString(_kEmail, email.trim());
    
    // Update local state
    _loggedIn = true;
    _email = email.trim();
    
    // Notify widgets to rebuild
    notifyListeners();
  }

  /// Log out the current user
  /// 
  /// Clears the login status from SharedPreferences.
  /// Email is kept for convenience (pre-fill on next login).
  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    
    // Clear login status
    await sp.setBool(_kLoggedIn, false);
    _loggedIn = false;
    
    // Notify widgets to rebuild (will show login screen)
    notifyListeners();
  }
}
