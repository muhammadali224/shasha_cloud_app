import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/dio_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../dependencies/dependencies_injection.dart';
import '../../../model/media_model/media_model.dart';
import '../../../model/screen_media_model/screen_media_model.dart';
import '../../../repository/screen_media_repo/screen_media.repo.dart';

class ScreenMediaData implements ScreenMediaRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _storage = getIt<FirebaseStorage>();

  ScreenMediaData({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  @override
  Stream<Either<Failure, ScreenMediaModel>> getMediaStream(
      {required String screenId, required String userId}) async* {
    try {
      yield* _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('screens')
          .doc(screenId)
          .snapshots()
          .map((querySnapshot) {
        if (querySnapshot.exists) {
          final media = ScreenMediaModel.fromDocumentSnapshot(querySnapshot);
          return right(media);
        } else {
          return left(ServerFailure(message: 'Media not found'));
        }
      });
    } catch (e) {
      yield left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> saveMediaMetadata(
      String clientId, String screenId, MediaModel media) async {
    try {
      final clientDocRef = _firebaseFirestore
          .collection('users')
          .doc(clientId)
          .collection("screens")
          .doc(screenId);

      await clientDocRef.update({
        'mediaList': FieldValue.arrayUnion([media.toJson()])
      });

      return right(ServiceSuccess(message: 'Media uploaded successfully'));
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadMedia(String clientId,
      File file, String mediaType, Function(double p1) onProgress) async {
    try {
      final String name = "${DateTime.now().millisecondsSinceEpoch}_$mediaType";

      final String filePath = 'users/$clientId/$name';
      final storageRef = _storage.ref().child(filePath);

      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        final progress = event.bytesTransferred / event.totalBytes;
        onProgress(progress);
      });

      await uploadTask.whenComplete(() {});

      final downloadUrl = await storageRef.getDownloadURL();
      return right({
        'url': downloadUrl,
        'name': name,
      });
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> deleteMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  }) async {
    try {
      final storageRef = _storage.ref().child('users/$clientId/${media.name}');
      await storageRef.delete();

      final clientDocRef = _firebaseFirestore
          .collection('users')
          .doc(clientId)
          .collection('screens')
          .doc(screenId);

      await clientDocRef.update({
        'mediaList': FieldValue.arrayRemove([media.toJson()])
      });

      return right(ServiceSuccess(message: 'Media deleted successfully'));
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Success>> updateMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  }) async {
    try {
      final clientDocRef = _firebaseFirestore
          .collection('users')
          .doc(clientId)
          .collection('screens')
          .doc(screenId);

      // await clientDocRef.update({
      //   'mediaList': FieldValue.arrayRemove([media.toJson()])
      // });
      //
      // await clientDocRef.update({
      //   'mediaList': FieldValue.arrayUnion([media.toJson()])
      // });
      // return right(ServiceSuccess(message: 'Media Updated successfully'));
      DocumentSnapshot docSnapshot = await clientDocRef.get();
      if (!docSnapshot.exists) {
        return left(ServerFailure(message: 'Document not found'));
      }
      List mediaList = docSnapshot['mediaList'] ?? [];
      List<MediaModel> mediaModels =
          mediaList.map((mediaItem) => MediaModel.fromJson(mediaItem)).toList();
      int index = mediaModels.indexWhere((item) => item.id == media.id);
      if (index == -1) {
        return left(ServerFailure(message: 'Media not found'));
      }
      mediaModels[index] = media;
      List updatedMediaList = mediaModels.map((item) => item.toJson()).toList();
      await clientDocRef.update({'mediaList': updatedMediaList});
      return right(ServiceSuccess(message: 'Media updated successfully'));
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebase(e));
      }
      return left(ServerFailure(message: e.toString()));
    }
  }
}
