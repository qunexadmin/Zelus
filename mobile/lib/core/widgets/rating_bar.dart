import 'package:flutter/material.dart';

/// Custom Rating Bar
/// Displays star ratings with half-star support
class CustomRatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final int starCount;

  const CustomRatingBar({
    super.key,
    required this.rating,
    this.size = 20,
    this.color = Colors.amber,
    this.starCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        final starRating = index + 1;
        IconData icon;

        if (rating >= starRating) {
          icon = Icons.star;
        } else if (rating >= starRating - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(
          icon,
          size: size,
          color: color,
        );
      }),
    );
  }
}

/// Rating Bar with value display
class RatingBarWithValue extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingBarWithValue({
    super.key,
    required this.rating,
    this.size = 20,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomRatingBar(
          rating: rating,
          size: size,
          color: color,
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size * 0.8,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

