import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeType {
  light,
  dark
}

class ThemeNotifier extends StateNotifier<ThemeType> {

  ThemeNotifier() : super(ThemeType.light);

}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeType>((ref) => ThemeNotifier());