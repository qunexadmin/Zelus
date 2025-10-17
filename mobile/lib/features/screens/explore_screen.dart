import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/services/profile_service.dart';
import '../../data/services/salon_service.dart';
import '../../core/widgets/pro_profile_card.dart';
import '../../core/theme/app_theme.dart';

/// Enhanced Explore Screen
/// Professional discovery with advanced filters and smart recommendations
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  
  // Filters
  String? _selectedCity;
  String? _selectedService;
  String? _selectedSpecialty;
  double? _minRating;
  String? _priceRange;
  bool _availableNow = false;
  String _sortBy = 'rating'; // rating, price, distance
  
  // Tab controller
  late TabController _tabController;

  final List<String> _cities = ['New York', 'San Francisco', 'Los Angeles', 'Chicago'];
  final List<String> _services = ['Haircut', 'Color', 'Balayage', 'Styling', 'Extensions'];
  final List<String> _specialties = [
    'Color Expert',
    'Bridal Specialist',
    'Curly Hair Pro',
    'Men\'s Grooming',
    'Extensions Master',
    'Balayage Artist',
  ];
  final List<String> _priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

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
      ref.invalidate(profilesProvider);
      ref.invalidate(salonsProvider);
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;
    
    HapticFeedback.lightImpact();
    setState(() => _isSearching = true);

    // Simulate search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isSearching = false);
        // Search results are filtered in the list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
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
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: -1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Find your perfect stylist',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sort & Filter button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showFilterSheet();
                        },
                      ),
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
                  // AI-Powered Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _handleSearch,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search professionals, salons...',
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
                              : const Icon(
                                  Icons.search,
                                  color: AppTheme.textSecondary,
                                  size: 22,
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

                  // Active Filters Summary
                  if (_hasActiveFilters()) _buildActiveFiltersSummary(),

                  const SizedBox(height: 16),

                  // Available Now Section
                  if (_availableNow) _buildAvailableNowSection(),

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
                      dividerHeight: 0,
                    tabs: const [
                      Tab(text: 'Professionals'),
                      Tab(text: 'Salons'),
                      Tab(text: 'Retail'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Content
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfessionalsTab(),
                  _buildSalonsTab(),
                  _buildRetailTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCity != null ||
        _selectedService != null ||
        _selectedSpecialty != null ||
        _minRating != null ||
        _priceRange != null ||
        _availableNow;
  }

  Widget _buildActiveFiltersSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedCity != null)
            _buildActiveFilterChip(_selectedCity!, () {
              setState(() => _selectedCity = null);
            }),
          if (_selectedService != null)
            _buildActiveFilterChip(_selectedService!, () {
              setState(() => _selectedService = null);
            }),
          if (_selectedSpecialty != null)
            _buildActiveFilterChip(_selectedSpecialty!, () {
              setState(() => _selectedSpecialty = null);
            }),
          if (_minRating != null)
            _buildActiveFilterChip('$_minRating+ ⭐', () {
              setState(() => _minRating = null);
            }),
          if (_priceRange != null)
            _buildActiveFilterChip(_priceRange!, () {
              setState(() => _priceRange = null);
            }),
          if (_availableNow)
            _buildActiveFilterChip('Available Now', () {
              setState(() => _availableNow = false);
            }),
          // Clear all
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _clearAllFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.clear_all, size: 14, color: AppTheme.errorColor),
                  SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onRemove();
            },
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _specialties.length,
            itemBuilder: (context, index) {
              final specialty = _specialties[index];
              final isSelected = _selectedSpecialty == specialty;
              
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(specialty),
                  selected: isSelected,
                  onSelected: (selected) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedSpecialty = selected ? specialty : null;
                    });
                  },
                  backgroundColor: AppTheme.surfaceColor,
                  selectedColor: AppTheme.accentLight,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.accentColor : AppTheme.borderLight,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableNowSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
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
              child: const Icon(Icons.schedule, color: AppTheme.successColor, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Showing professionals available now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalsTab() {
    final profilesAsync = ref.watch(profilesProvider);

    return profilesAsync.when(
      data: (profiles) {
        // Apply filters
        var filteredProfiles = profiles;
        
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          filteredProfiles = filteredProfiles
              .where((p) =>
                  p.name.toLowerCase().contains(query) ||
                  p.specialties.any((s) => s.toLowerCase().contains(query)))
              .toList();
        }
        
        if (_selectedCity != null) {
          filteredProfiles = filteredProfiles
              .where((p) => p.location?.contains(_selectedCity!) ?? false)
              .toList();
        }
        
        if (_selectedService != null) {
          filteredProfiles = filteredProfiles
              .where((p) => p.services.contains(_selectedService))
              .toList();
        }

        if (_selectedSpecialty != null) {
          filteredProfiles = filteredProfiles
              .where((p) => p.specialties.contains(_selectedSpecialty!))
              .toList();
        }
        
        if (_minRating != null) {
          filteredProfiles = filteredProfiles
              .where((p) => p.rating >= _minRating!)
              .toList();
        }

        // Sort
        switch (_sortBy) {
          case 'rating':
            filteredProfiles.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case 'price':
            // Sort by price if available
            break;
          case 'distance':
            // Sort by distance if available
            break;
        }

        if (filteredProfiles.isEmpty) {
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
                    Icons.person_search_outlined,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No professionals found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try adjusting your filters',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _clearAllFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: filteredProfiles.length + 1, // +1 for header
            itemBuilder: (context, index) {
              // Results header
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredProfiles.length} professionals',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      PopupMenuButton<String>(
                        initialValue: _sortBy,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _sortBy = value);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'rating',
                            child: Text('Highest Rated'),
                          ),
                          const PopupMenuItem(
                            value: 'price',
                            child: Text('Price: Low to High'),
                          ),
                          const PopupMenuItem(
                            value: 'distance',
                            child: Text('Nearest'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sort, size: 18, color: AppTheme.primaryColor),
                              SizedBox(width: 6),
                              Text(
                                'Sort',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final profile = filteredProfiles[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProProfileCard(
                  profile: profile,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/pros/${profile.id}');
                  },
                  onBookNow: () async {
                    HapticFeedback.mediumImpact();
                    final urlStr = profile.bookingUrl;
                    if (urlStr == null || urlStr.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Booking link not available')),
                      );
                      return;
                    }
                    final url = Uri.parse(urlStr);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Unable to open booking link')),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text(
              'Finding professionals...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
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
                size: 48,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.invalidate(profilesProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalonsTab() {
    final salonsAsync = ref.watch(salonsProvider);

    return salonsAsync.when(
      data: (salons) {
        // Apply filters
        var filteredSalons = salons;
        
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          filteredSalons = filteredSalons
              .where((s) => s.name.toLowerCase().contains(query))
              .toList();
        }
        
        if (_selectedCity != null) {
          filteredSalons = filteredSalons
              .where((s) => s.city == _selectedCity)
              .toList();
        }
        
        if (_selectedService != null) {
          filteredSalons = filteredSalons
              .where((s) => s.services.contains(_selectedService))
              .toList();
        }
        
        if (_minRating != null) {
          filteredSalons = filteredSalons
              .where((s) => s.rating >= _minRating!)
              .toList();
        }

        // Sort
        switch (_sortBy) {
          case 'rating':
            filteredSalons.sort((a, b) => b.rating.compareTo(a.rating));
            break;
        }

        if (filteredSalons.isEmpty) {
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
                    Icons.store_outlined,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No salons found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try adjusting your filters',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _clearAllFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: filteredSalons.length + 1,
            itemBuilder: (context, index) {
              // Results header
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredSalons.length} salons',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      PopupMenuButton<String>(
                        initialValue: _sortBy,
                        onSelected: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _sortBy = value);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'rating',
                            child: Text('Highest Rated'),
                          ),
                          const PopupMenuItem(
                            value: 'distance',
                            child: Text('Nearest'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sort, size: 18, color: AppTheme.primaryColor),
                              SizedBox(width: 6),
                              Text(
                                'Sort',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final salon = filteredSalons[index - 1];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/salon/${salon.id}');
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Salon Image/Icon
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: salon.photos.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    salon.photos.first,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.store, size: 36, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        // Salon Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                salon.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${salon.city}, ${salon.state}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${salon.rating}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${salon.reviewCount} reviews)',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: AppTheme.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppTheme.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text(
              'Finding salons...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
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
                size: 48,
                color: AppTheme.errorColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.invalidate(salonsProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters & Sort',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  // City
                  _buildFilterSection(
                    'City',
                    _selectedCity ?? 'Any city',
                    () => _showCityPicker(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Service
                  _buildFilterSection(
                    'Service',
                    _selectedService ?? 'Any service',
                    () => _showServicePicker(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Rating
                  _buildFilterSection(
                    'Minimum Rating',
                    _minRating != null ? '$_minRating+ Stars' : 'Any rating',
                    () => _showRatingPicker(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Price Range
                  _buildFilterSection(
                    'Price Range',
                    _priceRange ?? 'Any price',
                    () => _showPricePicker(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Available Now
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.schedule, color: AppTheme.successColor, size: 22),
                            SizedBox(width: 12),
                            Text(
                              'Available Now',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _availableNow,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() => _availableNow = value);
                            Navigator.pop(context);
                          },
                          activeColor: AppTheme.successColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (_hasActiveFilters()) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _clearAllFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.errorColor,
                          side: const BorderSide(color: AppTheme.errorColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear All Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }

  void _showCityPicker() {
    Navigator.pop(context); // Close filter sheet
    HapticFeedback.lightImpact();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Select City',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _cities.map((city) {
                  final isSelected = _selectedCity == city;
                  return ListTile(
                    title: Text(
                      city,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                        color: isSelected ? AppTheme.primaryColor : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.accentLight,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedCity = city);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _showFilterSheet());
  }

  void _showServicePicker() {
    Navigator.pop(context);
    HapticFeedback.lightImpact();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Select Service',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _services.map((service) {
                  final isSelected = _selectedService == service;
                  return ListTile(
                    title: Text(
                      service,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                        color: isSelected ? AppTheme.primaryColor : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.accentLight,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedService = service);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _showFilterSheet());
  }

  void _showRatingPicker() {
    Navigator.pop(context);
    HapticFeedback.lightImpact();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Minimum Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [4.5, 4.0, 3.5, 3.0].map((rating) {
                  final isSelected = _minRating == rating;
                  return ListTile(
                    title: Text(
                      '$rating+ Stars',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                        color: isSelected ? AppTheme.primaryColor : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.accentLight,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _minRating = rating);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _showFilterSheet());
  }

  void _showPricePicker() {
    Navigator.pop(context);
    HapticFeedback.lightImpact();
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Price Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _priceRanges.map((price) {
                  final isSelected = _priceRange == price;
                  return ListTile(
                    title: Text(
                      price,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                        color: isSelected ? AppTheme.primaryColor : Colors.black,
                      ),
                    ),
                    subtitle: Text(_getPriceLabel(price)),
                    selected: isSelected,
                    selectedTileColor: AppTheme.accentLight,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _priceRange = price);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _showFilterSheet());
  }

  String _getPriceLabel(String price) {
    switch (price) {
      case '\$':
        return 'Budget-friendly';
      case '\$\$':
        return 'Moderate';
      case '\$\$\$':
        return 'Premium';
      case '\$\$\$\$':
        return 'Luxury';
      default:
        return '';
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCity = null;
      _selectedService = null;
      _selectedSpecialty = null;
      _minRating = null;
      _priceRange = null;
      _availableNow = false;
      _searchController.clear();
    });
  }

  // ==================== RETAIL TAB ====================

  Widget _buildRetailTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Price Drop Alert
        Container(
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
        ),

        const SizedBox(height: 24),

        // AI Recommendations
        _buildRetailSectionHeader('AI Recommendations', 'Based on your visits'),
        const SizedBox(height: 12),
        _buildProductGrid(_mockRecommendedProducts),

        const SizedBox(height: 32),

        // Trending Products
        _buildRetailSectionHeader('Trending Now', 'Popular this week'),
        const SizedBox(height: 12),
        _buildProductGrid(_mockTrendingProducts),

        const SizedBox(height: 32),

        // Your Watchlist
        _buildRetailSectionHeader('Your Watchlist', '4 products'),
        const SizedBox(height: 12),
        ..._mockWatchlistProducts.map((product) => _buildWatchlistProductCard(product)),

        const SizedBox(height: 32),

        // Deals & Offers
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

        const SizedBox(height: 16),
        _buildProductGrid(_mockDealProducts),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildRetailSectionHeader(String title, String subtitle) {
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
            },
          ),
        ],
      ),
    );
  }

  // Mock Data for Retail
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