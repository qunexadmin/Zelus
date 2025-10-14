import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/services/profile_service.dart';
import '../../../../data/services/review_service.dart';
import '../../../../core/widgets/rating_bar.dart';
import '../../../../core/widgets/tag_chips.dart';
import '../../../../core/widgets/follow_button.dart';
import '../../../../ai/summary/ai_review_summarizer.dart';
import '../../../../core/feature_flags.dart';

/// Professional Profile Screen
/// Full profile page for a professional
class ProProfileScreen extends ConsumerWidget {
  final String proId;

  const ProProfileScreen({super.key, required this.proId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider(proId));

    return Scaffold(
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar with cover photo
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: profile.portfolio.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profile.portfolio.first,
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[300]),
                ),
              ),
              
              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(profile.photoUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        profile.name,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (profile.isVerified) ...[
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                                    ],
                                  ],
                                ),
                                if (profile.salonName != null)
                                  Text(
                                    profile.salonName!,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                if (profile.location != null)
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                                      Text(
                                        profile.location!,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Experience', '${profile.yearsExperience}y'),
                          _buildStat('Followers', '${profile.followerCount}'),
                          _buildStat('Reviews', '${profile.reviewCount}'),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: profile.bookingUrl != null
                                  ? () async {
                                      final url = Uri.parse(profile.bookingUrl!);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url, mode: LaunchMode.externalApplication);
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Booking link not available')),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text('Book Now'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FollowButton(
                            userId: profile.id,
                            initialFollowing: false,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Bio
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(profile.bio),
                      
                      const SizedBox(height: 24),
                      
                      // Services & Specialties
                      Text(
                        'Services',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TagChips(tags: profile.services),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Specialties',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TagChips(tags: profile.specialties),
                      
                      if (profile.priceRange != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Price Range: ${profile.priceRange}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Portfolio
                      if (profile.portfolio.isNotEmpty) ...[
                        Text(
                          'Portfolio',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: profile.portfolio.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: profile.portfolio[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      // Reviews
                      _buildReviewsSection(context, ref, profile.id),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, WidgetRef ref, String proId) {
    final reviewsAsync = ref.watch(reviewsProvider({
      'targetId': proId,
      'targetType': 'stylist',
    }));

    return reviewsAsync.when(
      data: (reviews) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Reviews',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (reviews.isNotEmpty)
                  RatingBarWithValue(rating: reviews.first.rating),
              ],
            ),
            
            // AI Summary (if >=10 reviews)
            if (FeatureFlags.aiSummaries && reviews.length >= 10)
              FutureBuilder<String?>(
                future: ref.read(aiReviewSummarizerProvider).summarizeReviews(reviews),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              snapshot.data!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            
            const SizedBox(height: 12),
            
            // Review list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (review.userPhotoUrl != null)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: CachedNetworkImageProvider(review.userPhotoUrl!),
                          )
                        else
                          const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.userName ?? 'Anonymous',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              CustomRatingBar(rating: review.rating, size: 14),
                            ],
                          ),
                        ),
                        if (review.createdAt != null)
                          Text(
                            _formatDate(review.createdAt!),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                      ],
                    ),
                    if (review.text != null) ...[
                      const SizedBox(height: 8),
                      Text(review.text!),
                    ],
                  ],
                );
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 30) {
      return '${diff.inDays ~/ 30}mo ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}

