import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature_flags.dart';
import '../../core/theme/app_theme.dart';

/// Enhanced Collections Screen
/// Pinterest-style saved content with boards and organization
class CollectionsScreen extends ConsumerStatefulWidget {
  const CollectionsScreen({super.key});

  @override
  ConsumerState<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends ConsumerState<CollectionsScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = true;
  String _sortBy = 'recent'; // recent, name, count

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.collections) {
      return _buildComingSoon();
    }

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
                            'Saved',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: -1.2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your inspiration collection',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Create Collection button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showCreateCollectionDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search & Filter Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search collections...',
                          hintStyle: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                          prefixIcon: const Icon(
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

                    const SizedBox(height: 16),

                    // View Toggle & Sort
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // View toggle
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.grid_view,
                                  color: _isGridView ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _isGridView = true);
                                },
                              ),
                              Container(
                                width: 1,
                                height: 20,
                                color: AppTheme.borderLight,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.view_list,
                                  color: !_isGridView ? AppTheme.primaryColor : AppTheme.textSecondary,
                                  size: 20,
                                ),
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _isGridView = false);
                                },
                              ),
                            ],
                          ),
                        ),

                        // Sort dropdown
                        PopupMenuButton<String>(
                          initialValue: _sortBy,
                          onSelected: (value) {
                            HapticFeedback.selectionClick();
                            setState(() => _sortBy = value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'recent',
                              child: Text('Recently Added'),
                            ),
                            const PopupMenuItem(
                              value: 'name',
                              child: Text('Name (A-Z)'),
                            ),
                            const PopupMenuItem(
                              value: 'count',
                              child: Text('Most Items'),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort, size: 18, color: AppTheme.primaryColor),
                                const SizedBox(width: 6),
                                Text(
                                  _getSortLabel(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down, size: 18, color: AppTheme.primaryColor),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: _buildQuickStats(),
            ),

            // Recent Saves Section
            SliverToBoxAdapter(
              child: _buildRecentSaves(),
            ),

            // Collections Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Collections',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      '${_getMockCollections().length} boards',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Collections Grid/List
            _isGridView
                ? _buildCollectionsGrid()
                : _buildCollectionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoon() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_outline,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Collections Coming Soon!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Save your favorite styles, professionals, and salons',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentLight, AppTheme.accentLight.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat(Icons.collections_bookmark, '8', 'Collections'),
          _buildStatDivider(),
          _buildQuickStat(Icons.favorite, '156', 'Saved Items'),
          _buildStatDivider(),
          _buildQuickStat(Icons.trending_up, '24', 'This Month'),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 50,
      color: AppTheme.accentColor.withOpacity(0.2),
    );
  }

  Widget _buildRecentSaves() {
    final recentItems = [
      {'name': 'Beach Waves', 'type': 'Style', 'image': 'https://via.placeholder.com/150'},
      {'name': 'Jane Smith', 'type': 'Stylist', 'image': 'https://via.placeholder.com/150'},
      {'name': 'Balayage Look', 'type': 'Style', 'image': 'https://via.placeholder.com/150'},
      {'name': 'Elite Studio', 'type': 'Salon', 'image': 'https://via.placeholder.com/150'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recently Saved',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // View all recent saves
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recentItems.length,
            itemBuilder: (context, index) {
              final item = recentItems[index];
              return _buildRecentItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItem(Map<String, String> item) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image, size: 32, color: AppTheme.textTertiary),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['type']!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item['name']!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsGrid() {
    final collections = _getMockCollections();

    if (collections.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final collection = collections[index];
            return _buildCollectionCard(collection);
          },
          childCount: collections.length,
        ),
      ),
    );
  }

  Widget _buildCollectionsList() {
    final collections = _getMockCollections();

    if (collections.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final collection = collections[index];
            return _buildCollectionListItem(collection);
          },
          childCount: collections.length,
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, dynamic> collection) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _openCollection(collection);
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showCollectionOptions(collection);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with stacked preview
            Expanded(
              child: Stack(
                children: [
                  // Main cover
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: collection['images'] != null && (collection['images'] as List).isNotEmpty
                          ? _buildImageGrid(collection['images'] as List<String>)
                          : const Center(
                              child: Icon(
                                Icons.collections,
                                size: 48,
                                color: AppTheme.accentColor,
                              ),
                            ),
                    ),
                  ),
                  // Bookmark badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Collection Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.photo_library,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${collection['count']} items',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Spacer(),
                      if (collection['private'] == true)
                        const Icon(
                          Icons.lock,
                          size: 14,
                          color: AppTheme.textTertiary,
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

  Widget _buildImageGrid(List<String> images) {
    if (images.length == 1) {
      return Image.network(
        images[0],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.collections, size: 48, color: AppTheme.textTertiary),
        ),
      );
    }

    // 2x2 grid for multiple images
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: images.length > 4 ? 4 : images.length,
      itemBuilder: (context, index) {
        return Image.network(
          images[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppTheme.surfaceColor,
            child: const Center(
              child: Icon(Icons.image, size: 24, color: AppTheme.textTertiary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollectionListItem(Map<String, dynamic> collection) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _openCollection(collection);
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _showCollectionOptions(collection);
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: collection['images'] != null && (collection['images'] as List).isNotEmpty
                      ? Image.network(
                          (collection['images'] as List<String>)[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.collections, size: 32, color: AppTheme.accentColor),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.collections, size: 32, color: AppTheme.accentColor),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${collection['count']} items',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (collection['description'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        collection['description'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (collection['private'] == true)
                    const Icon(
                      Icons.lock,
                      size: 16,
                      color: AppTheme.textTertiary,
                    ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.collections_bookmark_outlined,
              size: 64,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No collections yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start saving your favorite styles, professionals, and salons',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showCreateCollectionDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Collection'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockCollections() {
    // TODO: Load from service
    return [
      {
        'id': '1',
        'name': 'Summer Styles',
        'description': 'Beach-ready hair inspiration',
        'count': 24,
        'private': false,
        'images': [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
        ],
      },
      {
        'id': '2',
        'name': 'Color Inspiration',
        'description': 'Bold and beautiful color ideas',
        'count': 42,
        'private': false,
        'images': [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
        ],
      },
      {
        'id': '3',
        'name': 'Short Hair',
        'description': 'Chic short cuts and styles',
        'count': 18,
        'private': true,
        'images': [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
        ],
      },
      {
        'id': '4',
        'name': 'Wedding Ideas',
        'description': 'Bridal hairstyles and inspiration',
        'count': 36,
        'private': false,
        'images': [
          'https://via.placeholder.com/150',
        ],
      },
      {
        'id': '5',
        'name': 'Favorite Stylists',
        'description': 'My go-to professionals',
        'count': 8,
        'private': true,
        'images': [],
      },
      {
        'id': '6',
        'name': 'Balayage Looks',
        'description': 'Natural balayage techniques',
        'count': 31,
        'private': false,
        'images': [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
        ],
      },
    ];
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'recent':
        return 'Recent';
      case 'name':
        return 'Name';
      case 'count':
        return 'Most Items';
      default:
        return 'Sort';
    }
  }

  void _openCollection(Map<String, dynamic> collection) {
    // TODO: Navigate to collection detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${collection['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showCollectionOptions(Map<String, dynamic> collection) {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                collection['name'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Collection'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                _editCollection(collection);
              },
            ),
            ListTile(
              leading: Icon(
                collection['private'] == true ? Icons.lock_open_outlined : Icons.lock_outlined,
              ),
              title: Text(collection['private'] == true ? 'Make Public' : 'Make Private'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Collection'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
              title: const Text(
                'Delete Collection',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                _deleteCollection(collection);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Create Collection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
                decoration: const InputDecoration(
                  labelText: 'Collection name',
                  hintText: 'e.g., Summer Hair Ideas',
                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'What is this collection about?',
                  hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: isPrivate,
                onChanged: (value) {
                  setDialogState(() => isPrivate = value);
                },
                title: const Text(
                  'Private Collection',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Only you can see this',
                  style: TextStyle(fontSize: 12),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
              ),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                // TODO: Create collection
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Created "${nameController.text}"'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _editCollection(Map<String, dynamic> collection) {
    // TODO: Show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${collection['name']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteCollection(Map<String, dynamic> collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Collection?'),
        content: Text(
          'Are you sure you want to delete "${collection['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${collection['name']}"'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}