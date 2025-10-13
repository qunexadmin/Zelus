import 'package:freezed_annotation/freezed_annotation.dart';

part 'oembed_data.freezed.dart';
part 'oembed_data.g.dart';

/// oEmbed Data Model
/// Represents embedded content from external platforms (Instagram, TikTok)
@freezed
class OEmbedData with _$OEmbedData {
  const factory OEmbedData({
    required String url,
    required String platform, // 'instagram' or 'tiktok'
    required String html,
    String? title,
    String? authorName,
    String? authorUrl,
    String? thumbnailUrl,
    int? width,
    int? height,
    DateTime? fetchedAt,
  }) = _OEmbedData;

  factory OEmbedData.fromJson(Map<String, dynamic> json) =>
      _$OEmbedDataFromJson(json);
}
