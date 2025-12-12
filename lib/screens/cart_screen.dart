import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/screens/checkout_screen.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';
import 'package:easygrocer/widgets/cart_item_card.dart';
import 'package:easygrocer/widgets/empty_state.dart';

/// Premium cart screen with attractive design
class CartScreen extends StatelessWidget {
  final VoidCallback? onNavigateToShop;

  const CartScreen({super.key, this.onNavigateToShop});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: CustomScrollView(
        slivers: [
          // Gradient Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Text(
                        '🛒',
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'My Cart',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (cart.itemsCount > 0) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                          child: Text(
                            '${cart.itemsCount} items',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (cart.lines.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _showClearCartDialog(context, cart),
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white),
                          label: Text(
                            'Clear',
                            style: AppTypography.labelMedium.copyWith(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Cart Content
          if (cart.lines.isEmpty)
            SliverFillRemaining(
              child: Container(
                color: const Color(0xFFF0FDF4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('🛒', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Your cart is empty',
                        style: AppTypography.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Add some groceries to get started!',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton.icon(
                        onPressed: onNavigateToShop,
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text('Start Shopping'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                            vertical: AppSpacing.md,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Savings Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                  ),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Row(
                  children: [
                    const Text('💰', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You\'re saving ৳50 on delivery!',
                            style: AppTypography.titleSmall.copyWith(
                              color: const Color(0xFF92400E),
                            ),
                          ),
                          if (cart.total < 500)
                            Text(
                              'Add ৳${(500 - cart.total).toStringAsFixed(0)} more for FREE delivery',
                              style: AppTypography.bodySmall.copyWith(
                                color: const Color(0xFFB45309),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cart Items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = cart.lines[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: CartItemCard(
                        item: item,
                        onIncrement: () => cart.inc(item.product.id),
                        onDecrement: () => cart.dec(item.product.id),
                        onRemove: () => cart.remove(item.product.id),
                      ),
                    );
                  },
                  childCount: cart.lines.length,
                ),
              ),
            ),

            // Bottom padding for summary
            const SliverPadding(padding: EdgeInsets.only(bottom: 200)),
          ],
        ],
      ),
      // Cart Summary
      bottomSheet: cart.lines.isEmpty ? null : _CartSummary(cart: cart),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusXl),
        title: Row(
          children: [
            const Text('🗑️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: AppSpacing.sm),
            const Text('Clear Cart?'),
          ],
        ),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;

  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final deliveryFee = cart.total > 500 ? 0.0 : 50.0;
    final total = cart.total + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
            ),

            // Price Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: AppTypography.bodyMedium),
                Text('৳${cart.total.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery', style: AppTypography.bodyMedium),
                Text(
                  deliveryFee == 0 ? 'FREE' : '৳${deliveryFee.toStringAsFixed(0)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: deliveryFee == 0 ? AppColors.success : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTypography.titleMedium),
                Text(
                  '৳${total.toStringAsFixed(0)}',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_rounded, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Text(
                        '৳${total.toStringAsFixed(0)}',
                        style: AppTypography.labelMedium.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
