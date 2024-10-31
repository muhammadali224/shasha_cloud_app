import 'package:easy_localization/easy_localization.dart';

import '../constant/app_strings.dart';

mixin FormValidationMixin {
  final _passwordRegEx = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  final _upperCaseRegEx = RegExp(r'[A-Z]');

  final _lowerCaseRegEx = RegExp(r'[a-z]');

  final _numberRegEx = RegExp(r'[0-9]');

  final _emailRegEx = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  final _mobileRegEx = RegExp(r'^[0-9]{10}$');

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyUserNameHint.tr();
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyMobileHint.tr();
    }
    if (!_mobileRegEx.hasMatch(value)) {
      return AppStrings.notValidMobileHint.tr();
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyEmailHint.tr();
    }
    if (!_emailRegEx.hasMatch(value)) {
      return AppStrings.notValidEmailHint.tr();
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyPasswordHint.tr();
    }

    if (value.length < 5) {
      return AppStrings.passwordValidateLengthHint.tr(args: ['5']);
    }

    if (!value.contains(_upperCaseRegEx)) {
      // return 'Password must contain at least 1 uppercase letter';
      return null;
    }

    if (!value.contains(_lowerCaseRegEx)) {
      // return 'Password must contain at least 1 lowercase letter';
      return null;
    }

    if (!value.contains(_numberRegEx)) {
      // return 'Password must contain at least 1 number';
      return null;
    }

    if (!_passwordRegEx.hasMatch(value)) {
      // return 'Password must contain at least 1 uppercase letter, 1 lowercase letter and 1 number';
      return null;
    }
    return null;
  }

  String? validateLength(
      {required String? value,
      required int minLength,
      required int maxLength}) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyFieldHint.tr();
    }
    if (value.length < minLength) {
      return AppStrings.minValidateHint.tr(args: [minLength.toString()]);
    }
    if (value.length > maxLength) {
      return AppStrings.maxValidateHint.tr(args: [maxLength.toString()]);
    }
    return null;
  }
}
