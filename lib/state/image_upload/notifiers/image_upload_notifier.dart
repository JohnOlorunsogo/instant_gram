import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instant_gram/state/auth/constants/firebase_collection_name.dart';
import 'package:instant_gram/state/image_upload/constants/constants.dart';
import 'package:instant_gram/state/image_upload/exceptions/could_not_build_thumbnail.dart';
import 'package:instant_gram/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:instant_gram/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:instant_gram/state/image_upload/models/file_type.dart';
import 'package:instant_gram/state/image_upload/typedef/is_loading.dart';
import 'package:instant_gram/state/post_settings/models/post_settings.dart';
import 'package:instant_gram/state/posts/models/post_payload.dart';
import 'package:instant_gram/state/posts/typedefs/user_id.dart';
import 'package:image/image.dart' as img;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSettings, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUint8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;

          CouldNotBuildThumbnail;
        } else {
          // create thumbnail\
          final thumbnail = img.copyResize(
            fileAsImage,
            width: Constants.imageThumbnailWidth,
          );
          final thumbnailData = img.encodeJpg(thumbnail);

          thumbnailUint8List = thumbnailData;
        }

        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaHeight,
          quality: Constants.videoThumbnailQuality,
        );

        if (thumb == null) {
          isLoading = false;
          CouldNotBuildThumbnail;
        } else {
          thumbnailUint8List = thumb;
        }
        break;
    }

    // calculate aspect ratio
    final thumbnailAspectRatio = await thumbnailUint8List.getAspectRatio();

    // calculate references
    final fileName = const Uuid().v4();

    //create references to thumbnail and image
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      // upload the thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUint8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      // upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      // create the post payload
      final postPayLoad = PostPayload(
        fileName: fileName,
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalFileStorageId,
        postSettings: postSettings,
      );

      // upload the post payload
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayLoad);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
