part of 'screen_cubit.dart';

@immutable
sealed class ScreenState {}

final class ScreenInitial extends ScreenState {}

final class ScreenMediaLoading extends ScreenState {}

final class ScreenMediaError extends ScreenState {
  final String errorMessage;

  ScreenMediaError(this.errorMessage);
}

final class ScreenMediaSuccessUpdate extends ScreenState {
  final String message;

  ScreenMediaSuccessUpdate(this.message);
}

final class ScreenMediaSuccess extends ScreenState {
  final List<MediaModel> mediaModel;
  final int index;

  ScreenMediaSuccess(this.mediaModel, {this.index = 0});
}

class MediaUploading extends ScreenState {
  final double progress;

  MediaUploading(this.progress);
}

class MediaUploadSuccess extends ScreenState {}

class MediaSelected extends ScreenState {
  final File file;
  final String mediaType;

  MediaSelected({required this.file, required this.mediaType});
}

class MediaSlidesLoaded extends ScreenState {
  final MediaModel media;

  MediaSlidesLoaded(this.media);

  List<Object?> get props => [media];
}
