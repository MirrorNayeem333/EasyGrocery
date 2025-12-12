import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/providers/orders_provider.dart';
import 'package:easygrocer/screens/order_details_screen.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';
import 'package:easygrocer/widgets/order_card.dart';

/// Premium orders screen with attractive design
class OrdersScreen extends StatelessWidget {
  final VoidCallback? onNavigateToShop;

  const OrdersScreen({super.key, this.onNavigateToShop});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();
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
                        '📦',
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'My Orders',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (orders.orders.isNotEmpty) ...[
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
                            '${orders.orders.length} orders',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Orders Content
          if (orders.orders.isEmpty)
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
                          child: Text('📦', style: TextStyle(fontSize: 56)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No orders yet',
                        style: AppTypography.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your order history will appear here',
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
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = orders.orders[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: OrderCard(
                        order: order,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        onReorder: () {
                          cart.loadFromOrder(order.items);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Text('✅', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: AppSpacing.sm),
                                  const Expanded(child: Text('Items added to cart')),
                                ],
                              ),
                              backgroundColor: AppColors.textPrimary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppSpacing.borderRadiusMd,
                              ),
                              action: SnackBarAction(
                                label: 'View Cart',
                                textColor: AppColors.primaryLight,
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: orders.orders.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
