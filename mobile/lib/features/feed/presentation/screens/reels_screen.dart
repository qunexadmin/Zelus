import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';

final reelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('/feed/trending');
  final data = response.data as Map<String, dynamic>;
  final posts = (data['posts'] as List).cast<Map<String, dynamic>>();
  return posts;
});

class ReelsScreen extends ConsumerWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(reelsProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: asyncPosts.when(
        data: (posts) {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (context, index) => _Reel(post: posts[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, st) => Center(
          child: Text('Failed to load reels: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class _Reel extends StatefulWidget {
  const _Reel({required this.post});
  final Map<String, dynamic> post;

  @override
  State<_Reel> createState() => _ReelState();
}

class _ReelState extends State<_Reel> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    final stylist = widget.post['stylist'] as Map<String, dynamic>;
    final caption = widget.post['caption'] as String? ?? '';
    final likes = (widget.post['likes'] as num?)?.toInt() ?? 0;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Mock video area
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Bottom caption/author
        Positioned(
          left: 16,
          right: 80,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${stylist['username']}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        // Right actions
        Positioned(
          right: 16,
          bottom: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => setState(() => liked = !liked),
                iconSize: 30,
                color: liked ? Colors.redAccent : Colors.white,
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
              ),
              Text('${likes + (liked ? 1 : 0)}', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () {},
                iconSize: 28,
                color: Colors.white,
                icon: const Icon(Icons.mode_comment_outlined),
              ),
              const SizedBox(height: 12),
              IconButton(
                onPressed: () {},
                iconSize: 28,
                color: Colors.white,
                icon: const Icon(Icons.share_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



