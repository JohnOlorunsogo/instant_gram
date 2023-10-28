import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/constants/firebase_field_name.dart';
import 'package:instant_gram/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';
import 'package:instant_gram/state/posts/models/post.dart';
import 'package:instant_gram/state/posts/typedefs/post_id.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> deletePost({required Post post}) async {
    try {
      isLoading = true;

      // delete post thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      // delete post original file: video or image
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.originalFileStorageId)
          .delete();

      // delete all comments associated with the post
      await _deleteAllDoc(
        postId: post.postId,
        inCollection: FirebaseCollectionName.comments,
      );

      // delete all likes associated with the post
      await _deleteAllDoc(
        postId: post.postId,
        inCollection: FirebaseCollectionName.likes,
      );

      // delete post itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.posts,
          )
          .where(
            // FirebaseCollectionName.posts,
            FieldPath.documentId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();

      for (final doc in postInCollection.docs) {
        await doc.reference.delete();
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDoc({
    required PostId postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(
              inCollection,
            )
            .where(
              FirebaseFieldName.postId,
              isEqualTo: postId,
            )
            .get();

        for (final doc in query.docs) {
          transaction.delete(
            doc.reference,
          );
        }
      },
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
    );
  }
}
