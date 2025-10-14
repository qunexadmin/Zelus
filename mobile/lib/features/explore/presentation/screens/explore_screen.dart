import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/profile_service.dart';
import '../../../../data/services/salon_service.dart';
import '../../../../core/widgets/pro_profile_card.dart';
// Removed in-app booking; booking is external link on profiles/salons

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
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(),
          
          const Divider(height: 1),
          
          // Content Tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
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
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
                    onPressed: _clearFilters,
                    child: const Text('Clear All'),
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
      label: Text(label),
      onPressed: onTap,
      backgroundColor: selected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      side: BorderSide(
        color: selected ? Theme.of(context).primaryColor : Colors.grey[300]!,
      ),
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
          return const Center(
            child: Text('No professionals found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredProfiles.length,
          itemBuilder: (context, index) {
            final profile = filteredProfiles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProProfileCard(
                profile: profile,
                onTap: () => context.push('/pros/${profile.id}'),
                onBookNow: () => BookingRequestSheet.show(
                  context,
                  proId: profile.id,
                  salonId: profile.salonId,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
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
          return const Center(
            child: Text('No salons found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredSalons.length,
          itemBuilder: (context, index) {
            final salon = filteredSalons[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: salon.photos.isNotEmpty
                    ? Image.network(salon.photos.first, width: 60, height: 60, fit: BoxFit.cover)
                    : const Icon(Icons.store, size: 60),
                title: Text(salon.name),
                subtitle: Text('${salon.city}, ${salon.state}\n${salon.rating} ⭐ (${salon.reviewCount} reviews)'),
                isThreeLine: true,
                onTap: () => context.push('/salon/${salon.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _cities.map((city) {
          return ListTile(
            title: Text(city),
            selected: _selectedCity == city,
            onTap: () {
              setState(() => _selectedCity = city);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showServicePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: _services.map((service) {
          return ListTile(
            title: Text(service),
            selected: _selectedService == service,
            onTap: () {
              setState(() => _selectedService = service);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showRatingPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [4.5, 4.0, 3.5, 3.0].map((rating) {
          return ListTile(
            title: Text('$rating+ Stars'),
            selected: _minRating == rating,
            onTap: () {
              setState(() => _minRating = rating);
              Navigator.pop(context);
            },
          );
        }).toList(),
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

