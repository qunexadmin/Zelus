import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/feature_flags.dart';

/// Collections Screen
/// Displays user's saved collections
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!FeatureFlags.collections) {
      return Scaffold(
        appBar: AppBar(title: const Text('Collections')),
        body: const Center(
          child: Text('Collections feature coming soon!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCollectionDialog(context),
          ),
        ],
      ),
      body: _buildCollectionsList(context),
    );
  }

  Widget _buildCollectionsList(BuildContext context) {
    // TODO: Load actual collections from service
    final mockCollections = [
      {'name': 'Summer Styles', 'count': 12, 'cover': 'https://via.placeholder.com/150'},
      {'name': 'Color Inspiration', 'count': 24, 'cover': 'https://via.placeholder.com/150'},
      {'name': 'Short Hair Ideas', 'count': 8, 'cover': 'https://via.placeholder.com/150'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: mockCollections.length,
      itemBuilder: (context, index) {
        final collection = mockCollections[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to collection detail
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening ${collection['name']}')),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    collection['cover'] as String,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${collection['count']} items',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Collection'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Collection name',
            hintText: 'e.g., Summer Hair Ideas',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Create collection
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Collection created!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

