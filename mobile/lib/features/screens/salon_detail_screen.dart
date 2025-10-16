import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';

/// Enhanced Salon Detail Screen
/// Full featured salon page with gallery, team, services, and reviews
class SalonDetailScreen extends ConsumerStatefulWidget {
  final String salonId;
  
  const SalonDetailScreen({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends ConsumerState<SalonDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderCollapsed = false;
  bool _isSaved = false;

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
    final isCollapsed = _scrollController.hasClients && 
        _scrollController.offset > (250 - kToolbarHeight);
    if (_isHeaderCollapsed != isCollapsed) {
      setState(() => _isHeaderCollapsed = isCollapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch from API - using mock data for now
    final salon = _getMockSalon();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Parallax Header
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
                      _shareSalon(salon['name'] as String);
                    },
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() => _isSaved = !_isSaved);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isSaved ? 'Saved!' : 'Removed from saved'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: _isHeaderCollapsed
                      ? Text(
                          salon['name'] as String,
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
                      salon['cover'] != null
                          ? CachedNetworkImage(
                              imageUrl: salon['cover'] as String,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  _buildDefaultCover(),
                            )
                          : _buildDefaultCover(),
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

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Salon Header
                    _buildSalonHeader(salon),

                    const SizedBox(height: 24),

                    // Quick Info Cards
                    _buildQuickInfo(salon),

                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtons(salon),

                    const SizedBox(height: 32),

                    // Status Banner
                    _buildStatusBanner(),

                    const SizedBox(height: 32),

                    // About Section
                    _buildAboutSection(salon),

                    const SizedBox(height: 32),

                    // Amenities
                    _buildAmenities(salon),

                    const SizedBox(height: 32),

                    // Photo Gallery
                    _buildPhotoGallery(salon),

                    const SizedBox(height: 32),

                    // Services Menu
                    _buildServicesSection(salon),

                    const SizedBox(height: 32),

                    // Team Section
                    _buildTeamSection(salon),

                    const SizedBox(height: 32),

                    // Operating Hours
                    _buildOperatingHours(salon),

                    const SizedBox(height: 32),

                    // Reviews
                    _buildReviewsSection(salon),

                    const SizedBox(height: 32),

                    // Location & Map
                    _buildLocationSection(salon),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // Floating Book Button
          if (!_isHeaderCollapsed)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: _buildFloatingBookButton(salon),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.store, size: 100, color: Colors.white54),
      ),
    );
  }

  Widget _buildSalonHeader(Map<String, dynamic> salon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  salon['name'] as String,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    letterSpacing: -1,
                  ),
                ),
              ),
              if (salon['verified'] == true)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: AppTheme.successColor,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            salon['category'] as String,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 6),
              Text(
                '${salon['rating']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${salon['reviewCount']} reviews)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentColor),
                ),
                child: Text(
                  salon['priceRange'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(Map<String, dynamic> salon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              Icons.work_outline,
              '${salon['teamSize']} Pros',
              'Expert Team',
              AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              Icons.cut,
              '${salon['serviceCount']}+',
              'Services',
              AppTheme.accentColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard(
              Icons.event_available,
              'Same Day',
              'Booking',
              AppTheme.successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> salon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _handleBooking(salon),
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
              onPressed: () => _callSalon(salon['phone'] as String?),
              icon: const Icon(Icons.phone, size: 20),
              label: const Text('Call'),
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
            child: IconButton(
              icon: const Icon(Icons.directions, color: AppTheme.primaryColor),
              onPressed: () => _getDirections(salon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    // Mock - replace with real-time data
    final isOpen = true;
    final closingTime = '8:00 PM';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOpen
              ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
              : [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isOpen
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isOpen ? Icons.access_time : Icons.schedule,
              color: isOpen ? AppTheme.successColor : AppTheme.errorColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOpen ? 'Open Now' : 'Closed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOpen ? 'Closes at $closingTime' : 'Opens tomorrow at 9:00 AM',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isOpen ? const Color(0xFF4A7A4D) : const Color(0xFFE57373),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> salon) {
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
            salon['description'] as String,
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

  Widget _buildAmenities(Map<String, dynamic> salon) {
    final amenities = salon['amenities'] as List<String>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: amenities.map((amenity) {
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
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: const TextStyle(
                        fontSize: 13,
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

  Widget _buildPhotoGallery(Map<String, dynamic> salon) {
    final photos = salon['photos'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gallery',
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
                  _viewAllPhotos(photos);
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
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _viewPhoto(photos, index);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 240,
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
                    child: Image.network(
                      photos[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppTheme.surfaceColor,
                        child: const Center(
                          child: Icon(Icons.image, size: 48, color: AppTheme.textTertiary),
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

  Widget _buildServicesSection(Map<String, dynamic> salon) {
    final services = salon['services'] as List<Map<String, dynamic>>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Services',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...services.map((service) => _buildServiceCard(service)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getServiceIcon(service['name'] as String),
              color: AppTheme.accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service['description'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${service['duration']} min',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${service['price']}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(Map<String, dynamic> salon) {
    final team = salon['team'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Our Team',
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
            itemCount: team.length,
            itemBuilder: (context, index) {
              final member = team[index];
              return _buildTeamMemberCard(member);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/pros/${member['id']}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                shape: BoxShape.circle,
              ),
              child: member['photo'] != null
                  ? ClipOval(
                      child: Image.network(
                        member['photo'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person,
                          size: 40,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    )
                  : const Icon(Icons.person, size: 40, color: AppTheme.accentColor),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    member['name'] as String,
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
                    member['title'] as String,
                    style: const TextStyle(
                      fontSize: 12,
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
                        '${member['rating']}',
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

  Widget _buildOperatingHours(Map<String, dynamic> salon) {
    final hours = salon['hours'] as Map<String, String>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Operating Hours',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              children: hours.entries.map((entry) {
                final isToday = entry.key == 'Monday'; // Mock
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                          color: isToday ? AppTheme.primaryColor : Colors.black,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isToday ? FontWeight.w500 : FontWeight.w300,
                          color: isToday ? AppTheme.primaryColor : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(Map<String, dynamic> salon) {
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
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mock review cards
          ...List.generate(3, (index) => _buildReviewCard(index)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sarah Johnson',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (i) => const Icon(
                          Icons.star,
                          size: 14,
                          color: AppTheme.accentColor,
                        )),
                        const SizedBox(width: 8),
                        const Text(
                          '2 days ago',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Amazing experience! The staff was professional and friendly. Highly recommend this salon!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> salon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
                    const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        salon['address'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Mock map placeholder
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map, size: 48, color: AppTheme.accentColor),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _getDirections(salon),
                          icon: const Icon(Icons.directions),
                          label: const Text('Get Directions'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBookButton(Map<String, dynamic> salon) {
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
        onPressed: () => _handleBooking(salon),
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

  Map<String, dynamic> _getMockSalon() {
    return {
      'id': widget.salonId,
      'name': 'Elite Hair Studio',
      'category': 'Premium Hair Salon & Spa',
      'rating': 4.8,
      'reviewCount': 234,
      'priceRange': '\$\$\$',
      'verified': true,
      'teamSize': 12,
      'serviceCount': 25,
      'cover': 'https://via.placeholder.com/800x400',
      'description': 'Premier beauty salon offering cutting-edge hair styling, coloring, and beauty treatments. Our expert stylists are dedicated to helping you look and feel your best with personalized service in a luxurious setting.',
      'amenities': ['WiFi', 'Parking', 'Wheelchair Access', 'Credit Cards', 'Walk-ins Welcome'],
      'photos': [
        'https://via.placeholder.com/400x300',
        'https://via.placeholder.com/400x300',
        'https://via.placeholder.com/400x300',
        'https://via.placeholder.com/400x300',
      ],
      'services': [
        {
          'name': 'Haircut & Style',
          'description': 'Professional haircut with styling',
          'duration': 45,
          'price': 50,
        },
        {
          'name': 'Color Treatment',
          'description': 'Full color with toner',
          'duration': 120,
          'price': 120,
        },
        {
          'name': 'Balayage',
          'description': 'Hand-painted highlights',
          'duration': 180,
          'price': 180,
        },
        {
          'name': 'Blowout',
          'description': 'Professional blow dry',
          'duration': 30,
          'price': 35,
        },
      ],
      'team': [
        {'id': '1', 'name': 'Jane Smith', 'title': 'Senior Stylist', 'rating': 4.9, 'photo': null},
        {'id': '2', 'name': 'Mike Johnson', 'title': 'Color Expert', 'rating': 4.8, 'photo': null},
        {'id': '3', 'name': 'Sarah Davis', 'title': 'Master Stylist', 'rating': 5.0, 'photo': null},
        {'id': '4', 'name': 'Tom Wilson', 'title': 'Barber', 'rating': 4.7, 'photo': null},
      ],
      'hours': {
        'Monday': '9:00 AM - 8:00 PM',
        'Tuesday': '9:00 AM - 8:00 PM',
        'Wednesday': '9:00 AM - 8:00 PM',
        'Thursday': '9:00 AM - 8:00 PM',
        'Friday': '9:00 AM - 9:00 PM',
        'Saturday': '8:00 AM - 6:00 PM',
        'Sunday': 'Closed',
      },
      'address': '123 Main Street, Downtown, NY 10001',
      'phone': '+1 (555) 123-4567',
    };
  }

  IconData _getServiceIcon(String serviceName) {
    if (serviceName.toLowerCase().contains('cut')) return Icons.content_cut;
    if (serviceName.toLowerCase().contains('color')) return Icons.palette;
    if (serviceName.toLowerCase().contains('balayage')) return Icons.brush;
    if (serviceName.toLowerCase().contains('blow')) return Icons.air;
    return Icons.cut;
  }

  IconData _getAmenityIcon(String amenity) {
    if (amenity.toLowerCase().contains('wifi')) return Icons.wifi;
    if (amenity.toLowerCase().contains('parking')) return Icons.local_parking;
    if (amenity.toLowerCase().contains('wheelchair')) return Icons.accessible;
    if (amenity.toLowerCase().contains('card')) return Icons.credit_card;
    if (amenity.toLowerCase().contains('walk')) return Icons.directions_walk;
    return Icons.check_circle;
  }

  void _handleBooking(Map<String, dynamic> salon) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking at ${salon['name']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callSalon(String? phone) {
    if (phone == null) return;
    HapticFeedback.lightImpact();
    launchUrl(Uri.parse('tel:$phone'));
  }

  void _getDirections(Map<String, dynamic> salon) {
    HapticFeedback.lightImpact();
    // Launch maps with salon address
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening directions...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareSalon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $name...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _viewAllPhotos(List<String> photos) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening gallery...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _viewPhoto(List<String> photos, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing photo ${index + 1}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}