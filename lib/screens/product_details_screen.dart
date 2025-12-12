import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/models/product.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';

/// Premium product details screen with hero animation
class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  late AnimationController _animController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final existingQty = cart.lines
        .where((l) => l.product.id == widget.product.id)
        .fold(0, (sum, l) => sum + l.qty);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: Container(
              margin: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border_rounded),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Container(
                  color: AppColors.surfaceVariant,
                  child: Image.network(
                    widget.product.thumbnail,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _animController.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusXl),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Text(
                        widget.product.title,
                        style: AppTypography.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Price and Stock
                      Row(
                        children: [
                          Text(
                            '৳${widget.product.price.toStringAsFixed(0)}',
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successContainer,
                              borderRadius: AppSpacing.borderRadiusFull,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 14,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'In Stock',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      const Divider(),
                      const SizedBox(height: AppSpacing.lg),

                      // Description
                      Text('About this product', style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Fresh, high-quality ${widget.product.title.toLowerCase()} sourced directly from trusted suppliers. '
                        'Perfect for your daily needs. Delivered fresh to your doorstep.',
                        style: AppTypography.bodyMedium,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Features
                      Row(
                        children: [
                          _FeatureChip(
                            icon: Icons.verified_rounded,
                            label: 'Quality Assured',
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _FeatureChip(
                            icon: Icons.local_shipping_rounded,
                            label: 'Fast Delivery',
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.lg),
                      const Divider(),
                      const SizedBox(height: AppSpacing.lg),

                      // Quantity Selector
                      Text('Quantity', style: AppTypography.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                  icon: const Icon(Icons.remove_rounded),
                                  color: AppColors.textSecondary,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: SizedBox(
                                    width: 40,
                                    child: Text(
                                      '$_quantity',
                                      key: ValueKey(_quantity),
                                      textAlign: TextAlign.center,
                                      style: AppTypography.titleMedium,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _quantity++),
                                  icon: const Icon(Icons.add_rounded),
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '৳${(widget.product.price * _quantity).toStringAsFixed(0)}',
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      if (existingQty > 0) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '$existingQty already in cart',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppSpacing.buttonHeightLg,
            child: ElevatedButton(
              onPressed: () {
                for (int i = 0; i < _quantity; i++) {
                  cart.add(widget.product);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text('Added $_quantity item(s) to cart'),
                        ),
                      ],
                    ),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: AppColors.secondaryLight,
                      onPressed: () {
                        Navigator.pop(context, 'goToCart');
                      },
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  const Text('Add to Cart'),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '• ৳${(widget.product.price * _quantity).toStringAsFixed(0)}',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall),
        ],
      ),
    );
  }
}
