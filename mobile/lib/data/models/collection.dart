import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

/// Collection Model
/// Represents a user's saved collection of posts
@freezed
class Collection with _$Collection {
  const factory Collection({
    required String id,
    required String userId,
    required String name,
    String? description,
    String? coverImageUrl,
    @Default([]) List<String> postIds,
    @Default(false) bool isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

