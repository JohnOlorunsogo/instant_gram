import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';
import 'package:instant_gram/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      //first check if user info is already saved in firestore
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        // user info is already saved in firestore
        await userInfo.docs.first.reference.update(
          {
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.email: email ?? '',
          },
        );

        return true;
      }

      // user info is not saved in firestore, new user
      final payload = UserInfoPayload(
        displayName: displayName,
        email: email,
        userId: userId,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .add(
            payload,
          );
      return true;
    } catch (e) {
      return false;
    }
  }
}
