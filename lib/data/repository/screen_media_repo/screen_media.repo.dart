import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../model/media_model/media_model.dart';
import '../../model/screen_media_model/screen_media_model.dart';

abstract class ScreenMediaRepository {
  Stream<Either<Failure, ScreenMediaModel>> getMediaStream(
      {required String screenId, required String userId});

  Future<Either<Failure, Map<String, dynamic>>> uploadMedia(
    String userId,
    File file,
    String mediaType,
    Function(double) onProgress,
  );

  Future<Either<Failure, Success>> saveMediaMetadata(
    String userId,
    String screenId,
    MediaModel media,
  );

  Future<Either<Failure, Success>> deleteMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  });

  Future<Either<Failure, Success>> updateMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  });
}
