import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView {
  final UserId userId;
  final String displayName;
  final String? email;

  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email,
        });

  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          displayName: json[FirebaseFieldName.displayName] ?? '',
          email: json[FirebaseFieldName.email],
          userId: userId,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          email == other.email;

  @override
  int get hashCode => Object.hashAll(
        [
          userId,
          displayName,
          email,
        ],
      );
}
