import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
import '../../../../core/function/show_snackbar.dart';
import '../../../../core/mixin/validate.mixin.dart';
import '../../../../core/widget/app_widget/text_input_field.dart';
import '../../../../core/widget/button/app_button.dart';
import '../../../../core/widget/pop_menu/app_pop_menu.dart';
import '../../../../core/widget/wolt_page/wolt_page.dart';
import '../../../../cubits/login_cubit/login_cubit.dart';
import '../../../../data/model/pop_menu_model/pop_menu_model.dart';
import '../../../../data/model/user_model/user_model.dart';
import '../../../../dependencies/dependencies_injection.dart';

class AppBarMenuAction extends StatelessWidget with FormValidationMixin {
  AppBarMenuAction({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppPopMenu(
        items: [
          AppPopMenuItemModel(
            title: AppStrings.add.tr(args: [AppStrings.client.tr()]),
            leading: EvaIcons.plus,
            onTap: () => _showAddClientModal(context, loginCubit),
          ),
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
                                      controller: loginCubit.passwordController,
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
                                            if (loginCubit.passwordController
                                                    .text.length >=
                                                6) {
                                              await getIt<FirebaseAuth>()
                                                  .currentUser!
                                                  .updatePassword(loginCubit
                                                      .passwordController.text
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
            onTap: () => _logout(context),
          ),
        ],
        child: const Icon(EvaIcons.settings),
      ),
    );
  }

  Future<void> _showAddClientModal(
      BuildContext context, LoginCubit loginCubit) async {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (_) => [
        woltPage(
          onTapCancel: () => context.pop(),
          title: AppStrings.add.tr(args: [AppStrings.client.tr()]),
          child: BlocProvider.value(
            value: loginCubit,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: BlocListener<LoginCubit, LoginState>(
                listener: (context, state) async {
                  SmartDialog.dismiss();
                  if (state is LoginSuccessRegister) {
                    context.pop();
                  } else if (state is LoginLoading) {
                    SmartDialog.showLoading(msg: AppStrings.loading.tr());
                  } else if (state is LoginFailure) {
                    showBar(
                      title: AppStrings.error.tr(),
                      message: state.error.tr(),
                      contentType: ContentType.failure,
                      context: context,
                    );
                  }
                },
                child: Form(
                  key: loginCubit.formKey,
                  child: Column(
                    children: [
                      _buildEmailField(loginCubit),
                      10.gap,
                      _buildNameField(loginCubit),
                      10.gap,
                      // _buildScreenNumberField(loginCubit),
                      // 20.gap,
                      _buildAddButton(context, loginCubit),
                    ],
                  ),
                ),
              ),
            ),
          ),
          withBackButton: false,
        ),
      ],
    );
  }

  Widget _buildEmailField(LoginCubit loginCubit) {
    return AppTextFormField(
      labelFloating: AppStrings.email.tr(),
      controller: loginCubit.emailController,
      suffixIconAssetName: Icons.alternate_email,
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildNameField(LoginCubit loginCubit) {
    return AppTextFormField(
      labelFloating: AppStrings.nameAr.tr(),
      controller: loginCubit.nameController,
      suffixIconAssetName: Icons.person,
      validator: (val) =>
          validateLength(value: val, minLength: 4, maxLength: 150),
    );
  }

  // Widget _buildScreenNumberField(LoginCubit loginCubit) {
  //   return AppTextFormField(
  //     labelFloating: AppStrings.displayScreenNumber.tr(),
  //     controller: loginCubit.screenNumber,
  //     suffixIconAssetName: Icons.numbers,
  //     keyboardType: TextInputType.number,
  //     validator: (val) =>
  //         validateLength(value: val, minLength: 1, maxLength: 3),
  //   );
  // }

  Widget _buildAddButton(BuildContext context, LoginCubit loginCubit) {
    return SizedBox(
      width: double.infinity,
      child: AppButton.text(
        text: AppStrings.add.tr(args: [""]),
        onPressed: () => _onAddClientPressed(context, loginCubit),
      ),
    );
  }

  Future<void> _onAddClientPressed(
      BuildContext context, LoginCubit loginCubit) async {
    await loginCubit.register();
  }

  Future<void> _logout(BuildContext context) async {
    SmartDialog.showLoading(msg: AppStrings.loading.tr());
    await getIt<FirebaseAuth>().signOut();
    await getIt<Box<UserModel>>().delete(BoxKey.user);
    context.go(AppRoutes.root);

    SmartDialog.dismiss();
  }
}
