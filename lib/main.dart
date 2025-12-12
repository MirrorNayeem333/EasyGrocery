/// ============================================================================
/// EasyGrocer - Main Application Entry Point
/// ============================================================================
/// This is the main entry point for the EasyGrocer grocery shopping app.
/// It initializes the app, sets up state management providers, and handles
/// the initial routing based on authentication status.
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/providers/auth_provider.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/providers/orders_provider.dart';
import 'package:easygrocer/screens/splash_screen.dart';
import 'package:easygrocer/screens/auth_screen.dart';
import 'package:easygrocer/screens/home_screen.dart';
import 'package:easygrocer/theme/theme.dart';

/// Main function - Application entry point
/// This is called when the app starts. It:
/// 1. Ensures Flutter bindings are initialized
/// 2. Configures the system UI (status bar appearance)
/// 3. Runs the main app widget
void main() {
  // Ensure Flutter engine is ready before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure status bar to be transparent with dark icons
  // This provides a more immersive UI experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Start the application
  runApp(const EasyGrocerApp());
}

/// EasyGrocerApp - Root Widget of the Application
/// 
/// This widget sets up:
/// 1. MultiProvider - For state management using Provider pattern
/// 2. MaterialApp - The root Material Design app configuration
/// 3. Theme - Custom app theme for consistent styling
class EasyGrocerApp extends StatelessWidget {
  const EasyGrocerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider wraps the app with all our state management providers
    // This makes state accessible throughout the widget tree
    return MultiProvider(
      providers: [
        // AuthProvider - Handles user authentication (login/logout)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // CartProvider - Manages shopping cart items
        ChangeNotifierProvider(create: (_) => CartProvider()),
        
        // OrdersProvider - Manages order history and delivery address
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        // Disable the debug banner in the top-right corner
        debugShowCheckedModeBanner: false,
        
        // App title shown in task switcher
        title: 'EasyGrocer',
        
        // Apply our custom Material 3 theme
        theme: AppTheme.lightTheme,
        
        // Start with the Gate widget which handles initial routing
        home: const _Gate(),
      ),
    );
  }
}

/// _Gate - Navigation Gate Widget
/// 
/// This private widget acts as a "gate" that determines which screen to show:
/// 1. SplashScreen - While app is initializing (loading saved data)
/// 2. AuthScreen - If user is not logged in
/// 3. HomeScreen - If user is logged in and ready
/// 
/// This pattern separates initialization logic from UI rendering.
class _Gate extends StatefulWidget {
  const _Gate();

  @override
  State<_Gate> createState() => _GateState();
}

class _GateState extends State<_Gate> {
  // Flag to prevent multiple initializations
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Only run initialization once
    if (_started) return;
    _started = true;
    
    // Start async initialization
    _init();
  }

  /// Initialize the app by loading saved data from storage
  /// Uses Future.wait to load auth and orders data in parallel
  Future<void> _init() async {
    // Get references to providers
    final auth = context.read<AuthProvider>();
    final orders = context.read<OrdersProvider>();

    // Load saved data from SharedPreferences concurrently
    // This is more efficient than loading sequentially
    await Future.wait([auth.init(), orders.init()]);
    
    // Trigger a rebuild to show the appropriate screen
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers for changes to trigger rebuilds
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrdersProvider>();

    // Show splash screen while loading
    if (!auth.ready || !orders.ready) return const SplashScreen();
    
    // Show login screen if not authenticated
    if (!auth.loggedIn) return const AuthScreen();
    
    // Show main app if logged in
    return const HomeScreen();
  }
}
