import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feature_flags.dart';
import '../../data/services/feed_service.dart';

/// Save Button
/// Button to save/unsave posts to collections
class SaveButton extends ConsumerStatefulWidget {
  final String postId;
  final bool initialSaved;
  final VoidCallback? onSaved;
  final VoidCallback? onUnsaved;
  final IconData savedIcon;
  final IconData unsavedIcon;
  final Color? savedColor;

  const SaveButton({
    super.key,
    required this.postId,
    this.initialSaved = false,
    this.onSaved,
    this.onUnsaved,
    this.savedIcon = Icons.bookmark,
    this.unsavedIcon = Icons.bookmark_border,
    this.savedColor = Colors.amber,
  });

  @override
  ConsumerState<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<SaveButton>
    with SingleTickerProviderStateMixin {
  late bool _isSaved;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialSaved;
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.saves) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          _isSaved ? widget.savedIcon : widget.unsavedIcon,
          color: _isSaved ? widget.savedColor : null,
        ),
        onPressed: _toggleSave,
      ),
    );
  }

  Future<void> _toggleSave() async {
    // Animate
    await _controller.forward();
    await _controller.reverse();

    // Toggle state
    setState(() => _isSaved = !_isSaved);

    // Call service
    try {
      final feedService = ref.read(feedServiceProvider);
      if (_isSaved) {
        await feedService.savePost(widget.postId);
        widget.onSaved?.call();
      } else {
        await feedService.unsavePost(widget.postId);
        widget.onUnsaved?.call();
      }
    } catch (e) {
      print('Error toggling save: $e');
      // Revert on error
      setState(() => _isSaved = !_isSaved);
    }
  }
}

/// Save Button with Count
class SaveButtonWithCount extends ConsumerWidget {
  final String postId;
  final bool initialSaved;
  final int saveCount;
  final VoidCallback? onSaved;
  final VoidCallback? onUnsaved;

  const SaveButtonWithCount({
    super.key,
    required this.postId,
    this.initialSaved = false,
    this.saveCount = 0,
    this.onSaved,
    this.onUnsaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SaveButton(
          postId: postId,
          initialSaved: initialSaved,
          onSaved: onSaved,
          onUnsaved: onUnsaved,
        ),
        if (saveCount > 0)
          Text(
            _formatCount(saveCount),
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

