import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/constant/routes.dart';
import '../../../../core/extension/space_extension.dart';
import '../../../../core/function/show_snackbar.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/text_style.dart';
import '../../../../core/widget/inner_setting_tile/setting_tile.dart';
import '../../../../core/widget/status_widget/empty.dart';
import '../../../../core/widget/status_widget/error.dart';
import '../../../../core/widget/status_widget/loading.dart';
import '../../../../cubits/client_cubit/client_cubit.dart';
import '../../../../generated/assets.dart';

class ClientDetailsBody extends StatelessWidget {
  final String id;

  const ClientDetailsBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          child: SettingTile(
              trailing: Icons.add,
              onTap: () async {
                await context.read<ClientCubit>().addClientScreen(id);
              },
              title: AppStrings.add.tr(args: [AppStrings.displayScreen.tr()])),
        ),
        30.gap,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: AutoSizeText(
            "الشاشات",
            style: AppTextStyle.style30B.copyWith(color: AppColor.primaryColor),
            textAlign: TextAlign.start,
          ),
        ),
        BlocConsumer<ClientCubit, ClientState>(
          builder: (context, state) {
            if (state is ClientLoading) {
              return const LoadingState();
            } else if (state is ClientError) {
              return ErrorScreen(errorMessage: state.message);
            } else if (state is ClientSuccess) {
              SmartDialog.dismiss();
              state.clientData.sort((a, b) => (a['dateCreated'] as Timestamp)
                  .toDate()
                  .compareTo((b['dateCreated'] as Timestamp).toDate()));
              return state.clientData.isNotEmpty
                  ? Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.clientData.length,
                            itemBuilder: (_, index) => SwipeActionCell(
                                  key: ObjectKey(state.clientData[index]['id']),
                                  trailingActions: <SwipeAction>[
                                    SwipeAction(
                                        title: AppStrings.delete.tr(args: [""]),
                                        onTap:
                                            (CompletionHandler handler) async {
                                          await handler(true);
                                          await context
                                              .read<ClientCubit>()
                                              .deleteClientScreen(
                                                  id,
                                                  state.clientData[index]
                                                      ['id']);
                                        },
                                        color: Colors.red),
                                  ],
                                  child: GestureDetector(
                                    onLongPress: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: state.clientData[index]['id']));
                                      SmartDialog.showNotify(
                                        msg: "تم نسخ رمز الدخول للشاشة",
                                        notifyType: NotifyType.success,
                                      );
                                    },
                                    child: SettingTile(
                                      title:
                                          "${AppStrings.displayScreen.tr()} ${index + 1}",
                                      subtitle: state.clientData[index]['id'],
                                      onTap: () {
                                        context.push(AppRoutes.screenGallery,
                                            extra: {
                                              'id': state.clientData[index]
                                                  ['id'],
                                              'userId': id,
                                              'index': index + 1,
                                            });
                                      },
                                    ),
                                  ),
                                )),
                      ),
                    )
                  : const Empty(
                      imageName: Assets.lottieNoData, title: AppStrings.noData);
            }

            return Container();
          },
          listener: (BuildContext context, ClientState state) {
            if (state is ClientError) {
              showBar(
                title: AppStrings.error.tr(),
                message: state.message.tr(),
                contentType: ContentType.failure,
                context: context,
              );
              context.read<ClientCubit>().getClientsAsStream(id);
            }
          },
        ),
      ],
    );
  }
}
