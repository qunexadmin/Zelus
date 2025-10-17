import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

/// Retail Tab - AI-Powered Product Discovery
/// Users can discover, track, and save beauty/hair products
class RetailTab extends ConsumerStatefulWidget {
  const RetailTab({super.key});

  @override
  ConsumerState<RetailTab> createState() => _RetailTabState();
}

class _RetailTabState extends ConsumerState<RetailTab> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _selectedCategory = 'All';
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Hair Care',
    'Styling',
    'Tools',
    'Color Care',
    'Treatments',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;
    
    HapticFeedback.lightImpact();
    setState(() => _isSearching = true);

    // Simulate AI search
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isSearching = false);
        // Show search results
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Sticky Header
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                floating: false,
                expandedHeight: 0,
                toolbarHeight: 70,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Retail',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          letterSpacing: -1.2,
                        ),
                      ),
                      // Notifications icon for price alerts
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryColor),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // Show price alerts
                              },
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.errorColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Scrollable Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // AI-Powered Search
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _handleSearch,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search products with AI...',
                            hintStyle: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            prefixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppTheme.accentColor,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.search,
                                      color: AppTheme.accentColor,
                                      size: 22,
                                    ),
                                  ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    color: AppTheme.textSecondary,
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category Filters
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              backgroundColor: AppTheme.surfaceColor,
                              selectedColor: AppTheme.primaryColor,
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : AppTheme.textSecondary,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.borderLight,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppTheme.primaryColor,
                      indicatorWeight: 2,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.textTertiary,
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                      onTap: (_) => HapticFeedback.selectionClick(),
                      tabs: const [
                        Tab(text: 'For You'),
                        Tab(text: 'Watchlist'),
                        Tab(text: 'Deals'),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildForYouTab(),
                    _buildWatchlistTab(),
                    _buildDealsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForYouTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Price Drop Alert
        _buildPriceDropAlert(),

        const SizedBox(height: 24),

        // AI Recommendations
        _buildSectionHeader('AI Recommendations', 'Based on your visits'),
        const SizedBox(height: 12),
        _buildProductGrid(_mockRecommendedProducts),

        const SizedBox(height: 32),

        // Trending Products
        _buildSectionHeader('Trending Now', 'Popular this week'),
        const SizedBox(height: 12),
        _buildProductGrid(_mockTrendingProducts),

        const SizedBox(height: 32),

        // Categories
        _buildSectionHeader('Shop by Category', ''),
        const SizedBox(height: 12),
        _buildCategoryGrid(),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildWatchlistTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Stats Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor.withOpacity(0.1), AppTheme.accentLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('12', 'Tracking', Icons.visibility_outlined),
              Container(width: 1, height: 40, color: AppTheme.borderLight),
              _buildStatItem('3', 'Price Drops', Icons.trending_down, color: AppTheme.successColor),
              Container(width: 1, height: 40, color: AppTheme.borderLight),
              _buildStatItem('\$47', 'Saved', Icons.savings_outlined, color: AppTheme.accentColor),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildSectionHeader('Your Watchlist', '12 products'),
        const SizedBox(height: 12),
        
        ..._mockWatchlistProducts.map((product) => _buildWatchlistProductCard(product)),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildDealsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        // Deal Alert Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFEBEE), Color(0xFFFCE4EC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_fire_department, color: AppTheme.errorColor, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hot Deals Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    Text(
                      'Up to 40% off on selected items',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFAD1457),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildSectionHeader('Limited Time Offers', 'Ends soon'),
        const SizedBox(height: 12),
        _buildProductGrid(_mockDealProducts),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPriceDropAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications_active, color: AppTheme.successColor, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3 Price Drops!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  'Products in your watchlist are on sale',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF388E3C),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.successColor),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<Map<String, dynamic>> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Navigate to product details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${product['name']}')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      product['emoji'],
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
                // Discount Badge
                if (product['discount'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      product['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                      size: 18,
                      color: product['isSaved'] ? AppTheme.primaryColor : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['brand'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (product['oldPrice'] != null) ...[
                          Text(
                            product['oldPrice'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textTertiary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          product['price'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: AppTheme.accentColor),
                        const SizedBox(width: 4),
                        Text(
                          '${product['rating']} (${product['reviews']})',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
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

  Widget _buildWatchlistProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                product['emoji'],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['brand'],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      product['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (product['priceStatus'] == 'down')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_downward, size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              product['priceChange'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Remove Button
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: AppTheme.textTertiary,
            onPressed: () {
              HapticFeedback.lightImpact();
              // Remove from watchlist
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Shampoo', 'icon': '🧴', 'count': '234'},
      {'name': 'Conditioner', 'icon': '💧', 'count': '189'},
      {'name': 'Hair Tools', 'icon': '💇', 'count': '156'},
      {'name': 'Styling', 'icon': '✨', 'count': '267'},
      {'name': 'Treatments', 'icon': '🌿', 'count': '198'},
      {'name': 'Color Care', 'icon': '🎨', 'count': '145'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to category
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category['icon']!,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${category['count']} items',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color ?? AppTheme.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // Mock Data
  final List<Map<String, dynamic>> _mockRecommendedProducts = [
    {
      'name': 'Color Safe Shampoo',
      'brand': 'OLAPLEX',
      'price': '\$28',
      'oldPrice': null,
      'discount': null,
      'rating': '4.8',
      'reviews': '2.3k',
      'emoji': '🧴',
      'isSaved': false,
    },
    {
      'name': 'Bond Repair Treatment',
      'brand': 'K18',
      'price': '\$75',
      'oldPrice': '\$89',
      'discount': '15% OFF',
      'rating': '4.9',
      'reviews': '1.8k',
      'emoji': '✨',
      'isSaved': true,
    },
    {
      'name': 'Heat Protectant Spray',
      'brand': 'GHD',
      'price': '\$32',
      'oldPrice': null,
      'discount': null,
      'rating': '4.7',
      'reviews': '1.2k',
      'emoji': '💨',
      'isSaved': false,
    },
    {
      'name': 'Curling Iron Pro',
      'brand': 'DYSON',
      'price': '\$499',
      'oldPrice': '\$549',
      'discount': '10% OFF',
      'rating': '4.9',
      'reviews': '3.5k',
      'emoji': '💇',
      'isSaved': false,
    },
  ];

  final List<Map<String, dynamic>> _mockTrendingProducts = [
    {
      'name': 'Hair Dryer Supersonic',
      'brand': 'DYSON',
      'price': '\$429',
      'oldPrice': null,
      'discount': null,
      'rating': '4.8',
      'reviews': '4.2k',
      'emoji': '💨',
      'isSaved': false,
    },
    {
      'name': 'Leave-In Conditioner',
      'brand': 'MOROCCAN OIL',
      'price': '\$34',
      'oldPrice': '\$42',
      'discount': '20% OFF',
      'rating': '4.7',
      'reviews': '2.1k',
      'emoji': '💧',
      'isSaved': true,
    },
    {
      'name': 'Volume Mousse',
      'brand': 'LIVING PROOF',
      'price': '\$29',
      'oldPrice': null,
      'discount': null,
      'rating': '4.6',
      'reviews': '980',
      'emoji': '☁️',
      'isSaved': false,
    },
    {
      'name': 'Shine Serum',
      'brand': 'KERASTASE',
      'price': '\$45',
      'oldPrice': null,
      'discount': null,
      'rating': '4.8',
      'reviews': '1.5k',
      'emoji': '✨',
      'isSaved': false,
    },
  ];

  final List<Map<String, dynamic>> _mockDealProducts = [
    {
      'name': 'Purple Shampoo',
      'brand': 'FANOLA',
      'price': '\$15',
      'oldPrice': '\$25',
      'discount': '40% OFF',
      'rating': '4.6',
      'reviews': '890',
      'emoji': '💜',
      'isSaved': false,
    },
    {
      'name': 'Flat Iron Classic',
      'brand': 'GHD',
      'price': '\$129',
      'oldPrice': '\$189',
      'discount': '32% OFF',
      'rating': '4.9',
      'reviews': '3.2k',
      'emoji': '🔥',
      'isSaved': true,
    },
    {
      'name': 'Argan Oil Treatment',
      'brand': 'JOSIE MARAN',
      'price': '\$48',
      'oldPrice': '\$68',
      'discount': '30% OFF',
      'rating': '4.7',
      'reviews': '1.8k',
      'emoji': '🌰',
      'isSaved': false,
    },
    {
      'name': 'Dry Shampoo',
      'brand': 'BATISTE',
      'price': '\$8',
      'oldPrice': '\$12',
      'discount': '35% OFF',
      'rating': '4.5',
      'reviews': '2.5k',
      'emoji': '💨',
      'isSaved': false,
    },
  ];

  final List<Map<String, dynamic>> _mockWatchlistProducts = [
    {
      'name': 'Bond Repair Shampoo',
      'brand': 'OLAPLEX',
      'price': '\$28',
      'emoji': '🧴',
      'priceStatus': 'down',
      'priceChange': '-12%',
    },
    {
      'name': 'Hair Mask Deep Conditioner',
      'brand': 'BRIOGEO',
      'price': '\$36',
      'emoji': '🥥',
      'priceStatus': 'down',
      'priceChange': '-8%',
    },
    {
      'name': 'Texturizing Spray',
      'brand': 'OUAI',
      'price': '\$28',
      'emoji': '💨',
      'priceStatus': 'stable',
      'priceChange': null,
    },
    {
      'name': 'Heat Protectant',
      'brand': 'CHI',
      'price': '\$18',
      'emoji': '🛡️',
      'priceStatus': 'down',
      'priceChange': '-15%',
    },
  ];
}

