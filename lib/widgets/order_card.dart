import 'package:flutter/material.dart';
import 'package:easygrocer/models/order.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';
import 'package:intl/intl.dart';

/// Premium order card with status indicator, thumbnails, and actions
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback onReorder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onReorder,
  });

  String get _status {
    final secs = DateTime.now().difference(order.createdAt).inSeconds;
    if (secs < 60) return 'Confirmed';
    if (secs < 300) return 'Processing';
    if (secs < 600) return 'Out for Delivery';
    return 'Delivered';
  }

  String get _statusEmoji {
    switch (_status) {
      case 'Confirmed':
        return '✅';
      case 'Processing':
        return '📦';
      case 'Out for Delivery':
        return '🚚';
      case 'Delivered':
        return '🎉';
      default:
        return '⏳';
    }
  }

  Color get _statusColor {
    switch (_status) {
      case 'Confirmed':
        return const Color(0xFF3B82F6);
      case 'Processing':
        return const Color(0xFFF59E0B);
      case 'Out for Delivery':
        return const Color(0xFF8B5CF6);
      case 'Delivered':
        return const Color(0xFF22C55E);
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.borderRadiusLg,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with Status
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Text(_statusEmoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: AppTypography.titleSmall,
                        ),
                        Text(
                          dateFormat.format(order.createdAt),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.15),
                      borderRadius: AppSpacing.borderRadiusFull,
                      border: Border.all(color: _statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      _status,
                      style: AppTypography.labelSmall.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // Item Thumbnails Row
                  Row(
                    children: [
                      // Thumbnails
                      Expanded(
                        child: Row(
                          children: [
                            ...order.items.take(3).map((item) => Container(
                                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: AppSpacing.borderRadiusSm,
                                    border: Border.all(color: AppColors.outline),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: AppSpacing.borderRadiusSm,
                                    child: Image.network(
                                      item.thumbnail,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image_outlined,
                                        size: 20,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                  ),
                                )),
                            if (order.items.length > 3)
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryContainer,
                                      AppColors.primaryContainer.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: AppSpacing.borderRadiusSm,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '+${order.items.length - 3}',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Total
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${order.items.length} items',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            '৳${order.total.toStringAsFixed(0)}',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReorder,
                          icon: const Text('🔄', style: TextStyle(fontSize: 16)),
                          label: const Text('Reorder'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onTap,
                          icon: const Text('👁️', style: TextStyle(fontSize: 16)),
                          label: const Text('View'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
