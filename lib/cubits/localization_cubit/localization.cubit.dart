import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../core/constant/box_key.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit._internal() : super(const Locale(BoxKey.arLanguage));
  static final LanguageCubit _instance = LanguageCubit._internal();

  factory LanguageCubit() {
    return _instance;
  }

  void changeLanguage(Locale locale) {
    emit(locale);
  }
}
