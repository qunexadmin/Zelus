import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/theme/app_theme.dart';

final feedProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/feed');
  final data = response.data as Map<String, dynamic>;
  final posts = (data['posts'] as List).cast<Map<String, dynamic>>();
  return posts;
});

final trendingProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/feed/trending');
  final data = response.data as Map<String, dynamic>;
  final posts = (data['posts'] as List).cast<Map<String, dynamic>>();
  return posts;
});

class FeedTab extends ConsumerWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ['For You', 'Trending', 'Following'];
    final tabController = DefaultTabController.of(context);
    final asyncPosts = ref.watch(feedProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Feed'),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/stylist-onboard');
                },
                icon: const Icon(Icons.brush, size: 18),
                label: const Text('Become a Stylist'),
              ),
              IconButton(
                tooltip: 'Reels',
                onPressed: () {
                  // Navigate to reels screen
                  Navigator.of(context).pushNamed('/reels');
                },
                icon: const Icon(Icons.play_circle_fill_outlined),
              ),
            ],
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'For You'),
                Tab(text: 'Trending'),
                Tab(text: 'Following'),
              ],
            ),
          ),
          // For You
          _buildPostsSliver(context, ref, feedProvider),
          // Trending
          _buildPostsSliver(context, ref, trendingProvider),
          // Following (same as For You for now)
          _buildPostsSliver(context, ref, feedProvider),
        ],
      ),
    );
  }
}

SliverPadding _buildPostsSliver(
  BuildContext context,
  WidgetRef ref,
  FutureProvider<List<Map<String, dynamic>>> provider,
) {
  final asyncPosts = ref.watch(provider);
  return SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    sliver: asyncPosts.when(
      data: (posts) => SliverList.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => _PostCard(post: posts[index]),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Failed to load feed: $e'),
        ),
      ),
    ),
  );
}

void _showOnboardDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Become a Stylist on Zelux'),
        content: const Text(
          'Create a stylist profile, showcase your work, and grow your following. ' 
          'Onboarding flow coming soon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // context.push('/stylist-onboard');
            },
            child: const Text('Get Started'),
          ),
        ],
      );
    },
  );
}

class _PostCard extends StatefulWidget {
  const _PostCard({required this.post});
  final Map<String, dynamic> post;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int likeCount;
  bool liked = false;
  bool isLoggedIn = false; // mock auth state for gating

  @override
  void initState() {
    super.initState();
    likeCount = (widget.post['likes'] as num).toInt();
  }

  void _toggleLike() {
    if (!isLoggedIn) {
      _promptLogin();
      return;
    }
    setState(() {
      liked = !liked;
      likeCount += liked ? 1 : -1;
    });
  }

  void _promptLogin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Zelux',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to like, comment, and follow your favorite stylists.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to login
                        // context.push('/login');
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Maybe Later'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTagSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final controller = TextEditingController();
        String mode = 'salon';
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tag this post', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'salon', label: Text('Salon')),
                      ButtonSegment(value: 'stylist', label: Text('Stylist')),
                    ],
                    selected: {mode},
                    onSelectionChanged: (s) {
                      mode = s.first;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search name...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tagged '+mode+' (mock).')),
                        );
                      },
                      child: const Text('Add Tag'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stylist = widget.post['stylist'] as Map<String, dynamic>;
    final caption = widget.post['caption'] as String? ?? '';
    final comments = (widget.post['comments'] as num?)?.toInt() ?? 0;
    final tags = (widget.post['tags'] as List?)?.cast<String>() ?? const [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                  child: const Icon(Icons.person, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stylist['name'] as String? ?? 'Stylist',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@${stylist['username']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                )
              ],
            ),
          ),

          // Media
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.cardGradient,
              ),
              child: const Center(
                child: Icon(Icons.photo, size: 64, color: Colors.grey),
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Colors.red : AppTheme.textSecondary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (!isLoggedIn) {
                      _promptLogin();
                      return;
                    }
                  },
                  icon: const Icon(Icons.mode_comment_outlined),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ],
            ),
          ),

          // Meta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '$likeCount likes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$comments comments',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Caption
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                caption,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

          // Tags + Add Tag
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...tags.map((t) => Chip(
                      label: Text(t),
                      backgroundColor: AppTheme.backgroundColor,
                    )),
                ActionChip(
                  label: const Text('Tag +'),
                  onPressed: () {
                    if (!isLoggedIn) {
                      _promptLogin();
                      return;
                    }
                    _showTagSheet(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


