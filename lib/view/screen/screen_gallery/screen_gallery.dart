import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constant/app_strings.dart';
import '../../../cubits/screen_cubit/screen_cubit.dart';
import '../../../data/api/firebase/screen_media_data/screen_media_data.dart';
import '../../../dependencies/dependencies_injection.dart';
import 'widget/screen_gallery_body.dart';

class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("${AppStrings.displayScreen.tr()} ${extra['index']}"),
      ),
      body: BlocProvider(
        create: (context) => ScreenCubit(getIt<ScreenMediaData>())
          ..getMediaAsStream(userId: extra['userId'], screenId: extra['id']),
        child:
            ScreenGalleryBody(userId: extra['userId'], screenId: extra['id']),
      ),
    );
  }
}
