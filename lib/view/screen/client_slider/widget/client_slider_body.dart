import 'package:cached_network_image_plus/flutter_cached_network_image_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../cubits/screen_cubit/screen_cubit.dart';
import '../../../../main.dart';
import 'video_view.dart';

class ClientSliderBody extends StatelessWidget {
  final String userId;
  final String screenId;

  const ClientSliderBody(
      {super.key, required this.userId, required this.screenId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScreenCubit, ScreenState>(
      listener: (context, state) {
        if (state is ScreenMediaSuccess) {
          WakelockPlus.enable();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
          });
        }
      },
      builder: (context, state) {
        if (state is ScreenMediaSuccess) {
          return state.mediaModel.isNotEmpty
              ? FlutterCarousel(
                  items: state.mediaModel
                      .map((e) => e.type == AppStrings.image
                          ? CacheNetworkImagePlus(
                              imageUrl: e.url,
                              boxFit: BoxFit.fill,
                              height: double.infinity,
                              width: double.infinity,
                            )
                          : ReelsViewVideo(
                              url: e.url,
                              onComplete: () {
                                context
                                    .read<ScreenCubit>()
                                    .setAutoPlay(state.index);
                              },
                              onError: (error) {},
                              placeholder: const Center(
                                  child: CircularProgressIndicator()),
                              isLooping: !(state.mediaModel.length > 1),
                            ))
                      .toList(),
                  options: FlutterCarouselOptions(
                    autoPlayInterval: Duration(
                        seconds: state.mediaModel[state.index].displayDuration),
                    height: double.maxFinite,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      context.read<ScreenCubit>().setAutoPlay(index);
                      logger.e(
                          "${state} - ${state.index} - ${state.mediaModel[index].type} ");
                    },
                    showIndicator: false,
                    autoPlay: true,
                    pageSnapping: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ))
              : Center(
                  child: Text(
                    "No Media found",
                    style: AppTextStyle.style26B.copyWith(color: Colors.white),
                  ),
                );
        }
        return Container();
      },
    );
  }
}
