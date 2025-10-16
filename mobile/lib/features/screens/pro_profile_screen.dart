import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../data/services/profile_service.dart';
import '../../data/services/review_service.dart';
import '../../core/widgets/rating_bar.dart';
import '../../core/widgets/tag_chips.dart';
import '../../core/widgets/follow_button.dart';
import '../../ai/summary/ai_review_summarizer.dart';
import '../../core/feature_flags.dart';
import '../../core/theme/app_theme.dart';

/// Enhanced Professional Profile Screen
/// Full featured profile page with gallery, reviews, and booking
class ProProfileScreen extends ConsumerStatefulWidget {
  final String proId;

  const ProProfileScreen({super.key, required this.proId});

  @override
  ConsumerState<ProProfileScreen> createState() => _ProProfileScreenState();
}

class _ProProfileScreenState extends ConsumerState<ProProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isCollapsed = _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
    if (_isHeaderCollapsed != isCollapsed) {
      setState(() => _isHeaderCollapsed = isCollapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(widget.proId));

    return Scaffold(
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return _buildNotFound();
          }

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Parallax Header with Cover Photo
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: AppTheme.primaryColor,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    actions: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share, color: Colors.white),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _shareProfile(profile.name);
                        },
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.more_vert, color: Colors.white),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showMoreOptions(profile);
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: _isHeaderCollapsed
                          ? Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            )
                          : null,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Cover Photo
                          profile.portfolio.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: profile.portfolio.first,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.person, size: 100, color: Colors.white54),
                                  ),
                                ),
                          // Gradient Overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profile Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        _buildProfileHeader(profile),

                        const SizedBox(height: 24),

                        // Quick Stats
                        _buildQuickStats(profile),

                        const SizedBox(height: 24),

                        // Action Buttons
                        _buildActionButtons(profile),

                        const SizedBox(height: 32),

                        // Availability Banner
                        _buildAvailabilityBanner(),

                        const SizedBox(height: 32),

                        // About Section
                        _buildAboutSection(profile),

                        const SizedBox(height: 32),

                        // Services & Pricing
                        _buildServicesSection(profile),

                        const SizedBox(height: 32),

                        // Specialties & Badges
                        _buildSpecialtiesSection(profile),

                        const SizedBox(height: 32),

                        // Recent Work / Portfolio
                        if (profile.portfolio.isNotEmpty)
                          _buildPortfolioSection(profile),

                        const SizedBox(height: 32),

                        // Reviews Section
                        _buildReviewsSection(context, ref, profile),

                        const SizedBox(height: 32),

                        // Similar Professionals
                        _buildSimilarProsSection(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),

              // Floating Book Now Button
              if (!_isHeaderCollapsed)
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: _buildFloatingBookButton(profile),
                ),
            ],
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              SizedBox(height: 16),
              Text(
                'Loading profile...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => _buildError(error.toString()),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_off_outlined,
              size: 64,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Profile not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This professional may have been removed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Failed to load profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                ),
                child: const Text('Go Back'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.invalidate(profileProvider(widget.proId));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Photo
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: CachedNetworkImageProvider(profile.photoUrl),
                ),
              ),
              if (profile.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Name & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  profile.specialty,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.accentColor,
                  ),
                ),
                if (profile.salonName != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.store, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          profile.salonName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (profile.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        profile.location!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.star,
            '${profile.rating}',
            'Rating',
            AppTheme.accentColor,
          ),
          _buildStatDivider(),
          _buildStatItem(
            Icons.work_outline,
            '${profile.yearsExperience}y',
            'Experience',
            AppTheme.primaryColor,
          ),
          _buildStatDivider(),
          _buildStatItem(
            Icons.people_outline,
            '${profile.followerCount}',
            'Followers',
            AppTheme.successColor,
          ),
          _buildStatDivider(),
          _buildStatItem(
            Icons.rate_review_outlined,
            '${profile.reviewCount}',
            'Reviews',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 50,
      color: AppTheme.borderLight,
    );
  }

  Widget _buildActionButtons(dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _handleBookNow(profile),
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _sendMessage(profile);
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 20),
              label: const Text('Message'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: FollowButton(
              userId: profile.id,
              initialFollowing: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBanner() {
    // Mock availability - replace with real data
    final isAvailable = true;
    
    if (!isAvailable) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
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
            child: const Icon(Icons.check_circle, color: AppTheme.successColor, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available This Week',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Next opening: Tomorrow at 2:00 PM',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4A7A4D),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF2E7D32)),
        ],
      ),
    );
  }

  Widget _buildAboutSection(dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.bio,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Services',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              if (profile.priceRange != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentColor),
                  ),
                  child: Text(
                    profile.priceRange!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...profile.services.map<Widget>((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cut, color: AppTheme.accentColor, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '45-60 min',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'From \$50',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection(dynamic profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Specialties & Expertise',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.specialties.map<Widget>((specialty) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, size: 16, color: AppTheme.accentColor),
                    const SizedBox(width: 6),
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection(dynamic profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portfolio',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _viewFullGallery(profile.portfolio);
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: profile.portfolio.length > 6 ? 6 : profile.portfolio.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _viewImage(profile.portfolio, index);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: profile.portfolio[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.surfaceColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, WidgetRef ref, dynamic profile) {
    final reviewsAsync = ref.watch(reviewsProvider({
      'targetId': widget.proId,
      'targetType': 'stylist',
    }));

    return reviewsAsync.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: const Column(
                children: [
                  Icon(Icons.rate_review_outlined, size: 48, color: AppTheme.textTertiary),
                  SizedBox(height: 16),
                  Text(
                    'No reviews yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Be the first to review this professional',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 20, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.rating}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' (${reviews.length})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // AI Summary
              if (FeatureFlags.aiSummaries && reviews.length >= 10)
                FutureBuilder<String?>(
                  future: ref.read(aiReviewSummarizerProvider).summarizeReviews(reviews),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade50,
                              Colors.purple.shade50,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'AI Summary',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF1E3A5F),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

              const SizedBox(height: 16),

              // Review List
              ...reviews.take(5).map((review) => _buildReviewCard(review)),

              if (reviews.length > 5) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Navigate to all reviews
                    },
                    child: Text(
                      'View All ${reviews.length} Reviews',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              review.userPhotoUrl != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(review.userPhotoUrl!),
                    )
                  : const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? 'Anonymous',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CustomRatingBar(rating: review.rating, size: 14),
                        if (review.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(review.createdAt!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.text != null) ...[
            const SizedBox(height: 12),
            Text(
              review.text!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimilarProsSection() {
    // Mock similar professionals
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Similar Professionals',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/explore');
                },
                child: const Text(
                  'See More',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildSimilarProCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProCard(int index) {
    final pros = [
      {'name': 'Sarah Johnson', 'specialty': 'Color Specialist', 'rating': '4.9'},
      {'name': 'Mike Brown', 'specialty': 'Barber Master', 'rating': '4.8'},
      {'name': 'Emily Davis', 'specialty': 'Bridal Expert', 'rating': '5.0'},
    ];

    final pro = pros[index];

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to pro profile
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person, color: AppTheme.accentColor, size: 36),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    pro['name']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pro['specialty']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        pro['rating']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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

  Widget _buildFloatingBookButton(dynamic profile) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _handleBookNow(profile),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 20),
            SizedBox(width: 10),
            Text(
              'Book Appointment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBookNow(dynamic profile) async {
    HapticFeedback.mediumImpact();
    
    final urlStr = profile.bookingUrl;
    if (urlStr == null || urlStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking link not available'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }
    
    final url = Uri.parse(urlStr);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open booking link'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _sendMessage(dynamic profile) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaging ${profile.name}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareProfile(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $name\'s profile...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showMoreOptions(dynamic profile) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Block'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewFullGallery(List<String> images) {
    // Navigate to full gallery view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening gallery...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _viewImage(List<String> images, int index) {
    // Open image viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing image ${index + 1}'),
        duration: const Duration(seconds: 1),
      ),
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