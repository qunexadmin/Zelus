import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/models/salon.dart';
import 'rating_bar.dart';

/// Salon Card
/// Displays a salon in a card format
class SalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback? onTap;
  final bool showDistance;
  final double? distance; // in km

  const SalonCard({
    super.key,
    required this.salon,
    this.onTap,
    this.showDistance = false,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salon photo or placeholder
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildImage(),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and verified badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          salon.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (salon.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 18, color: Colors.blue),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getLocationString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showDistance && distance != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${distance!.toStringAsFixed(1)} km',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and review count
                  Row(
                    children: [
                      CustomRatingBar(
                        rating: salon.rating,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${salon.reviewCount})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  
                  // Services chips (show first 3)
                  if (salon.services.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: salon.services.take(3).map((service) {
                        return Chip(
                          label: Text(
                            service,
                            style: const TextStyle(fontSize: 10),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (salon.photos.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: salon.photos.first,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.store, size: 48, color: Colors.grey),
      ),
    );
  }

  String _getLocationString() {
    final parts = <String>[];
    if (salon.city != null) parts.add(salon.city!);
    if (salon.state != null) parts.add(salon.state!);
    return parts.isNotEmpty ? parts.join(', ') : salon.address;
  }
}

/// Compact Salon Card (horizontal list item)
class CompactSalonCard extends StatelessWidget {
  final Salon salon;
  final VoidCallback? onTap;

  const CompactSalonCard({
    super.key,
    required this.salon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: salon.photos.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: salon.photos.first,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.store),
                  ),
                )
              : const Icon(Icons.store, size: 40),
        ),
        title: Row(
          children: [
            Flexible(child: Text(salon.name)),
            if (salon.isVerified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, size: 16, color: Colors.blue),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${salon.city}, ${salon.state}'),
            Row(
              children: [
                CustomRatingBar(rating: salon.rating, size: 12),
                const SizedBox(width: 4),
                Text(
                  '(${salon.reviewCount})',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

