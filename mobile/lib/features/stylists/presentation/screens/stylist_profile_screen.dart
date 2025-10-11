import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class StylistProfileScreen extends ConsumerWidget {
  final String stylistId;
  
  const StylistProfileScreen({
    super.key,
    required this.stylistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch stylist details from API
    // final stylist = ref.watch(stylistProvider(stylistId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Jane Smith'),
              background: Container(
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: const Center(
                  child: Icon(Icons.person, size: 80, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ),

          // Stylist info
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
                        '4.9',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(156 reviews)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Senior Stylist',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Elite Salon • 8 years experience',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Passionate hair stylist specializing in modern cuts, color transformations, and personalized styling. Certified in advanced cutting techniques and color theory.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Specialties',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSpecialtyChip('Haircuts'),
                      _buildSpecialtyChip('Color'),
                      _buildSpecialtyChip('Balayage'),
                      _buildSpecialtyChip('Styling'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Portfolio
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Portfolio',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                childCount: 9,
              ),
            ),
          ),

          // Reviews section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Reviews',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildReviewCard(
                  'Client Name',
                  5.0,
                  'Amazing experience! Jane really listened to what I wanted and delivered perfectly.',
                  DateTime.now().subtract(Duration(days: index * 5)),
                ),
                childCount: 5,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            context.push(
              '/booking',
              extra: {'stylistId': stylistId},
            );
          },
          child: const Text('Book Appointment'),
        ),
      ),
    );
  }

  Widget _buildSpecialtyChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    double rating,
    String review,
    DateTime date,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.person, size: 20, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${date.difference(DateTime.now()).inDays.abs()}d ago',
                  style: const TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review),
          ],
        ),
      ),
    );
  }
}

