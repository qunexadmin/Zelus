import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity_post.dart';
import 'personalization_store.dart';

/// Activity Feed Service
/// Provides activity posts from followed stylists
class ActivityFeedService {
  final PersonalizationStore _personalizationStore;

  ActivityFeedService(this._personalizationStore);

  /// Get activity feed for followed stylists
  Future<List<ActivityPost>> getFeed() async {
    final followedIds = await _personalizationStore.getFollowedIds();
    
    // Get all mock posts
    final allPosts = _getMockPosts();
    
    // Filter posts to only show from followed stylists
    if (followedIds.isEmpty) {
      return [];
    }
    
    final filteredPosts = allPosts
        .where((post) => followedIds.contains(post.stylistId))
        .toList();
    
    // Sort by date descending (most recent first)
    filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filteredPosts;
  }

  /// Get all posts (for when user follows someone new)
  Future<List<ActivityPost>> getAllPosts() async {
    final posts = _getMockPosts();
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  /// Mock data - 15 sample posts
  List<ActivityPost> _getMockPosts() {
    final now = DateTime.now();

    return [
      // Recent portfolio upload - employed stylist
      ActivityPost(
        id: 'post_1',
        stylistId: 'stylist_1',
        stylistName: 'Maria Rodriguez',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=maria',
        salonName: 'Luxe Beauty Studio',
        type: ActivityPostType.portfolioUpload,
        content: 'Just finished this stunning balayage transformation! 🌟 From dark brown to sun-kissed caramel.',
        images: [
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=600',
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600',
        ],
        createdAt: now.subtract(const Duration(hours: 2)),
        likeCount: 156,
        commentCount: 23,
      ),

      // Promotion - independent stylist
      ActivityPost(
        id: 'post_2',
        stylistId: 'stylist_2',
        stylistName: 'James Chen',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=james',
        type: ActivityPostType.promotion,
        content: '🎉 Spring Special! 20% off all color services this week. Book now to secure your spot!',
        promotionDetails: '20% off color services',
        createdAt: now.subtract(const Duration(hours: 5)),
        likeCount: 89,
        commentCount: 12,
      ),

      // New service - employed stylist
      ActivityPost(
        id: 'post_3',
        stylistId: 'stylist_3',
        stylistName: 'Sarah Johnson',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=sarah',
        salonName: 'The Hair Lounge',
        type: ActivityPostType.newService,
        content: 'Excited to offer a new service! 💇 Introducing Keratin Express Treatment for smoother, more manageable hair.',
        serviceName: 'Keratin Express Treatment',
        servicePrice: 125.00,
        createdAt: now.subtract(const Duration(hours: 8)),
        likeCount: 67,
        commentCount: 8,
      ),

      // Location change
      ActivityPost(
        id: 'post_4',
        stylistId: 'stylist_4',
        stylistName: 'Michael Brown',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=michael',
        salonName: 'Artisan Hair Studio',
        type: ActivityPostType.locationChange,
        content: '📍 Big news! I\'ve joined the amazing team at Artisan Hair Studio downtown. Same great service, new beautiful location!',
        previousLocation: 'Style & Grace Salon',
        newLocation: 'Artisan Hair Studio - 123 Main St',
        createdAt: now.subtract(const Duration(days: 1)),
        likeCount: 234,
        commentCount: 45,
      ),

      // Portfolio upload
      ActivityPost(
        id: 'post_5',
        stylistId: 'stylist_1',
        stylistName: 'Maria Rodriguez',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=maria',
        salonName: 'Luxe Beauty Studio',
        type: ActivityPostType.portfolioUpload,
        content: 'Loving these rose gold highlights! Perfect for spring 🌸',
        imageUrl: 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=600',
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
        likeCount: 198,
        commentCount: 31,
      ),

      // New service - independent
      ActivityPost(
        id: 'post_6',
        stylistId: 'stylist_2',
        stylistName: 'James Chen',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=james',
        type: ActivityPostType.newService,
        content: 'Now offering Men\'s Grooming Packages! Haircut, beard trim, and styling all in one session.',
        serviceName: 'Men\'s Complete Grooming',
        servicePrice: 85.00,
        createdAt: now.subtract(const Duration(days: 2)),
        likeCount: 45,
        commentCount: 6,
      ),

      // Promotion
      ActivityPost(
        id: 'post_7',
        stylistId: 'stylist_3',
        stylistName: 'Sarah Johnson',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=sarah',
        salonName: 'The Hair Lounge',
        type: ActivityPostType.promotion,
        content: '🎊 First-time clients get 15% off any service! Refer a friend and both get 10% off your next visit.',
        promotionDetails: '15% off for new clients',
        createdAt: now.subtract(const Duration(days: 2, hours: 4)),
        likeCount: 112,
        commentCount: 19,
      ),

      // Portfolio upload - multiple images
      ActivityPost(
        id: 'post_8',
        stylistId: 'stylist_4',
        stylistName: 'Michael Brown',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=michael',
        salonName: 'Artisan Hair Studio',
        type: ActivityPostType.portfolioUpload,
        content: 'Before & After: Complete hair transformation! Sometimes change is exactly what you need ✂️✨',
        images: [
          'https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=600',
          'https://images.unsplash.com/photo-1492106087820-71f1a00d2b11?w=600',
        ],
        createdAt: now.subtract(const Duration(days: 3)),
        likeCount: 289,
        commentCount: 52,
      ),

      // Portfolio upload
      ActivityPost(
        id: 'post_9',
        stylistId: 'stylist_5',
        stylistName: 'Emma Davis',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=emma',
        type: ActivityPostType.portfolioUpload,
        content: 'Bridal hair day! Love creating these elegant updos for special occasions 👰💕',
        imageUrl: 'https://images.unsplash.com/photo-1487412912498-0447578fcca8?w=600',
        createdAt: now.subtract(const Duration(days: 3, hours: 8)),
        likeCount: 203,
        commentCount: 28,
      ),

      // New service
      ActivityPost(
        id: 'post_10',
        stylistId: 'stylist_5',
        stylistName: 'Emma Davis',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=emma',
        type: ActivityPostType.newService,
        content: 'Introducing Bridal Package: Trial + wedding day styling, includes accessories consultation! 💍',
        serviceName: 'Complete Bridal Package',
        servicePrice: 350.00,
        createdAt: now.subtract(const Duration(days: 4)),
        likeCount: 91,
        commentCount: 15,
      ),

      // Promotion - holiday themed
      ActivityPost(
        id: 'post_11',
        stylistId: 'stylist_1',
        stylistName: 'Maria Rodriguez',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=maria',
        salonName: 'Luxe Beauty Studio',
        type: ActivityPostType.promotion,
        content: '🌟 Weekend Special: Book any color service and get a free deep conditioning treatment! Limited spots available.',
        promotionDetails: 'Free deep conditioning with color',
        createdAt: now.subtract(const Duration(days: 5)),
        likeCount: 167,
        commentCount: 34,
      ),

      // Portfolio upload
      ActivityPost(
        id: 'post_12',
        stylistId: 'stylist_2',
        stylistName: 'James Chen',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=james',
        type: ActivityPostType.portfolioUpload,
        content: 'Classic fade with a modern twist. Clean lines, sharp finish 💈',
        imageUrl: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=600',
        createdAt: now.subtract(const Duration(days: 5, hours: 12)),
        likeCount: 134,
        commentCount: 17,
      ),

      // Location change - going independent
      ActivityPost(
        id: 'post_13',
        stylistId: 'stylist_5',
        stylistName: 'Emma Davis',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=emma',
        type: ActivityPostType.locationChange,
        content: '📍 Exciting update! I\'m opening my own studio! Check out my new private salon space. Still the same Emma, better experience!',
        previousLocation: 'Various locations',
        newLocation: 'Emma\'s Private Studio - 456 Oak Ave',
        createdAt: now.subtract(const Duration(days: 6)),
        likeCount: 412,
        commentCount: 89,
      ),

      // Portfolio upload
      ActivityPost(
        id: 'post_14',
        stylistId: 'stylist_3',
        stylistName: 'Sarah Johnson',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=sarah',
        salonName: 'The Hair Lounge',
        type: ActivityPostType.portfolioUpload,
        content: 'Dimensional color magic ✨ Love how these tones blend together!',
        imageUrl: 'https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?w=600',
        createdAt: now.subtract(const Duration(days: 6, hours: 18)),
        likeCount: 178,
        commentCount: 22,
      ),

      // Promotion - seasonal
      ActivityPost(
        id: 'post_15',
        stylistId: 'stylist_4',
        stylistName: 'Michael Brown',
        stylistPhotoUrl: 'https://i.pravatar.cc/150?u=michael',
        salonName: 'Artisan Hair Studio',
        type: ActivityPostType.promotion,
        content: '🎉 Celebrating our new location! This week only: 25% off all services for existing clients who book within 48 hours!',
        promotionDetails: '25% off all services',
        createdAt: now.subtract(const Duration(days: 7)),
        likeCount: 256,
        commentCount: 47,
      ),
    ];
  }
}

/// Riverpod Provider
final activityFeedServiceProvider = FutureProvider<ActivityFeedService>((ref) async {
  final store = await ref.watch(personalizationStoreProvider.future);
  return ActivityFeedService(store);
});

/// Feed provider
final activityFeedProvider = FutureProvider<List<ActivityPost>>((ref) async {
  final service = await ref.watch(activityFeedServiceProvider.future);
  return service.getFeed();
});

