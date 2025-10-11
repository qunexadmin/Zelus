import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class DiscoverTab extends ConsumerStatefulWidget {
  const DiscoverTab({super.key});

  @override
  ConsumerState<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends ConsumerState<DiscoverTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () => context.push('/ai-preview'),
            tooltip: 'AI Preview',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search salons, stylists, services...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {
                      // TODO: Show filters
                    },
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('Haircut', Icons.content_cut),
                  _buildCategoryChip('Color', Icons.palette),
                  _buildCategoryChip('Styling', Icons.style),
                  _buildCategoryChip('Spa', Icons.spa),
                  _buildCategoryChip('Nails', Icons.hand_outlined),
                ],
              ),
            ),
          ),

          // Section: Featured Salons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Salons',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          // Featured salons grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSalonCard(
                  'Salon ${index + 1}',
                  'Downtown',
                  4.5 + (index * 0.1),
                  'salon-$index',
                ),
                childCount: 6,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCard(String name, String location, double rating, String id) {
    return GestureDetector(
      onTap: () => context.push('/salon/$id'),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.store, size: 48, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppTheme.textTertiary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
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

