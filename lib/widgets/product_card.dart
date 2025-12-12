/// ============================================================================
/// EasyGrocer - Product Card Widget
/// ============================================================================
/// A reusable card widget that displays a product with:
/// - Product image with hero animation support
/// - Product title and price
/// - Discount badge (optional)
/// - Add to cart button / quantity stepper
/// 
/// This is a core UI component used in the product grid on the home screen.
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:easygrocer/models/product.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';

/// ProductCard - Displays a product in a card format
/// 
/// Features:
/// - Compact, modern design optimized for grid layout
/// - Press animation feedback (scale effect)
/// - Discount badge when discountPercent is provided
/// - Hero animation support for smooth transitions to detail screen
/// - Two states: "Add" button or quantity stepper based on cart status
/// 
/// Parameters:
/// - [product]: The product to display
/// - [quantity]: Current quantity in cart (0 shows "Add" button)
/// - [onAdd]: Called when "Add" button is pressed
/// - [onIncrement]: Called when (+) button is pressed
/// - [onDecrement]: Called when (-) button is pressed
/// - [onTap]: Called when card is tapped (navigate to details)
/// - [discountPercent]: Optional discount to show as badge
class ProductCard extends StatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onTap;
  final double? discountPercent;

  const ProductCard({
    super.key,
    required this.product,
    this.quantity = 0,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    this.onTap,
    this.discountPercent,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Track press state for animation
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Calculate discount display
    final hasDiscount = widget.discountPercent != null && widget.discountPercent! > 0;
    final originalPrice = hasDiscount 
        ? widget.product.price / (1 - widget.discountPercent! / 100) 
        : widget.product.price;

    // GestureDetector handles tap events and tracks press state
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      
      // AnimatedScale provides subtle press feedback
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,  // Slightly smaller when pressed
        duration: const Duration(milliseconds: 100),
        
        // Card container with shadow
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          
          // Main card layout - image on top, info below
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== IMAGE SECTION ==========
              // Takes 60% of card height (flex: 3)
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Product Image with Hero for transitions
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),  // Light gray background
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          // Hero enables smooth image transition to detail screen
                          child: Hero(
                            tag: 'product-${widget.product.id}',
                            child: Image.network(
                              widget.product.thumbnail,
                              fit: BoxFit.contain,
                              // Fallback icon if image fails to load
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 32,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Discount Badge (top-left corner)
                    if (hasDiscount)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,  // Red background
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '-${widget.discountPercent!.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ========== INFO SECTION ==========
              // Takes 40% of card height (flex: 2)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Title (max 2 lines with ellipsis)
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Price Row (current price + strikethrough original)
                      Row(
                        children: [
                          Text(
                            '৳${widget.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          // Show original price if discounted
                          if (hasDiscount) ...[
                            const SizedBox(width: 4),
                            Text(
                              '৳${originalPrice.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Add Button or Quantity Stepper
                      _buildCartControl(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds either "Add" button or quantity stepper based on cart state
  Widget _buildCartControl() {
    // If quantity is 0, show "Add" button
    if (widget.quantity == 0) {
      return SizedBox(
        height: 32,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onAdd,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 16),
              SizedBox(width: 4),
              Text('Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    // If quantity > 0, show quantity stepper with +/- buttons
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrement button (-)
          _StepperBtn(
            icon: Icons.remove,
            onTap: widget.onDecrement,
          ),
          // Current quantity
          Text(
            '${widget.quantity}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          // Increment button (+) - highlighted as primary action
          _StepperBtn(
            icon: Icons.add,
            onTap: widget.onIncrement,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}

/// _StepperBtn - Small button used in quantity stepper
/// 
/// [icon]: The icon to display (+/-)
/// [onTap]: Action when tapped
/// [isPrimary]: If true, uses primary color background (for + button)
class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _StepperBtn({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
