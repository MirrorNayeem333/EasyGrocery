/// ============================================================================
/// EasyGrocer - Authentication Screen
/// ============================================================================
/// This is the login screen for the EasyGrocer app.
/// Features:
/// - Beautiful gradient background
/// - Glassmorphic login card design
/// - Slide-up animation on load
/// - Email validation
/// - Loading state handling
/// 
/// The screen uses Provider to access AuthProvider for login functionality.
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/providers/auth_provider.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';

/// AuthScreen - Login interface for user authentication
/// 
/// This screen displays when the user is not logged in.
/// After successful login, main.dart's _Gate widget automatically
/// navigates to HomeScreen.
/// 
/// Design features:
/// - Gradient background (green → cyan → purple)
/// - Animated slide-up entrance
/// - Frosted glass effect on login card
/// - Form validation for email
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers and state
  final _email = TextEditingController();      // Email input controller
  final _formKey = GlobalKey<FormState>();     // Form key for validation
  bool _isLoading = false;                     // Loading state for button
  
  // Animation controllers
  late AnimationController _animController;
  late Animation<double> _slideAnimation;      // Slide up animation
  late Animation<double> _fadeAnimation;       // Fade in animation

  @override
  void initState() {
    super.initState();
    
    // Configure animation controller
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,  // Uses this widget as ticker provider
    );
    
    // Slide animation: starts 50px below, ends at normal position
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    
    // Fade animation: starts invisible, ends fully visible
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    
    // Start the animation when screen loads
    _animController.forward();
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _email.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Handle login button press
  /// 
  /// 1. Validates the form
  /// 2. Shows loading indicator
  /// 3. Calls AuthProvider.login()
  /// 4. On success, _Gate widget redirects to HomeScreen
  Future<void> _handleLogin() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) return;

    // Show loading state
    setState(() => _isLoading = true);
    
    try {
      // Perform login via provider
      await context.read<AuthProvider>().login(_email.text);
      // Note: No navigation needed - _Gate handles it automatically
    } finally {
      // Hide loading state if still mounted
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ==== GRADIENT BACKGROUND ====
        // Multi-color gradient for visual appeal
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,    // Green
              Color(0xFF06B6D4),    // Cyan
              AppColors.accent,     // Purple
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              
              // ==== ANIMATED CONTENT ====
              // Uses AnimatedBuilder for slide + fade effect
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    ),
                  );
                },
                
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==== LOGO SECTION ====
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppSpacing.borderRadiusXl,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_basket_rounded,
                        size: 44,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ==== WELCOME TEXT ====
                    Text(
                      'Welcome to',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      'EasyGrocer',
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ==== LOGIN CARD (GLASSMORPHISM) ====
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.95),
                        borderRadius: AppSpacing.borderRadiusXl,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      
                      // Form widget for validation
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign in to continue',
                              style: AppTypography.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // ==== EMAIL INPUT FIELD ====
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'your@email.com',
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: AppColors.surfaceVariant,
                                border: OutlineInputBorder(
                                  borderRadius: AppSpacing.borderRadiusMd,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              // Validation logic
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;  // Valid
                              },
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            // ==== SIGN IN BUTTON ====
                            SizedBox(
                              height: AppSpacing.buttonHeightLg,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                child: _isLoading
                                    // Loading indicator
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white,
                                        ),
                                      )
                                    // Normal button content
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Continue'),
                                          SizedBox(width: AppSpacing.sm),
                                          Icon(Icons.arrow_forward_rounded, size: 20),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // ==== FOOTER TEXT ====
                    Text(
                      'Get fresh groceries delivered\nto your doorstep in minutes',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}