import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/pro_profile.dart';
import 'rating_bar.dart';

/// Professional Profile Card
/// Displays a professional's profile in a compact card format
class ProProfileCard extends StatelessWidget {
  final ProProfile profile;
  final VoidCallback? onTap;
  final VoidCallback? onBookNow;
  final bool showBookButton;

  const ProProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onBookNow,
    this.showBookButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Photo + Name + Verification
              Row(
                children: [
                  // Profile Photo
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: CachedNetworkImageProvider(profile.photoUrl),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and Salon
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, size: 18, color: Colors.blue),
                            ],
                          ],
                        ),
                        if (profile.salonName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            profile.salonName!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                        if (profile.location != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 2),
                              Text(
                                profile.location!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Bio
              Text(
                profile.bio,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Services
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: profile.services.take(3).map((service) {
                  return Chip(
                    label: Text(
                      service,
                      style: const TextStyle(fontSize: 12),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 12),
              
              // Footer: Rating + Price Range + Book Button
              Row(
                children: [
                  // Rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRatingBar(
                          rating: profile.rating,
                          size: 16,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.reviewCount} reviews',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        if (profile.priceRange != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            profile.priceRange!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Book Button
                  if (showBookButton && onBookNow != null)
                    FilledButton(
                      onPressed: onBookNow,
                      child: const Text('Book Now'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

