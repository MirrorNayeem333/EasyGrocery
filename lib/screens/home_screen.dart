import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easygrocer/providers/auth_provider.dart';
import 'package:easygrocer/providers/orders_provider.dart';
import 'package:easygrocer/providers/cart_provider.dart';
import 'package:easygrocer/services/api_service.dart';
import 'package:easygrocer/models/product.dart';
import 'package:easygrocer/screens/cart_screen.dart';
import 'package:easygrocer/screens/orders_screen.dart';
import 'package:easygrocer/screens/product_details_screen.dart';
import 'package:easygrocer/theme/app_colors.dart';
import 'package:easygrocer/theme/app_spacing.dart';
import 'package:easygrocer/theme/app_typography.dart';
import 'package:easygrocer/widgets/product_card.dart';
import 'package:easygrocer/widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _api = ApiService();
  final _search = TextEditingController();
  int _tab = 0;
  String? _selectedCategory;
  List<Product>? _products;
  bool _isLoading = true;
  String? _error;

  final _categories = [
    {'name': 'All', 'icon': '🛒', 'color': const Color(0xFF22C55E)},
    {'name': 'Snacks', 'icon': '🍿', 'color': const Color(0xFFF97316)},
    {'name': 'Breakfast', 'icon': '🥐', 'color': const Color(0xFF3B82F6)},
    {'name': 'Drinks', 'icon': '🥤', 'color': const Color(0xFFEC4899)},
    {'name': 'Fruits', 'icon': '🍎', 'color': const Color(0xFFEF4444)},
    {'name': 'Vegetables', 'icon': '🥬', 'color': const Color(0xFF22C55E)},
    {'name': 'Dairy', 'icon': '🥛', 'color': const Color(0xFFF59E0B)},
    {'name': 'Meat', 'icon': '🥩', 'color': const Color(0xFFDC2626)},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await _api.fetchProducts(query: _search.text.trim());
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orders = context.watch<OrdersProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4), // Light green background
      body: IndexedStack(
        index: _tab,
        children: [
          _buildShopTab(cart, orders),
          CartScreen(onNavigateToShop: () => setState(() => _tab = 0)),
          OrdersScreen(onNavigateToShop: () => setState(() => _tab = 0)),
          _buildProfileTab(auth),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(cart),
    );
  }

  Widget _buildShopTab(CartProvider cart, OrdersProvider orders) {
    return CustomScrollView(
      slivers: [
        // Custom App Bar with gradient
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
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Location
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showAddressDialog(orders),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orders.address,
                                        style: AppTypography.titleSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Your location',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Cart Badge
                        GestureDetector(
                          onTap: () => setState(() => _tab = 1),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: AppSpacing.borderRadiusMd,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                if (cart.itemsCount > 0)
                                  Positioned(
                                    top: -8,
                                    right: -8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${cart.itemsCount}',
                                        style: AppTypography.badge,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppSpacing.borderRadiusMd,
                        boxShadow: AppSpacing.shadowMd,
                      ),
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: 'Search for groceries...',
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiary),
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                        ),
                        onSubmitted: (_) => _loadProducts(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Promotional Banner - Yellow/Gold Style
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFCD34D), Color(0xFFF59E0B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Decorative shapes
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: -40,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                // Grocery emojis on the right
                const Positioned(
                  right: 20,
                  top: 15,
                  child: Text('🥕', style: TextStyle(fontSize: 32)),
                ),
                const Positioned(
                  right: 60,
                  top: 8,
                  child: Text('🍎', style: TextStyle(fontSize: 28)),
                ),
                const Positioned(
                  right: 10,
                  top: 55,
                  child: Text('🥦', style: TextStyle(fontSize: 36)),
                ),
                const Positioned(
                  right: 55,
                  bottom: 10,
                  child: Text('🍊', style: TextStyle(fontSize: 30)),
                ),
                const Positioned(
                  right: 100,
                  top: 25,
                  child: Text('🥬', style: TextStyle(fontSize: 26)),
                ),
                const Positioned(
                  right: 95,
                  bottom: 20,
                  child: Text('🍇', style: TextStyle(fontSize: 24)),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LIMITED TIME ONLY tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LIMITED TIME ONLY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB45309),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Extra 15% OFF text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            'Extra ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF78350F),
                            ),
                          ),
                          const Text(
                            '15%',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF78350F),
                            ),
                          ),
                          const Text(
                            ' OFF',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Fresh Groceries',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF78350F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Start Saving Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Start Saving',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Categories Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories', style: AppTypography.titleLarge),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
        ),

        // Category Grid
        SliverToBoxAdapter(
          child: SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'] ||
                    (_selectedCategory == null && category['name'] == 'All');
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? (category['color'] as Color).withOpacity(0.15)
                          : Colors.white,
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(
                        color: isSelected 
                            ? category['color'] as Color
                            : AppColors.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: (category['color'] as Color).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['icon'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          category['name'] as String,
                          style: AppTypography.labelSmall.copyWith(
                            color: isSelected 
                                ? category['color'] as Color
                                : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

        // Section Header - shows category name when filtered
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Text(
                        _selectedCategory == null || _selectedCategory == 'All' 
                            ? '🔥' 
                            : _getCategoryEmoji(_selectedCategory!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _selectedCategory == null || _selectedCategory == 'All'
                          ? 'Popular'
                          : _selectedCategory!,
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: AppSpacing.borderRadiusFull,
                      ),
                      child: Text(
                        '${_getFilteredProducts().length} items',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedCategory != null && _selectedCategory != 'All')
                  TextButton(
                    onPressed: () => setState(() => _selectedCategory = null),
                    child: const Text('Clear'),
                  )
                else
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

        // Products Grid
        _buildProductsGrid(cart),

        // Bottom Padding
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildProductsGrid(CartProvider cart) {
    if (_isLoading) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => const ProductCardSkeleton(),
            childCount: 6,
          ),
        ),
      );
    }

    if (_error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Something went wrong', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final products = _products ?? [];
    if (products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: AppSpacing.md),
              Text('No products found', style: AppTypography.titleMedium),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final filteredProducts = _getFilteredProducts();
            if (index >= filteredProducts.length) return null;
            
            final product = filteredProducts[index];
            final cartQty = cart.lines
                .where((l) => l.product.id == product.id)
                .fold(0, (sum, l) => sum + l.qty);
            
            // Random discount for demo
            final hasDiscount = index % 3 == 0;
            final discount = hasDiscount ? (10 + (index % 4) * 5).toDouble() : null;

            return ProductCard(
              product: product,
              quantity: cartQty,
              discountPercent: discount,
              onAdd: () => cart.add(product),
              onIncrement: () => cart.inc(product.id),
              onDecrement: () => cart.dec(product.id),
              onTap: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product),
                  ),
                );
                if (result == 'goToCart' && mounted) {
                  setState(() => _tab = 1);
                }
              },
            );
          },
          childCount: _getFilteredProducts().length,
        ),
      ),
    );
  }

  List<Product> _getFilteredProducts() {
    final products = _products ?? [];
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return products;
    }
    
    // Map category names to keywords for filtering
    final categoryKeywords = {
      'Snacks': ['snack', 'chips', 'cookie', 'biscuit', 'candy', 'chocolate', 'popcorn', 'crisp'],
      'Breakfast': ['cereal', 'oat', 'bread', 'pancake', 'waffle', 'toast'],
      'Drinks': ['drink', 'juice', 'soda', 'water', 'coffee', 'tea', 'beverage', 'cola', 'sprite', 'pepsi'],
      'Fruits': ['fruit', 'apple', 'banana', 'orange', 'grape', 'berry', 'mango', 'melon', 'pear', 'kiwi'],
      'Vegetables': ['vegetable', 'carrot', 'tomato', 'potato', 'onion', 'lettuce', 'spinach', 'broccoli', 'cabbage'],
      'Dairy': ['dairy', 'cheese', 'yogurt', 'butter', 'cream', 'curd'],
      'Meat': ['meat', 'chicken', 'beef', 'pork', 'fish', 'salmon', 'lamb', 'turkey', 'steak', 'mutton', 'prawn', 'shrimp'],
    };

    // Keywords to exclude from each category to prevent wrong matches
    final excludeKeywords = {
      'Drinks': ['meat', 'fish', 'chicken', 'beef', 'pork', 'salmon', 'steak', 'lamb', 'cookie', 'chocolate', 'biscuit', 'chips', 'popcorn', 'candy', 'crisp', 'snack'],
      'Breakfast': ['meat', 'fish', 'chicken', 'beef', 'pork', 'salmon', 'steak', 'cookie', 'chocolate', 'chips'],
      'Snacks': ['meat', 'fish', 'salmon', 'steak', 'juice', 'coffee', 'tea', 'soda', 'water'],
      'Dairy': ['meat', 'fish', 'chicken', 'beef', 'salmon', 'steak', 'cookie', 'chocolate'],
      'Fruits': ['meat', 'fish', 'chicken', 'beef', 'salmon', 'steak', 'juice', 'chips'],
      'Vegetables': ['meat', 'fish', 'chicken', 'beef', 'salmon', 'steak', 'juice'],
      'Meat': ['juice', 'coffee', 'tea', 'cookie', 'chocolate', 'chips', 'milk', 'cheese'],
    };
    
    final keywords = categoryKeywords[_selectedCategory] ?? [];
    final excludes = excludeKeywords[_selectedCategory] ?? [];
    if (keywords.isEmpty) return products;
    
    return products.where((p) {
      final title = p.title.toLowerCase();
      // Check if any exclude keyword matches
      if (excludes.any((ex) => title.contains(ex))) {
        return false;
      }
      // Check if any include keyword matches
      return keywords.any((keyword) => title.contains(keyword));
    }).toList();
  }

  String _getCategoryEmoji(String category) {
    final emojiMap = {
      'All': '🛒',
      'Snacks': '🍿',
      'Breakfast': '🥐',
      'Drinks': '🥤',
      'Fruits': '🍎',
      'Vegetables': '🥬',
      'Dairy': '🥛',
      'Meat': '🥩',
    };
    return emojiMap[category] ?? '📦';
  }

  Widget _buildProfileTab(AuthProvider auth) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF0FDF4), Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(auth.email, style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.xxl),
              _ProfileOption(
                icon: Icons.receipt_long_rounded,
                label: 'My Orders',
                onTap: () => setState(() => _tab = 2),
              ),
              _ProfileOption(
                icon: Icons.location_on_rounded,
                label: 'Delivery Address',
                onTap: () => _showAddressDialog(context.read<OrdersProvider>()),
              ),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: () {},
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => auth.logout(),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(CartProvider cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _tab == 0,
                onTap: () => setState(() => _tab = 0),
              ),
              _NavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'Cart',
                isSelected: _tab == 1,
                badge: cart.itemsCount > 0 ? cart.itemsCount : null,
                onTap: () => setState(() => _tab = 1),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                isSelected: _tab == 2,
                onTap: () => setState(() => _tab = 2),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: _tab == 3,
                onTap: () => setState(() => _tab = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddressDialog(OrdersProvider orders) async {
    final controller = TextEditingController(text: orders.address);
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('📍 Delivery Address', style: AppTypography.titleLarge),
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  size: 24,
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$badge',
                      style: AppTypography.badge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.shadowSm,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: AppTypography.bodyLarge),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
