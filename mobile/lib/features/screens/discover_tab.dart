import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class DiscoverTab extends ConsumerStatefulWidget {
  const DiscoverTab({super.key});

  @override
  ConsumerState<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends ConsumerState<DiscoverTab> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _searchHistory = ['Balayage near me', 'Jane Smith', 'Best hair salon'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    // TODO: Implement actual data refresh
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;
    
    HapticFeedback.lightImpact();
    setState(() {
      _isSearching = true;
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });

    // Simulate search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSearching = false);
        context.push('/explore'); // Navigate to explore with search results
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
                toolbarHeight: 110,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                // Border removed for cleaner look
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16), // Increased top padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sarah',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Profile Icon with notification badge
                      Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Navigate to profile
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
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

                // AI-Powered Search Bar with Voice
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
                        hintText: 'AI-powered search...',
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
                                  Icons.auto_awesome,
                                  color: AppTheme.accentColor,
                                  size: 20,
                                ),
                              ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.mic_none, size: 22),
                              color: AppTheme.textSecondary,
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // TODO: Implement voice search
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Voice search coming soon!')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.search, size: 22),
                              color: AppTheme.textSecondary,
                              onPressed: () => _handleSearch(_searchController.text),
                            ),
                          ],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // AI Search Suggestions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Try asking...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSearchSuggestion(
                        'Check Jane Smith\'s availability',
                        Icons.calendar_today_outlined,
                        onTap: () {
                          _searchController.text = 'Jane Smith availability';
                          _handleSearch(_searchController.text);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildSearchSuggestion(
                        'What\'s trending this week?',
                        Icons.trending_up,
                        onTap: () {
                          context.push('/trending');
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildSearchSuggestion(
                        'Find salons near me',
                        Icons.near_me_outlined,
                        onTap: () {
                          context.push('/explore');
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildSearchSuggestion(
                        'Check retail offers',
                        Icons.local_offer_outlined,
                        onTap: () {
                          // TODO: Navigate to retail offers section
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Retail offers coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Upcoming Appointment Card
                _buildUpcomingAppointment(),

                const SizedBox(height: 32),

                // Special Offers Section
                _buildSpecialOffers(),

                const SizedBox(height: 32),

                // Recent Visits
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Visits',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // Navigate to history
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Recent Visits - Enhanced with images
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final visits = [
                        {
                          'name': 'Elite Hair Studio',
                          'service': 'Haircut & Style',
                          'date': '2 days ago',
                          'id': '1',
                          'image': '💇‍♀️'
                        },
                        {
                          'name': 'Color Studio NYC',
                          'service': 'Balayage Color',
                          'date': '2 weeks ago',
                          'id': '2',
                          'image': '🎨'
                        },
                        {
                          'name': 'Downtown Barbers',
                          'service': 'Beard Trim',
                          'date': '1 month ago',
                          'id': '3',
                          'image': '✂️'
                        },
                      ];
                      return _buildRecentVisit(
                        visits[index]['name']!,
                        visits[index]['service']!,
                        visits[index]['date']!,
                        visits[index]['id']!,
                        visits[index]['image']!,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Your Favorites Section
                _buildFavoritesSection(),

                const SizedBox(height: 32),

                // New Stylists Near You
                _buildNewStylistsSection(),

                const SizedBox(height: 32),

                // Trending Styles with Images
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trending This Week',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.push('/trending');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Trending Grid with better visuals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      _buildTrendingCard('Summer Waves', '2.3k', '🌊', Colors.blue.shade50),
                      _buildTrendingCard('Bold Highlights', '1.8k', '✨', Colors.amber.shade50),
                      _buildTrendingCard('Sleek Bob', '1.5k', '💁‍♀️', Colors.pink.shade50),
                      _buildTrendingCard('Natural Curls', '1.2k', '🌀', Colors.purple.shade50),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Inspiration Gallery
                _buildInspirationGallery(),

                const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestion(String text, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) {
          onTap();
        } else {
          _searchController.text = text;
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.surfaceColor,
              AppTheme.surfaceColor.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentLight, AppTheme.accentLight.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.accentColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          // Navigate to appointment details
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.event, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Upcoming Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Tomorrow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Elite Hair Studio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    '2:00 PM - 3:30 PM',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.cut, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  const Text(
                    'Haircut & Styling',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // Reschedule action
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reschedule'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        // View details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150, // Increased from 140 to prevent overflow
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildOfferCard(
                '20% OFF',
                'First Visit Discount',
                'Valid until Oct 31',
                Icons.local_offer,
                const Color(0xFFE91E63),
              ),
              _buildOfferCard(
                'BUY 2 GET 1',
                'Color Treatment Special',
                'Limited time offer',
                Icons.palette,
                const Color(0xFF9C27B0),
              ),
              _buildOfferCard(
                'FREE',
                'Consultation & Analysis',
                'Book now',
                Icons.face_retouching_natural,
                const Color(0xFF00BCD4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(String discount, String title, String validity, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        // Show offer details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title - Tap to learn more')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        padding: const EdgeInsets.all(12), // Reduced from 14
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7), // Reduced from 8
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16), // Reduced from 18
                ),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 16), // Reduced from 18
              ],
            ),
            const Spacer(),
            Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20, // Reduced from 22
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2), // Reduced from 3
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12, // Reduced from 13
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2), // Reduced from 3
            Text(
              validity,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10, // Reduced from 11
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/collections');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildFavoriteItem('Jane Smith', 'Stylist', '⭐ 4.9', Icons.person),
              _buildFavoriteItem('Elite Studio', 'Salon', '📍 0.5 mi', Icons.store),
              _buildFavoriteItem('Balayage', 'Service', '💰 \$120', Icons.brush),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem(String name, String type, String info, IconData icon) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to detail page
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderLight, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    info,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewStylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'New Stylists Near You',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '5 NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/explore');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190, // Increased from 180 to prevent overflow
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildNewStylistCard('Michael Chen', 'Color Specialist', '4.8', '50+', '1'),
              _buildNewStylistCard('Sarah Johnson', 'Bridal Expert', '5.0', '30+', '2'),
              _buildNewStylistCard('Mike Brown', 'Barber Master', '4.9', '100+', '3'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewStylistCard(String name, String specialty, String rating, String reviews, String id) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/stylist/$id');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
        padding: const EdgeInsets.all(14), // Reduced from 16
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 65, // Reduced from 70
                  height: 65, // Reduced from 70
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: AppTheme.accentColor, size: 32),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppTheme.successColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Reduced from 12
            Text(
              name,
              style: const TextStyle(
                fontSize: 14, // Reduced from 15
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3), // Reduced from 4
            Text(
              specialty,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6), // Reduced from 8
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: AppTheme.accentColor, size: 13),
                const SizedBox(width: 4),
                Text(
                  '$rating ($reviews)',
                  style: const TextStyle(
                    fontSize: 11, // Reduced from 12
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Style Inspiration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.push('/trending');
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Browse All',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildInspirationCard('Fall Colors 2024', '🍂', Colors.orange.shade100),
              _buildInspirationCard('Wedding Hair', '💐', Colors.pink.shade50),
              _buildInspirationCard('Men\'s Trends', '💼', Colors.blue.shade50),
              _buildInspirationCard('Short & Chic', '✨', Colors.purple.shade50),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInspirationCard(String title, String emoji, Color bgColor) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/trending');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: bgColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 48),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.arrow_forward, size: 20),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '124 styles',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '• Popular',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVisit(String name, String service, String date, String id, String emoji) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/salon/$id');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 16, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              service,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              date,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textTertiary,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Book again action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking $name...')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor, width: 1),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Book Again',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingCard(String title, String saves, String emoji, Color bgColor) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.push('/trending');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.favorite, size: 15, color: AppTheme.errorColor),
                      const SizedBox(width: 6),
                      Text(
                        '$saves saves',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
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
}