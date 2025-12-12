/// ============================================================================
/// EasyGrocer - Color Palette (Design System)
/// ============================================================================
/// This file defines all colors used throughout the EasyGrocer app.
/// Having a centralized color palette ensures:
/// 1. Consistent branding across all screens
/// 2. Easy theming and maintenance
/// 3. Quick color changes without searching through code
/// 
/// Color philosophy:
/// - Primary Green: Represents freshness, health, growth (groceries)
/// - Secondary Orange: Energy, calls-to-action, warmth
/// - Accent Purple: Premium feel, trust indicators
/// ============================================================================

import 'package:flutter/material.dart';

/// AppColors - Centralized color definitions
/// 
/// Usage: AppColors.primary, AppColors.textPrimary, etc.
/// Private constructor prevents instantiation.
class AppColors {
  // Private constructor - this class has only static members
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  // Fresh Green - Main brand color
  // Used for: Primary buttons, highlights, success states, brand identity
  
  /// Main primary color - Fresh green representing health and freshness
  static const Color primary = Color(0xFF22C55E);
  
  /// Lighter shade for hover states and accents
  static const Color primaryLight = Color(0xFF4ADE80);
  
  /// Darker shade for pressed states
  static const Color primaryDark = Color(0xFF16A34A);
  
  /// Very light primary for backgrounds/containers
  static const Color primaryContainer = Color(0xFFDCFCE7);
  
  /// Text color to use on primaryContainer background
  static const Color onPrimaryContainer = Color(0xFF052E16);

  // ==================== SECONDARY COLORS ====================
  // Warm Orange - For CTAs and attention-grabbing elements
  
  /// Secondary color - Orange for energy and action
  static const Color secondary = Color(0xFFF97316);
  static const Color secondaryLight = Color(0xFFFB923C);
  static const Color secondaryDark = Color(0xFFEA580C);
  static const Color secondaryContainer = Color(0xFFFFEDD5);
  static const Color onSecondaryContainer = Color(0xFF431407);

  // ==================== ACCENT COLORS ====================
  // Rich Purple - For premium features and trust indicators
  
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentContainer = Color(0xFFEDE9FE);

  // ==================== NEUTRAL COLORS ====================
  // Basic colors for backgrounds, surfaces, and borders
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  /// App background color (slightly off-white)
  static const Color background = Color(0xFFF8FAFC);
  
  /// Surface color for cards and elevated elements
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Alternative surface for subtle differentiation
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  /// Border/divider color (light)
  static const Color outline = Color(0xFFE2E8F0);
  
  /// Border/divider color (slightly darker)
  static const Color outlineVariant = Color(0xFFCBD5E1);

  // ==================== TEXT COLORS ====================
  // Hierarchical text colors for visual hierarchy
  
  /// Primary text - highest emphasis (headings, important info)
  static const Color textPrimary = Color(0xFF0F172A);
  
  /// Secondary text - medium emphasis (body text)
  static const Color textSecondary = Color(0xFF475569);
  
  /// Tertiary text - lowest emphasis (hints, captions)
  static const Color textTertiary = Color(0xFF94A3B8);
  
  /// Text color on primary background
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  /// Text color on secondary background
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // ==================== SEMANTIC COLORS ====================
  // Colors that convey meaning (success, warning, error, info)
  
  /// Success - positive feedback, completed actions
  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFDCFCE7);
  
  /// Warning - caution, requires attention
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  /// Error - problems, destructive actions, discounts
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEE2E2);
  
  /// Info - informational messages
  static const Color info = Color(0xFF3B82F6);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ==================== GRADIENTS ====================
  // Pre-defined gradients for buttons, headers, and decorative elements
  
  /// Primary gradient for main CTAs
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary gradient for secondary actions
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient for premium features
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero gradient for header backgrounds
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle card gradient for depth
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== DARK MODE COLORS ====================
  // Colors for future dark mode support
  
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // ==================== ORDER STATUS COLORS ====================
  // Specific colors for order tracking status
  
  static const Color statusConfirmed = Color(0xFF3B82F6);      // Blue
  static const Color statusProcessing = Color(0xFFF59E0B);     // Yellow
  static const Color statusOutForDelivery = Color(0xFF8B5CF6); // Purple
  static const Color statusDelivered = Color(0xFF22C55E);      // Green

  // ==================== SPECIAL UI COLORS ====================
  
  /// Discount badge background
  static const Color discountBadge = Color(0xFFEF4444);
  static const Color discountBadgeText = Color(0xFFFFFFFF);
}
