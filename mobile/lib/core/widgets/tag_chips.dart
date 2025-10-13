import 'package:flutter/material.dart';

/// Tag Chips
/// Displays content tags as interactive chips
class TagChips extends StatelessWidget {
  final List<String> tags;
  final Function(String)? onTagTap;
  final int maxDisplay;
  final bool wrap;

  const TagChips({
    super.key,
    required this.tags,
    this.onTagTap,
    this.maxDisplay = 5,
    this.wrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayTags = tags.take(maxDisplay).toList();
    final hasMore = tags.length > maxDisplay;

    if (wrap) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...displayTags.map((tag) => _buildTagChip(context, tag)),
          if (hasMore)
            Chip(
              label: Text(
                '+${tags.length - maxDisplay}',
                style: const TextStyle(fontSize: 12),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayTags.map((tag) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _buildTagChip(context, tag),
              )),
          if (hasMore)
            Chip(
              label: Text(
                '+${tags.length - maxDisplay}',
                style: const TextStyle(fontSize: 12),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    return ActionChip(
      label: Text(
        tag,
        style: const TextStyle(fontSize: 12),
      ),
      onPressed: onTagTap != null ? () => onTagTap!(tag) : null,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

