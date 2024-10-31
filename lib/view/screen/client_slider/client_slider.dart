import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../core/constant/box_key.dart';
import '../../../cubits/screen_cubit/screen_cubit.dart';
import '../../../data/api/firebase/screen_media_data/screen_media_data.dart';
import '../../../dependencies/dependencies_injection.dart';
import '../../../main.dart';
import 'widget/client_slider_body.dart';

class ClientSlider extends StatelessWidget {
  const ClientSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? extra =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    logger.e(extra);
    final String userId = extra?['userId'] ?? getIt<Box>().get(BoxKey.userId);
    final String screenId =
        extra?['screenId'] ?? getIt<Box>().get(BoxKey.screenId);
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => ScreenCubit(getIt<ScreenMediaData>())
          ..getMediaAsStream(userId: userId, screenId: screenId),
        child: ClientSliderBody(userId: userId, screenId: screenId),
      ),
    );
  }
}
