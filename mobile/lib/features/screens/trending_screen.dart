import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/feed_service.dart';
import '../../core/widgets/embedded_post_widget.dart';
import '../../core/widgets/media_tile.dart';
import '../../core/feature_flags.dart';

/// Trending Screen
/// Shows trending content including external posts from Instagram/TikTok
class TrendingScreen extends ConsumerWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingFeedAsync = ref.watch(trendingFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Now'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Trending'),
                  content: const Text(
                    'Trending content includes posts from beauty professionals '
                    'and popular content from Instagram and TikTok.\n\n'
                    'External content is properly attributed to creators.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: trendingFeedAsync.when(
        data: (feedItems) {
          if (feedItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No trending content yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final item = feedItems[index];

              // Show external posts with oEmbed if enabled
              if (FeatureFlags.externalTrends && 
                  item.externalSource != null && 
                  item.externalUrl != null) {
                return _buildExternalPost(context, item);
              }

              // Show internal content
              return _buildInternalPost(context, item);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.refresh(trendingFeedProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExternalPost(BuildContext context, item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: item.creatorPhotoUrl != null
                  ? NetworkImage(item.creatorPhotoUrl!)
                  : null,
              child: item.creatorPhotoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(item.creatorName),
            subtitle: Text(
              '${item.externalSource} • ${item.externalHandle ?? ""}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Chip(
              label: Text(
                'EXTERNAL',
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.orange[100],
            ),
          ),

          // Embedded content
          if (item.externalUrl != null)
            EmbeddedPostWidget(
              url: item.externalUrl!,
              height: 500,
            ),

          // Engagement stats
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${item.likeCount}'),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${item.commentCount}'),
                const SizedBox(width: 16),
                Icon(Icons.visibility_outlined, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${item.viewCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalPost(BuildContext context, item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: item.creatorPhotoUrl != null
                  ? NetworkImage(item.creatorPhotoUrl!)
                  : null,
              child: item.creatorPhotoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(item.creatorName),
            subtitle: item.location != null ? Text(item.location!) : null,
            trailing: const Icon(Icons.more_vert),
          ),

          // Media
          MediaTile(
            mediaType: item.mediaType,
            mediaUrl: item.mediaUrl,
            thumbnailUrl: item.thumbnailUrl,
            height: 400,
            onTap: () {
              // TODO: Open full post detail
            },
          ),

          // Caption
          if (item.caption != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item.caption!),
            ),

          // Hashtags
          if (item.hashtags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 4,
                children: item.hashtags.take(3).map((tag) {
                  return Text(
                    tag,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),

          // Engagement
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text('${item.likeCount}'),
                const SizedBox(width: 16),
                Icon(Icons.comment, size: 20),
                const SizedBox(width: 4),
                Text('${item.commentCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

