import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image_plus/flutter_cached_network_image_plus.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_manager/flutter_cache_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/extension/space_extension.dart';
import '../../../../core/function/show_snackbar.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widget/app_widget/text_input_field.dart';
import '../../../../core/widget/button/app_button.dart';
import '../../../../core/widget/inner_setting_tile/setting_tile.dart';
import '../../../../core/widget/status_widget/empty.dart';
import '../../../../core/widget/status_widget/loading.dart';
import '../../../../core/widget/wolt_page/wolt_page.dart';
import '../../../../cubits/screen_cubit/screen_cubit.dart';
import '../../../../data/model/media_model/media_model.dart';
import '../../../../generated/assets.dart';
import '../../client_slider/widget/video_view.dart';

class ScreenGalleryBody extends StatelessWidget {
  final String userId;
  final String screenId;

  const ScreenGalleryBody(
      {super.key, required this.userId, required this.screenId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScreenCubit, ScreenState>(
      listener: (context, state) {
        if (state is ScreenMediaError) {
          showBar(
            title: AppStrings.error.tr(),
            message: state.errorMessage.tr(),
            contentType: ContentType.failure,
            context: context,
          );
          context
              .read<ScreenCubit>()
              .getMediaAsStream(userId: userId, screenId: screenId);
        } else if (state is ScreenMediaSuccessUpdate) {
          showBar(
            title: AppStrings.delete.tr(args: [""]),
            message: state.message.tr(),
            contentType: ContentType.success,
            context: context,
          );
          context
              .read<ScreenCubit>()
              .getMediaAsStream(userId: userId, screenId: screenId);
        } else if (state is MediaUploadSuccess) {
          SmartDialog.dismiss();
          showBar(
            title: AppStrings.success.tr(),
            message: 'تم رفع الملف بنجاح!',
            contentType: ContentType.success,
            context: context,
          );
        } else if (state is ScreenInitial) {
          context
              .read<ScreenCubit>()
              .getMediaAsStream(userId: userId, screenId: screenId);
        }
      },
      builder: (context, state) {
        if (state is MediaUploading) {
          return _buildUploadingState(state);
        } else if (state is MediaSelected) {
          return _buildMediaSelectedState(context, state);
        } else if (state is ScreenMediaLoading) {
          return const LoadingState();
        }

        return _buildDefaultState(context, state);
      },
    );
  }

  Widget _buildUploadingState(MediaUploading state) {
    SmartDialog.dismiss();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppStrings.loading.tr()),
          20.gap,
          CircularProgressIndicator(value: state.progress),
          20.gap,
          Text('${(state.progress * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
  }

  Widget _buildMediaSelectedState(BuildContext context, MediaSelected state) {
    SmartDialog.dismiss();

    return Column(
      children: [
        state.mediaType == AppStrings.image
            ? Image.file(state.file)
            : Expanded(child: ChewieWidget(file: state.file)),
        15.gap,
        Row(
          children: [
            // _buildTextInputField(
            //   context,
            //   controller: context.read<ScreenCubit>().sequenceController,
            //   label: "رقم الترتيب ",
            //   keyboardType: TextInputType.number,
            // ),
            _buildTextInputField(
              context,
              controller: context.read<ScreenCubit>().durationController,
              label: "مدة العرض بالثواني ",
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        10.gap,
        Row(
          children: [
            _buildUploadButton(context),
            _buildCancelButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildTextInputField(BuildContext context,
      {required TextEditingController controller,
      required String label,
      required TextInputType keyboardType}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AppTextFormField(
          controller: controller,
          labelFloating: label,
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AppButton.text(
          color: Colors.green,
          text: AppStrings.upload.tr(args: [""]),
          onPressed: () async {
            await context
                .read<ScreenCubit>()
                .uploadMedia(userId: userId, screenId: screenId);
          },
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: AppButton.text(
          color: Colors.red,
          text: AppStrings.cancel.tr(),
          onPressed: context.read<ScreenCubit>().clearMedia,
        ),
      ),
    );
  }

  Widget _buildDefaultState(BuildContext context, ScreenState state) {
    SmartDialog.dismiss();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClientActions(context),
        30.gap,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: AutoSizeText(
            "الملفات",
            style: AppTextStyle.style30B.copyWith(color: AppColor.primaryColor),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: _buildScreenList(context, state),
        ),
      ],
    );
  }

  Widget _buildClientActions(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildUploadTile(
            context,
            title: AppStrings.upload.tr(args: [AppStrings.image.tr()]),
            icon: EvaIcons.image,
            onTap: () =>
                context.read<ScreenCubit>().pickMedia(AppStrings.image),
          ),
          _buildUploadTile(
            context,
            title: AppStrings.upload.tr(args: [AppStrings.video.tr()]),
            icon: EvaIcons.video,
            onTap: () =>
                context.read<ScreenCubit>().pickMedia(AppStrings.video),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return SettingTile(
      title: title,
      trailing: icon,
      onTap: onTap,
    );
  }

  Widget _buildScreenList(BuildContext context, ScreenState state) {
    return state is ScreenMediaSuccess
        ? state.mediaModel.isEmpty
            ? const Empty(
                imageName: Assets.lottieNoData, title: AppStrings.noData)
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: state.mediaModel.length,
                itemBuilder: (_, index) {
                  return CupertinoContextMenu(
                    enableHapticFeedback: true,
                    actions: [
                      CupertinoContextMenuAction(
                        trailingIcon: CupertinoIcons.pencil,
                        onPressed: () async {
                          context.pop();
                          WoltModalSheet.show(
                              context: context,
                              pageListBuilder: (_) => [
                                    woltPage(
                                        onTapCancel: () {
                                          context.pop();
                                        },
                                        title: 'تغيير الترتيب',
                                        child: BlocProvider.value(
                                          value: context.read<ScreenCubit>(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                10.gap,
                                                AppTextFormField(
                                                  controller: context
                                                      .read<ScreenCubit>()
                                                      .sequenceController,
                                                  labelFloating: "رقم الترتيب",
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                20.gap,
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: AppButton.text(
                                                      text:
                                                          AppStrings.save.tr(),
                                                      onPressed: () async {
                                                        SmartDialog.showLoading(
                                                            msg: AppStrings
                                                                .loading
                                                                .tr());
                                                        await context
                                                            .read<ScreenCubit>()
                                                            .updateMedia(
                                                              clientId: userId,
                                                              screenId:
                                                                  screenId,
                                                              media: state
                                                                      .mediaModel[
                                                                  index],
                                                            );
                                                        SmartDialog.dismiss();
                                                        context.pop();
                                                      }),
                                                ),
                                                20.gap,
                                              ],
                                            ),
                                          ),
                                        ))
                                  ]);
                        },
                        child: const Text(
                          "تعديل ترتيب العنصر",
                          style: TextStyle(fontFamily: "Almarai"),
                        ),
                      ),
                      CupertinoContextMenuAction(
                        isDestructiveAction: true,
                        trailingIcon: CupertinoIcons.delete,
                        onPressed: () async {
                          SmartDialog.showLoading(msg: AppStrings.loading.tr());
                          await context.read<ScreenCubit>().deleteMedia(
                                clientId: userId,
                                screenId: screenId,
                                media: state.mediaModel[index],
                              );
                          SmartDialog.dismiss();
                          context.pop();
                        },
                        child: Text(
                          AppStrings.delete.tr(args: [""]),
                          style: const TextStyle(fontFamily: "Almarai"),
                        ),
                      ),
                    ],
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MediaPreviewScreen(
                                media: state.mediaModel[index]),
                          ),
                        );
                      },
                      child: GridTile(
                          child:
                              state.mediaModel[index].type == AppStrings.image
                                  ? CacheNetworkImagePlus(
                                      imageUrl: state.mediaModel[index].url,
                                      boxFit: BoxFit.cover)
                                  : VideoThumbnail(
                                      url: state.mediaModel[index].url)),
                    ),
                  );
                })
        : Container();
  }
}

class VideoThumbnail extends StatefulWidget {
  final String url;

  const VideoThumbnail({super.key, required this.url});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(widget.url);
    if (fileInfo != null) {
      _controller = VideoPlayerController.file(fileInfo.file)
        ..initialize().then((_) => setState(() {}));
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {});
          DefaultCacheManager().downloadFile(widget.url);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              const Icon(Icons.play_circle_outline,
                  color: Colors.white, size: 50),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class MediaPreviewScreen extends StatelessWidget {
  final MediaModel media;

  const MediaPreviewScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.name),
      ),
      body: Center(
        child: media.type == 'image'
            ? Image.network(media.url)
            : ReelsViewVideo(
                url: media.url,
                onComplete: () {},
                onError: (error) {},
                placeholder: const SizedBox.shrink(),
                isLooping: false,
              ),
      ),
    );
  }
}

class ChewieWidget extends StatelessWidget {
  final String? url;
  final File? file;

  const ChewieWidget({super.key, this.url, this.file});

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = file == null
        ? VideoPlayerController.networkUrl(Uri.parse(url!))
        : VideoPlayerController.file(file!);

    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    return Chewie(controller: chewieController);
  }
}
