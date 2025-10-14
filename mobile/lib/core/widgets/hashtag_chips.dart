import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; 

/// Hashtag Chips
/// Displays hashtags as interactive chips with # prefix
class HashtagChips extends StatelessWidget {
  final List<String> hashtags;
  final Function(String)? onHashtagTap;
  final int maxDisplay;
  final bool wrap;
  final Color? chipColor;

  const HashtagChips({
    super.key,
    required this.hashtags,
    this.onHashtagTap,
    this.maxDisplay = 5,
    this.wrap = true,
    this.chipColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayHashtags = hashtags.take(maxDisplay).toList();
    final hasMore = hashtags.length > maxDisplay;

    if (wrap) {
      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...displayHashtags.map((hashtag) => _buildHashtagChip(context, hashtag)),
          if (hasMore)
            Chip(
              label: Text(
                '+${hashtags.length - maxDisplay}',
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
          ...displayHashtags.map((hashtag) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _buildHashtagChip(context, hashtag),
              )),
          if (hasMore)
            Chip(
              label: Text(
                '+${hashtags.length - maxDisplay}',
                style: const TextStyle(fontSize: 12),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Widget _buildHashtagChip(BuildContext context, String hashtag) {
    // Ensure hashtag starts with #
    final displayText = hashtag.startsWith('#') ? hashtag : '#$hashtag';

    return ActionChip(
      label: Text(
        displayText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onHashtagTap != null ? () => onHashtagTap!(hashtag) : null,
      backgroundColor: chipColor ?? Colors.blue[50],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Hashtag Text Parser
/// Utility to detect and make hashtags clickable in text
class HashtagText extends StatelessWidget {
  final String text;
  final Function(String)? onHashtagTap;
  final TextStyle? textStyle;
  final TextStyle? hashtagStyle;

  const HashtagText({
    super.key,
    required this.text,
    this.onHashtagTap,
    this.textStyle,
    this.hashtagStyle,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'#\w+');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before hashtag
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: textStyle,
        ));
      }

      // Add hashtag
      spans.add(TextSpan(
        text: match.group(0),
        style: hashtagStyle ??
            const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
        recognizer: onHashtagTap != null
            ? (TapGestureRecognizer()
              ..onTap = () => onHashtagTap!(match.group(0)!))
            : null,
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: textStyle,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}