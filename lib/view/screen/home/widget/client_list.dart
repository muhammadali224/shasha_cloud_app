import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/constant/routes.dart';
import '../../../../core/widget/inner_setting_tile/setting_tile.dart';
import '../../../../core/widget/status_widget/empty.dart';
import '../../../../core/widget/status_widget/error.dart';
import '../../../../core/widget/status_widget/loading.dart';
import '../../../../cubits/home_cubit/home_cubit.dart';
import '../../../../generated/assets.dart';

class ClientList extends StatelessWidget {
  const ClientList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const LoadingState();
        } else if (state is HomeError) {
          return ErrorScreen(errorMessage: state.errorMessage);
        } else if (state is HomeLoaded) {
          SmartDialog.dismiss();

          return state.clients.isNotEmpty
              ? ListView.builder(
                  itemCount: state.clients.length,
                  itemBuilder: (_, index) =>
                      state.clients[index].role != "admin"
                          ? SettingTile(
                              title: state.clients[index].name,
                              subtitle: state.clients[index].email,
                              onTap: () {
                                context.push(AppRoutes.clientDetails,
                                    extra: state.clients[index].id);
                              },
                            )
                          : const SizedBox.shrink())
              : const Empty(
                  imageName: Assets.lottieNoData, title: AppStrings.noData);
        }
        return Container();
      },
    );
  }
}
