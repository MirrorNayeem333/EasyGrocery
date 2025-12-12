import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/providers/orders_provider.dart';
import 'package:easygrocer/models/order.dart';
import 'package:easygrocer/screens/order_details_screen.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';

/// Premium checkout screen with step indicators and payment selection
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  String _payment = 'Cash on Delivery';
  bool _isLoading = false;

  final _paymentMethods = [
    ('Cash on Delivery', Icons.money_rounded, 'Pay when you receive'),
    ('Credit/Debit Card', Icons.credit_card_rounded, 'Visa, Mastercard, etc.'),
    ('Mobile Banking', Icons.phone_android_rounded, 'bKash, Nagad, Rocket'),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orders = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          // Step Indicator
          _StepIndicator(currentStep: _step),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Delivery Address Card
                  _SectionCard(
                    title: 'Delivery Address',
                    icon: Icons.location_on_rounded,
                    trailing: TextButton(
                      onPressed: () => _editAddress(orders),
                      child: const Text('Change'),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            orders.address,
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Payment Method Card
                  _SectionCard(
                    title: 'Payment Method',
                    icon: Icons.payment_rounded,
                    child: Column(
                      children: _paymentMethods.map((method) {
                        final (name, icon, subtitle) = method;
                        final isSelected = _payment == name;
                        return _PaymentOption(
                          name: name,
                          icon: icon,
                          subtitle: subtitle,
                          isSelected: isSelected,
                          onTap: () => setState(() => _payment = name),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Order Summary Card
                  _SectionCard(
                    title: 'Order Summary',
                    icon: Icons.receipt_long_rounded,
                    child: Column(
                      children: [
                        ...cart.lines.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: AppSpacing.borderRadiusSm,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: AppSpacing.borderRadiusSm,
                                      child: Image.network(
                                        item.product.thumbnail,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.image_outlined,
                                          size: 16,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.title,
                                          style: AppTypography.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'x${item.qty}',
                                          style: AppTypography.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '৳${(item.qty * item.product.price).toStringAsFixed(0)}',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            )),
                        const Divider(),
                        _PriceRow(label: 'Subtotal', value: cart.total),
                        const SizedBox(height: AppSpacing.xs),
                        _PriceRow(
                          label: 'Delivery',
                          value: cart.total > 500 ? 0 : 50,
                          valueText: cart.total > 500 ? 'FREE' : null,
                          valueColor: cart.total > 500 ? AppColors.success : null,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: AppTypography.titleMedium),
                            Text(
                              '৳${(cart.total + (cart.total > 500 ? 0 : 50)).toStringAsFixed(0)}',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.primary,
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
          ),

          // Place Order Button
          Container(
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
                width: double.infinity,
                height: AppSpacing.buttonHeightLg,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _placeOrder(cart, orders),
                  child: _isLoading
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
                            const Icon(Icons.check_circle_rounded, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            const Text('Place Order'),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '• ৳${(cart.total + (cart.total > 500 ? 0 : 50)).toStringAsFixed(0)}',
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
        ],
      ),
    );
  }

  Future<void> _placeOrder(CartProvider cart, OrdersProvider orders) async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      final id = const Uuid().v4().split('-').first.toUpperCase();
      final order = OrderModel(
        id: id,
        createdAt: DateTime.now(),
        address: orders.address,
        items: cart.toOrderItems(),
        total: cart.total + (cart.total > 500 ? 0 : 50),
      );
      await orders.addOrder(order);
      cart.clear();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editAddress(OrdersProvider orders) async {
    final controller = TextEditingController(text: orders.address);
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Delivery Address', style: AppTypography.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter your delivery address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      await orders.setAddress(result);
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Address', 'Payment', 'Confirm'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: index ~/ 2 < currentStep
                    ? AppColors.primary
                    : AppColors.outline,
              ),
            );
          }
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isActive
                  ? Icon(
                      stepIndex < currentStep
                          ? Icons.check_rounded
                          : Icons.circle,
                      color: AppColors.white,
                      size: stepIndex < currentStep ? 16 : 8,
                    )
                  : Text(
                      '${stepIndex + 1}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTypography.titleSmall),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String name;
  final IconData icon;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.titleSmall),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
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
  final String? valueText;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueText,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall),
        Text(
          valueText ?? '৳${value.toStringAsFixed(0)}',
          style: AppTypography.bodySmall.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
