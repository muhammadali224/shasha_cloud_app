import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constant/app_strings.dart';
import '../../../../core/constant/box_key.dart';
import '../../../../core/constant/routes.dart';
import '../../../../core/extension/space_extension.dart';
import '../../../../core/function/show_snackbar.dart';
import '../../../../core/mixin/validate.mixin.dart';
import '../../../../core/widget/app_widget/text_input_field.dart';
import '../../../../core/widget/button/app_button.dart';
import '../../../../cubits/login_cubit/login_cubit.dart';
import '../../../../data/model/user_model/user_model.dart';
import '../../../../dependencies/dependencies_injection.dart';

class LoginBody extends StatelessWidget with FormValidationMixin {
  LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          showBar(
              title: AppStrings.success.tr(),
              message: AppStrings.success.tr(),
              contentType: ContentType.success,
              context: context);
          await getIt<Box>().put(BoxKey.adminCreated, true);

          await getIt<Box<UserModel>>().put(BoxKey.user, state.user);
          if (state.user.role == "admin") {
            context.go(AppRoutes.home);
          } else {
            context.go(AppRoutes.clientDetails);
          }
        } else if (state is LoginFailure) {
          showBar(
              title: AppStrings.error.tr(),
              message: state.error.tr(),
              contentType: ContentType.failure,
              context: context);
        } else if (state is LoginSuccessToScreen) {
          await getIt<Box>().put(BoxKey.step, "1");
          await getIt<Box>().put(BoxKey.userId, state.userId);
          await getIt<Box>().put(BoxKey.screenId, state.screenId);
          context.go(AppRoutes.clientHome, extra: {
            'userId': state.userId,
            'screenId': state.screenId,
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: context.read<LoginCubit>().formKey,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Lottie.network(
                    "https://lottie.host/24e35d89-3bae-4292-9289-4ff0e5d306e8/vJWYZosd0Y.json",
                    repeat: false),
              ),
              15.gap,
              AppTextFormField(
                hintText: AppStrings.email.tr(),
                controller: context.read<LoginCubit>().emailController,
                suffixIconAssetName: Icons.alternate_email,
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              10.gap,
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return AppTextFormField(
                    hintText: AppStrings.password.tr(),
                    controller: context.read<LoginCubit>().passwordController,
                    suffixIconAssetName: Icons.password,
                    validator: validatePassword,
                    obscureText:
                        state is ToggleObscure ? state.isObscure : true,
                    onTapSuffix: () {
                      context.read<LoginCubit>().toggleObscureText();
                    },
                  );
                },
              ),
              20.gap,
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: state is LoginLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton.icon(
                            text: AppStrings.login.tr(),
                            trailingIconAssetName: Icons.arrow_forward,
                            onPressed: () async {
                              await context.read<LoginCubit>().login();
                            },
                          ),
                  );
                },
              ),
              10.gap,
              const Text("أو"),
              15.gap,
              AppTextFormField(
                hintText: AppStrings.screenInterCode.tr(),
                controller: context.read<LoginCubit>().screenCode,
                suffixIconAssetName: Icons.tag,
              ),
              10.gap,
              SizedBox(
                width: double.infinity,
                child: AppButton.icon(
                  text: "ذهاب",
                  trailingIconAssetName: Icons.arrow_forward,
                  onPressed: () async {
                    SmartDialog.showLoading(msg: AppStrings.loading.tr());
                    await context.read<LoginCubit>().getUser();
                    SmartDialog.dismiss();
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
