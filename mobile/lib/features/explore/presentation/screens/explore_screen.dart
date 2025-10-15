import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/services/profile_service.dart';
import '../../../../data/services/salon_service.dart';
import '../../../../core/widgets/pro_profile_card.dart';
import '../../../../core/theme/app_theme.dart';

/// Explore Screen
/// Discovery page with filters and search
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String? _selectedCity;
  String? _selectedService;
  double? _minRating;

  final List<String> _cities = ['New York', 'San Francisco', 'Los Angeles', 'Chicago'];
  final List<String> _services = ['Haircut', 'Color', 'Balayage', 'Styling', 'Extensions'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header - Matching Design System
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: AppTheme.primaryColor),
            onPressed: () {
                        HapticFeedback.lightImpact();
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
                    ),
          ),
        ],
      ),
            ),
            
          // Filters
          _buildFilters(),
          
            const Divider(height: 1, color: AppTheme.borderLight),
          
          // Content Tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                    TabBar(
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
                      Tab(text: 'Professionals'),
                      Tab(text: 'Salons'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildProfessionalsTab(),
                        _buildSalonsTab(),
                      ],
                    ),
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

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
                ),
          ),
          const SizedBox(height: 12),
          
          // Filter chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // City filter
                _buildFilterChip(
                  label: _selectedCity ?? 'City',
                  selected: _selectedCity != null,
                  onTap: () => _showCityPicker(),
                ),
                const SizedBox(width: 8),
                
                // Service filter
                _buildFilterChip(
                  label: _selectedService ?? 'Service',
                  selected: _selectedService != null,
                  onTap: () => _showServicePicker(),
                ),
                const SizedBox(width: 8),
                
                // Rating filter
                _buildFilterChip(
                  label: _minRating != null ? '$_minRating+ ⭐' : 'Rating',
                  selected: _minRating != null,
                  onTap: () => _showRatingPicker(),
                ),
                const SizedBox(width: 8),
                
                // Clear filters
                if (_selectedCity != null || _selectedService != null || _minRating != null)
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _clearFilters();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
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

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      backgroundColor: selected ? AppTheme.accentLight : AppTheme.surfaceColor,
      side: BorderSide(
        color: selected ? AppTheme.primaryColor : AppTheme.borderLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildProfessionalsTab() {
    final profilesAsync = ref.watch(profilesProvider);

    return profilesAsync.when(
      data: (profiles) {
        // Apply filters
        var filteredProfiles = profiles;
        
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
        
        if (_minRating != null) {
          filteredProfiles = filteredProfiles
              .where((p) => p.rating >= _minRating!)
              .toList();
        }

        if (filteredProfiles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_search_outlined, size: 64, color: AppTheme.textTertiary),
                SizedBox(height: 16),
                Text(
                  'No professionals found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

                        return RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await Future.delayed(const Duration(milliseconds: 800));
            ref.invalidate(profilesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
          itemCount: filteredProfiles.length,
          itemBuilder: (context, index) {
            final profile = filteredProfiles[index];
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
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            const Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 16,
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

        if (filteredSalons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.store_outlined, size: 64, color: AppTheme.textTertiary),
                SizedBox(height: 16),
                Text(
                  'No salons found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            await Future.delayed(const Duration(milliseconds: 800));
            ref.invalidate(salonsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
          itemCount: filteredSalons.length,
          itemBuilder: (context, index) {
            final salon = filteredSalons[index];
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
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            const Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 16,
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
          ],
        ),
      ),
    );
  }

  void _showCityPicker() {
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
    );
  }

  void _showServicePicker() {
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
    );
  }

  void _showRatingPicker() {
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
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCity = null;
      _selectedService = null;
      _minRating = null;
    });
  }
}

