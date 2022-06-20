import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example/providers/providers.dart';

ThemeData get lightTheme => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
      ),
      useMaterial3: true,
    );
ThemeData get darkTheme => ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

final themeProvider = StateNotifierProvider<_ThemeController, ThemeMode>(
  (ref) => _ThemeController(ref.read),
);

class _ThemeController extends StateNotifier<ThemeMode> {
  _ThemeController(this._read) : super(ThemeMode.system);

  final Reader _read;

  Future<void> showThemeSelection() async {
    state = (await showModalActionSheet(
      context: _read(navigatorKeyProvider).currentContext!,
      title: 'Theme',
      message: 'Current: ${describeEnum(state)}',
      actions: ThemeMode.values
          .map(
            (mode) => SheetAction(
              label: describeEnum(mode),
              key: mode,
            ),
          )
          .toList(),
    ))!;
  }
}
