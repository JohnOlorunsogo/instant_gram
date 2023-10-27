import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/enums/date_sorting.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';

@immutable
class RequestForPostAndComments {
  final PostId postId;
  final bool sortByCreatedAt;
  final DateSorting dateSorting;
  final int? limit;

  const RequestForPostAndComments({
    this.dateSorting = DateSorting.newestOnTop,
    this.limit,
    required this.postId,
    this.sortByCreatedAt = true,
  });

  @override
  bool operator ==(covariant RequestForPostAndComments other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          postId == other.postId &&
          sortByCreatedAt == other.sortByCreatedAt &&
          limit == other.limit &&
          dateSorting == other.dateSorting;

  @override
  int get hashCode => Object.hashAll(
        [
          runtimeType,
          postId,
          dateSorting,
          limit,
          sortByCreatedAt,
        ],
      );
}
