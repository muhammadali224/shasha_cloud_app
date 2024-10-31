import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../core/constant/app_strings.dart';
import '../../core/errors/failure.dart';
import '../../data/model/media_model/media_model.dart';
import '../../data/model/screen_media_model/screen_media_model.dart';
import '../../data/repository/screen_media_repo/screen_media.repo.dart';
import '../../main.dart';

part 'screen_state.dart';

class ScreenCubit extends Cubit<ScreenState> {
  final ScreenMediaRepository _mediaRepository;
  TextEditingController sequenceController = TextEditingController(text: "1");
  TextEditingController durationController = TextEditingController(text: "5");
  StreamSubscription<Either<Failure, ScreenMediaModel>>? _streamSubscription;
  int _currentIndex = 0;

  ScreenCubit(this._mediaRepository) : super(ScreenInitial());

  Future<void> pickMedia(String pickType) async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = pickType == AppStrings.image
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      if (pickType == AppStrings.video) {
        final VideoPlayerController controller =
            VideoPlayerController.file(file);

        await controller.initialize();
        final Duration videoDuration = controller.value.duration;
        durationController.text = videoDuration.inSeconds.toString();
        controller.dispose();
      }
      emit(MediaSelected(
        file: file,
        mediaType: pickType,
      ));
    } else {
      emit(ScreenMediaError(pickType == AppStrings.image
          ? AppStrings.selectImageError
          : AppStrings.selectVideoError));
    }
  }

  Future<void> uploadMedia(
      {required String userId, required String screenId}) async {
    if (state is! MediaSelected) return;
    final selectedState = state as MediaSelected;

    emit(MediaUploading(0));

    final Either<Failure, Map<String, dynamic>> result =
        await _mediaRepository.uploadMedia(
      userId,
      selectedState.file,
      selectedState.mediaType,
      (progress) {
        emit(MediaUploading(progress));
      },
    );

    result.fold(
      (failure) => emit(ScreenMediaError(failure.message)),
      (map) async {
        final media = MediaModel(
          name: map['name'],
          type: selectedState.mediaType,
          url: map['url'],
          sequenceNo: 999,
          displayDuration: int.parse(durationController.text),
          dateCreated: DateTime.now(),
          id: DateTime.now().toString(),
        );

        final saveResult =
            await _mediaRepository.saveMediaMetadata(userId, screenId, media);

        saveResult.fold(
          (failure) => emit(ScreenMediaError(failure.message)),
          (success) => emit(MediaUploadSuccess()),
        );
      },
    );
  }

  void setAutoPlay(int i) {
    if (state is ScreenMediaSuccess) {
      final currentState = state as ScreenMediaSuccess;
      emit(ScreenMediaSuccess(currentState.mediaModel, index: i));
    }
  }

  void clearMedia() {
    emit(ScreenInitial());
  }

  void getMediaAsStream({required String userId, required String screenId}) {
    emit(ScreenMediaLoading());

    _streamSubscription?.cancel();

    _streamSubscription = _mediaRepository
        .getMediaStream(screenId: screenId, userId: userId)
        .listen((result) {
      result.fold(
        (failure) => emit(ScreenMediaError(failure.message)),
        (model) {
          List<MediaModel> sortedMediaModel = List.from(model.mediaList)
            ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo));
          // bool autoPlay =
          //     (!sortedMediaModel.any((e) => e.type == AppStrings.video));
          logger.d(sortedMediaModel.toString());
          emit(ScreenMediaSuccess(sortedMediaModel));
        },
      );
    });
  }

  Future<void> startPlayer(List<MediaModel> mediaList) async {
    if (_currentIndex >= mediaList.length) {
      _currentIndex = 0;
    }

    emit(MediaSlidesLoaded(mediaList[_currentIndex]));

    await Future.delayed(
        Duration(seconds: mediaList[_currentIndex].displayDuration));

    _currentIndex++;

    await startPlayer(mediaList);
  }

  Future<void> deleteMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  }) async {
    var result = await _mediaRepository.deleteMedia(
        clientId: clientId, screenId: screenId, media: media);

    result.fold(
      (failure) => emit(ScreenMediaError(failure.message)),
      (success) {
        emit(ScreenMediaSuccessUpdate(success.message));
        emit(ScreenInitial());
      },
    );
  }

  Future<void> updateMedia({
    required String clientId,
    required String screenId,
    required MediaModel media,
  }) async {
    MediaModel updatedModel =
        media.copyWith(sequenceNo: int.parse(sequenceController.text.trim()));
    var result = await _mediaRepository.updateMedia(
        clientId: clientId, screenId: screenId, media: updatedModel);

    result.fold(
      (failure) => emit(ScreenMediaError(failure.message)),
      (success) {
        emit(ScreenMediaSuccessUpdate(success.message));
        emit(ScreenInitial());
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    sequenceController.dispose();
    durationController.dispose();
    return super.close();
  }
}
