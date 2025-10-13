import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_asset.freezed.dart';
part 'stream_asset.g.dart';

/// Stream Asset Model
/// Represents a video asset uploaded to Cloudflare Stream
@freezed
class StreamAsset with _$StreamAsset {
  const factory StreamAsset({
    required String uid,
    required String playbackId,
    String? thumbnailUrl,
    String? hlsUrl,
    String? dashUrl,
    int? duration,
    int? size,
    @Default('pending') String status, // pending, ready, error
    DateTime? createdAt,
  }) = _StreamAsset;

  factory StreamAsset.fromJson(Map<String, dynamic> json) =>
      _$StreamAssetFromJson(json);
}

