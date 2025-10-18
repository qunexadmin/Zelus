import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/feature_flags.dart';
import '../../data/services/personalization_store.dart';

/// Follow Button
/// Button to follow/unfollow users or professionals
class FollowButton extends ConsumerStatefulWidget {
  final String userId;
  final bool initialFollowing;
  final int? followerCount;
  final VoidCallback? onFollowed;
  final VoidCallback? onUnfollowed;
  final ButtonStyle? followingStyle;
  final ButtonStyle? notFollowingStyle;
  final bool showFollowerCount;

  const FollowButton({
    super.key,
    required this.userId,
    this.initialFollowing = false,
    this.followerCount,
    this.onFollowed,
    this.onUnfollowed,
    this.followingStyle,
    this.notFollowingStyle,
    this.showFollowerCount = false,
  });

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  late bool _isFollowing;
  late int _followerCount;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialFollowing;
    _followerCount = widget.followerCount ?? 0;
    _loadFollowStatus();
  }

  Future<void> _loadFollowStatus() async {
    if (!FeatureFlags.follows) return;

    try {
      final store = await ref.read(personalizationStoreProvider.future);
      final followedIds = await store.getFollowedIds();
      if (mounted) {
        setState(() {
          _isFollowing = followedIds.contains(widget.userId);
        });
      }
    } catch (e) {
      print('Error loading follow status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.follows) {
      return const SizedBox.shrink();
    }

    return FilledButton.tonal(
      onPressed: _isLoading ? null : _toggleFollow,
      style: _isFollowing ? widget.followingStyle : widget.notFollowingStyle,
      child: _isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : widget.showFollowerCount
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_isFollowing ? 'Following' : 'Follow'),
                    if (widget.showFollowerCount && _followerCount > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '($_followerCount)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ],
                )
              : Text(_isFollowing ? 'Following' : 'Follow'),
    );
  }

  Future<void> _toggleFollow() async {
    setState(() => _isLoading = true);

    try {
      final store = await ref.read(personalizationStoreProvider.future);
      
      if (_isFollowing) {
        await store.unfollowUser(widget.userId);
        if (mounted) {
          setState(() {
            _isFollowing = false;
            if (widget.showFollowerCount) _followerCount--;
          });
          widget.onUnfollowed?.call();
        }
      } else {
        await store.followUser(widget.userId);
        if (mounted) {
          setState(() {
            _isFollowing = true;
            if (widget.showFollowerCount) _followerCount++;
          });
          widget.onFollowed?.call();
        }
      }
    } catch (e) {
      print('Error toggling follow: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

/// Compact Follow Button (icon only)
class FollowIconButton extends ConsumerStatefulWidget {
  final String userId;
  final bool initialFollowing;
  final VoidCallback? onFollowed;
  final VoidCallback? onUnfollowed;

  const FollowIconButton({
    super.key,
    required this.userId,
    this.initialFollowing = false,
    this.onFollowed,
    this.onUnfollowed,
  });

  @override
  ConsumerState<FollowIconButton> createState() => _FollowIconButtonState();
}

class _FollowIconButtonState extends ConsumerState<FollowIconButton> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialFollowing;
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.follows) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(
        _isFollowing ? Icons.person_remove : Icons.person_add,
        color: _isFollowing ? Colors.grey : Theme.of(context).primaryColor,
      ),
      onPressed: _toggleFollow,
    );
  }

  Future<void> _toggleFollow() async {
    try {
      final store = await ref.read(personalizationStoreProvider.future);
      
      if (_isFollowing) {
        await store.unfollowUser(widget.userId);
        widget.onUnfollowed?.call();
      } else {
        await store.followUser(widget.userId);
        widget.onFollowed?.call();
      }

      if (mounted) {
        setState(() => _isFollowing = !_isFollowing);
      }
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }
}

