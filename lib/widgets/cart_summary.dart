import 'package:flutter/material.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';

/// Sticky cart summary with glassmorphism effect and checkout button
class CartSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final VoidCallback onCheckout;
  final bool isLoading;

  const CartSummary({
    super.key,
    required this.subtotal,
    this.deliveryFee = 50,
    this.discount = 0,
    required this.onCheckout,
    this.isLoading = false,
  });

  double get total => subtotal + deliveryFee - discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
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
            _PriceRow(label: 'Subtotal', value: subtotal),
            const SizedBox(height: AppSpacing.sm),
            _PriceRow(
              label: 'Delivery Fee',
              value: deliveryFee,
              valueColor: deliveryFee == 0 ? AppColors.success : null,
              valueText: deliveryFee == 0 ? 'FREE' : null,
            ),
            if (discount > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _PriceRow(
                label: 'Discount',
                value: -discount,
                valueColor: AppColors.success,
                prefix: '-',
              ),
            ],

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.outline.withOpacity(0),
                      AppColors.outline,
                      AppColors.outline.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),

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
              height: AppSpacing.buttonHeightLg,
              child: ElevatedButton(
                onPressed: isLoading ? null : onCheckout,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Proceed to Checkout',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final String? valueText;
  final String prefix;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueText,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(
          valueText ?? '$prefix৳${value.abs().toStringAsFixed(0)}',
          style: AppTypography.bodyMedium.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
