import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class SalonDetailScreen extends ConsumerWidget {
  final String salonId;
  
  const SalonDetailScreen({
    super.key,
    required this.salonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch salon details from API
    // final salon = ref.watch(salonProvider(salonId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Elite Salon'),
              background: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.store, size: 80, color: Colors.grey),
                ),
              ),
            ),
          ),

          // Salon info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.accentColor, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(234 reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '123 Main St, Downtown',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Open: 9:00 AM - 8:00 PM',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Premier beauty salon offering cutting-edge hair styling, coloring, and beauty treatments. Our expert stylists are dedicated to helping you look and feel your best.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),

          // Services section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Popular Services',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildServiceCard(
                  context,
                  'Haircut & Style',
                  'Professional haircut with styling',
                  45,
                  50.0,
                ),
                childCount: 5,
              ),
            ),
          ),

          // Stylists section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Our Stylists',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildStylistCard(
                  context,
                  'Jane Smith',
                  'Senior Stylist',
                  4.9,
                  'stylist-$index',
                ),
                childCount: 4,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String name,
    String description,
    int duration,
    double price,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.content_cut,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$duration min',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStylistCard(
    BuildContext context,
    String name,
    String title,
    double rating,
    String id,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const Icon(Icons.person, color: AppTheme.primaryColor),
        ),
        title: Text(name),
        subtitle: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: AppTheme.accentColor, size: 16),
            const SizedBox(width: 4),
            Text(rating.toStringAsFixed(1)),
          ],
        ),
        onTap: () => context.push('/stylist/$id'),
      ),
    );
  }
}

