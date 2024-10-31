import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/constant/box_key.dart';
import '../../../../core/constant/routes.dart';
import '../../../../core/extension/space_extension.dart';
import '../../../../core/widget/app_widget/text_input_field.dart';
import '../../../../core/widget/button/app_button.dart';
import '../../../../core/widget/pop_menu/app_pop_menu.dart';
import '../../../../core/widget/wolt_page/wolt_page.dart';
import '../../../../cubits/login_cubit/login_cubit.dart';
import '../../../../data/model/pop_menu_model/pop_menu_model.dart';
import '../../../../data/model/user_model/user_model.dart';
import '../../../../dependencies/dependencies_injection.dart';

class ClientDetailsAppbar extends StatelessWidget {
  const ClientDetailsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppPopMenu(
        items: [
          AppPopMenuItemModel(
            title: "نغيير الرقم السري",
            leading: EvaIcons.person,
            onTap: () async {
              WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (_) => [
                        woltPage(
                            onTapCancel: () {
                              context.pop();
                            },
                            title: 'تغيير الرقم السري',
                            child: BlocProvider.value(
                              value: context.read<LoginCubit>(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    10.gap,
                                    AppTextFormField(
                                      controller: context
                                          .read<LoginCubit>()
                                          .passwordController,
                                      labelFloating: "الرقم السري الجديد",
                                    ),
                                    20.gap,
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton.text(
                                          text: AppStrings.save.tr(),
                                          onPressed: () async {
                                            SmartDialog.showLoading(
                                                msg: AppStrings.loading.tr());
                                            if (context
                                                    .read<LoginCubit>()
                                                    .passwordController
                                                    .text
                                                    .length >=
                                                6) {
                                              await getIt<FirebaseAuth>()
                                                  .currentUser!
                                                  .updatePassword(context
                                                      .read<LoginCubit>()
                                                      .passwordController
                                                      .text
                                                      .trim());
                                            } else {
                                              SmartDialog.dismiss();
                                              SmartDialog.showNotify(
                                                  msg:
                                                      "يجب ان يكون الرقم السري على الاقل ٦ خانات",
                                                  notifyType: NotifyType.alert);
                                            }
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
          ),
          AppPopMenuItemModel(
            title: AppStrings.logout.tr(),
            leading: EvaIcons.log_out_outline,
            onTap: () async {
              SmartDialog.showLoading(msg: AppStrings.loading.tr());
              await getIt<FirebaseAuth>().signOut();
              await getIt<Box<UserModel>>().delete(BoxKey.user);
              context.go(AppRoutes.root);

              SmartDialog.dismiss();
            },
          ),
        ],
        child: const Icon(EvaIcons.settings),
      ),
    );
  }
}
