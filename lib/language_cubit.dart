import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale?> {
  final BuildContext context;

  LanguageCubit(this.context) : super(null);

  change(Locale? locale) {
    emit(locale);
  }
}
